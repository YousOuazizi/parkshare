/**
 * Application Entry Point
 * Configure and bootstrap the NestJS application with security best practices
 */

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe, VersioningType, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import * as compression from 'compression';
import * as cookieParser from 'cookie-parser';
import { json, urlencoded } from 'express';

// Import global filters and interceptors
import { AllExceptionsFilter } from './core/filters/all-exceptions.filter';
import { LoggingInterceptor } from './core/interceptors/logging.interceptor';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  const nodeEnv = configService.get<string>('NODE_ENV', 'development');
  const port = configService.get<number>('PORT', 3000);
  const apiPrefix = configService.get<string>('API_PREFIX', 'api');
  const isProduction = nodeEnv === 'production';

  // ==========================================
  // SECURITY MIDDLEWARE
  // ==========================================

  // Request size limits to prevent DoS attacks
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));

  // Security headers with Helmet
  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          scriptSrc: ["'self'"],
          imgSrc: ["'self'", 'data:', 'https:'],
          connectSrc: ["'self'"],
          fontSrc: ["'self'"],
          objectSrc: ["'none'"],
          mediaSrc: ["'self'"],
          frameSrc: ["'none'"],
        },
      },
      crossOriginEmbedderPolicy: false,
      hsts: {
        maxAge: 31536000, // 1 year
        includeSubDomains: true,
        preload: true,
      },
    }),
  );

  // HTTPS enforcement in production
  if (isProduction) {
    app.use((req, res, next) => {
      const proto = req.header('x-forwarded-proto');
      if (proto && proto !== 'https') {
        res.redirect(301, `https://${req.header('host')}${req.url}`);
      } else {
        next();
      }
    });
  }

  // Compression for response payloads
  app.use(compression());

  // Cookie parser
  app.use(cookieParser(configService.get<string>('COOKIE_SECRET')));

  // ==========================================
  // CORS CONFIGURATION
  // ==========================================

  const corsOrigin = configService.get<string>('CORS_ORIGIN', '*');

  // Parse CORS origin (can be comma-separated list)
  const allowedOrigins = corsOrigin.includes(',')
    ? corsOrigin.split(',').map((origin) => origin.trim())
    : [corsOrigin];

  // Validate CORS in production
  if (isProduction && allowedOrigins.includes('*')) {
    throw new Error(
      'SECURITY ERROR: CORS wildcard (*) is not allowed in production. Set CORS_ORIGIN environment variable.',
    );
  }

  app.enableCors({
    origin: (origin, callback) => {
      // Allow requests with no origin (like mobile apps or curl)
      if (!origin) {
        return callback(null, true);
      }

      if (allowedOrigins.includes('*') || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        logger.warn(`CORS blocked request from origin: ${origin}`);
        callback(new Error('Not allowed by CORS'));
      }
    },
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    credentials: true,
    maxAge: 3600, // Cache preflight requests for 1 hour
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  });

  // ==========================================
  // GLOBAL PREFIX & VERSIONING
  // ==========================================

  app.setGlobalPrefix(apiPrefix);

  // Enable API versioning
  app.enableVersioning({
    type: VersioningType.URI,
    defaultVersion: '1',
  });

  // ==========================================
  // GLOBAL FILTERS & INTERCEPTORS
  // ==========================================

  // Global exception filter (must be first)
  app.useGlobalFilters(new AllExceptionsFilter());

  // Global logging interceptor
  app.useGlobalInterceptors(new LoggingInterceptor());

  // ==========================================
  // GLOBAL VALIDATION PIPE
  // ==========================================

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // Strip properties not in DTO
      transform: true, // Transform payloads to DTO instances
      forbidNonWhitelisted: true, // Throw error on unknown properties
      transformOptions: {
        enableImplicitConversion: true, // Enable type conversion
      },
      disableErrorMessages: isProduction, // Hide detailed validation errors in production
    }),
  );

  // ==========================================
  // SWAGGER API DOCUMENTATION
  // ==========================================

  if (!isProduction) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle('ParkShare API')
      .setDescription(
        'RESTful API for ParkShare - A parking space sharing marketplace',
      )
      .setVersion('1.0.0')
      .addTag('auth', 'Authentication and authorization endpoints')
      .addTag('users', 'User management endpoints')
      .addTag('parkings', 'Parking listing management')
      .addTag('bookings', 'Booking management')
      .addTag('payments', 'Payment processing with Stripe')
      .addTag('notifications', 'User notifications')
      .addTag('reviews', 'Rating and review system')
      .addTag('verification', 'Progressive user verification system')
      .addTag('subscriptions', 'Subscription management')
      .addTag('spotswap', 'Parking spot swapping')
      .addTag('analytics', 'Usage analytics and reporting')
      .addTag('pricing', 'Dynamic pricing engine')
      .addTag('health', 'Health check endpoints')
      .addBearerAuth(
        {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          name: 'Authorization',
          description: 'Enter JWT access token',
          in: 'header',
        },
        'JWT-auth',
      )
      .setContact(
        'ParkShare Support',
        'https://parkshare.com',
        'support@parkshare.com',
      )
      .setLicense('MIT', 'https://opensource.org/licenses/MIT')
      .addServer(`http://localhost:${port}`, 'Local Development')
      .addServer('https://api.parkshare.com', 'Production')
      .build();

    const document = SwaggerModule.createDocument(app, swaggerConfig);
    SwaggerModule.setup(`${apiPrefix}/docs`, app, document, {
      swaggerOptions: {
        persistAuthorization: true, // Keep auth token between page refreshes
        docExpansion: 'none', // Collapse all endpoints by default
        filter: true, // Enable filtering
        showRequestDuration: true, // Show request duration
      },
    });

    logger.log(`Swagger documentation available at http://localhost:${port}/${apiPrefix}/docs`);
  }

  // ==========================================
  // GRACEFUL SHUTDOWN
  // ==========================================

  app.enableShutdownHooks();

  // Handle shutdown signals
  process.on('SIGTERM', async () => {
    logger.log('SIGTERM signal received: closing HTTP server');
    await app.close();
    process.exit(0);
  });

  process.on('SIGINT', async () => {
    logger.log('SIGINT signal received: closing HTTP server');
    await app.close();
    process.exit(0);
  });

  // ==========================================
  // START SERVER
  // ==========================================

  await app.listen(port, '0.0.0.0');

  logger.log(`🚀 Application is running in ${nodeEnv} mode`);
  logger.log(`🌍 Server listening on http://localhost:${port}/${apiPrefix}`);
  logger.log(`📚 API documentation: http://localhost:${port}/${apiPrefix}/docs`);
  logger.log(`💚 Health check: http://localhost:${port}/health`);

  if (isProduction) {
    logger.log('🔒 Production security features enabled');
  } else {
    logger.warn('⚠️  Running in development mode - security features relaxed');
  }
}

bootstrap().catch((error) => {
  const logger = new Logger('Bootstrap');
  logger.error('Failed to start application', error);
  process.exit(1);
});

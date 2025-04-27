import { NestFactory, Reflector } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { LoggingInterceptor } from './core/interceptors/logging.interceptor';
import { HttpExceptionFilter } from './core/filters/http-exception.filter';
import helmet from 'helmet'; // Modifiez l'import ici
import * as compression from 'compression';
import * as cookieParser from 'cookie-parser';
import { VerificationRequirementsInterceptor } from './core/interceptors/verification-requirements.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);
  
  // Middleware de sécurité
  app.use(helmet());
  
  // Compression pour réduire la taille des réponses
  app.use(compression());
  
  // Parser les cookies
  app.use(cookieParser());
  
  // Configuration CORS
  app.enableCors({
    origin: configService.get<string>('CORS_ORIGIN', '*'),
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });
  
  // Préfixe global pour toutes les routes API
  const apiPrefix = configService.get<string>('apiPrefix') || 'api';  // Valeur par défaut
  app.setGlobalPrefix(apiPrefix);
  
  // Intercepteurs globaux
  app.useGlobalInterceptors(new LoggingInterceptor());
  
  // Filtres d'exception globaux
  app.useGlobalFilters(new HttpExceptionFilter());
  
  // Validation globale des DTOs
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  app.useGlobalInterceptors(
    new LoggingInterceptor(),
    new VerificationRequirementsInterceptor(app.get(Reflector)),
  );
  
  // Swagger API documentation
  const swaggerConfig = new DocumentBuilder()
  .setTitle('ParkShare API')
  .setDescription('API pour la marketplace de micro-location de places de parking')
  .setVersion('1.0')
  .addTag('auth')
  .addTag('users')
  .addTag('parkings')
  .addTag('bookings')
  .addTag('notifications')
  .addTag('payments')
  .addTag('reviews')
  .addTag('analytics')
  .addTag('pricing')
  .addTag('verification', 'Vérification progressive des utilisateurs')
  .addBearerAuth()
  .build();
  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup(`${apiPrefix}/docs`, app, document);
  
  // Démarrage du serveur
  const port = configService.get<number>('port') || 3000;  // Valeur par défaut
  await app.listen(port);
  console.log(`Application running on port ${port}`);
}
bootstrap();
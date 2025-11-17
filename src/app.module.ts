import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';

// Configuration
import configuration, { validationSchema } from './config/configuration';
import { getDatabaseConfig } from './config/database.config';
import { RATE_LIMIT } from './core/constants/business-rules.constants';

// Application Modules
import { ParkingsModule } from './modules/parkings/parkings.module';
import { BookingsModule } from './modules/bookings/bookings.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { WebsocketsModule } from './websockets/websockets.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { ProvidersModule } from './providers/providers.module';
import { PricingModule } from './modules/pricing/pricing.module';
import { VerificationModule } from './modules/verification/verification.module';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { SubscriptionsModule } from './modules/subscriptions/subscriptions.module';
import { SpotSwapModule } from './modules/spotswap/spotswap.module';
import { HealthModule } from './health/health.module';

// Guards
import { VerificationLevelGuard } from './modules/verification/guards/verification-level.guard';

@Module({
  imports: [
    // ==========================================
    // CORE CONFIGURATION
    // ==========================================

    // Global configuration with validation
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validationSchema,
      envFilePath: ['.env', '.env.local'],
      cache: true, // Cache configuration for performance
    }),

    // Event Emitter for domain events
    EventEmitterModule.forRoot({
      wildcard: false,
      delimiter: '.',
      newListener: false,
      removeListener: false,
      maxListeners: 10,
      verboseMemoryLeak: true,
      ignoreErrors: false,
    }),

    // ==========================================
    // SECURITY & RATE LIMITING
    // ==========================================

    // Rate limiting to prevent abuse
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => [
        {
          ttl: configService.get<number>(
            'RATE_LIMIT_TTL',
            RATE_LIMIT.GLOBAL_TTL_MS,
          ),
          limit: configService.get<number>(
            'RATE_LIMIT_MAX',
            RATE_LIMIT.GLOBAL_LIMIT,
          ),
        },
      ],
    }),

    // ==========================================
    // DATABASE
    // ==========================================

    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: getDatabaseConfig,
    }),

    // ==========================================
    // INFRASTRUCTURE MODULES
    // ==========================================

    ProvidersModule, // External services (AWS, Twilio, HERE Maps)
    HealthModule, // Health check endpoints

    // ==========================================
    // APPLICATION MODULES
    // ==========================================

    // Authentication & Users
    UsersModule,
    AuthModule,
    VerificationModule,

    // Core Features
    ParkingsModule,
    BookingsModule,
    PaymentsModule,
    ReviewsModule,

    // Additional Features
    NotificationsModule,
    WebsocketsModule,
    AnalyticsModule,
    PricingModule,
    SubscriptionsModule,
    SpotSwapModule,
  ],
  controllers: [],
  providers: [
    // ==========================================
    // GLOBAL GUARDS
    // ==========================================

    // Rate limiting guard (applied globally)
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },

    // Verification level guard (checks @RequiredVerificationLevel decorator)
    {
      provide: APP_GUARD,
      useClass: VerificationLevelGuard,
    },
  ],
})
export class AppModule {}
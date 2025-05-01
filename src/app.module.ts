import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import configuration, { validationSchema } from './config/configuration';
import { getDatabaseConfig } from './config/database.config';
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
import { EventEmitterModule } from '@nestjs/event-emitter';
import { SubscriptionsModule } from './modules/subscriptions/subscriptions.module';
import { SpotSwapModule } from './modules/spotswap/spotswap.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validationSchema,
      envFilePath: ['.env'],
    }),
    
    // Event Emitter
    EventEmitterModule.forRoot(),
    
    // Database
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: getDatabaseConfig,
    }),
    
    // Infrastructure modules
    ProvidersModule,
    
    // Application modules
    UsersModule,
    AuthModule,
    ParkingsModule,
    BookingsModule,
    NotificationsModule,
    WebsocketsModule,
    PaymentsModule,
    ReviewsModule,
    AnalyticsModule,
    PricingModule,
    VerificationModule,
    SubscriptionsModule,
    SpotSwapModule,

  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
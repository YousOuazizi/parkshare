import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnalyticsService } from './analytics.service';
import { AnalyticsController } from './analytics.controller';
import { AnalyticsEvent } from './entities/analytics-event.entity';
import { ParkingsModule } from '../parkings/parkings.module';
import { AnalyticsEventData } from './entities/analytics-event-data.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([AnalyticsEvent, AnalyticsEventData]),
    ParkingsModule,
  ],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
  exports: [AnalyticsService],
})
export class AnalyticsModule {}
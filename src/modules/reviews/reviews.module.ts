import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ReviewsService } from './reviews.service';
import { ReviewsController } from './reviews.controller';
import { Review } from './entities/review.entity';
import { BookingsModule } from '../bookings/bookings.module';
import { ParkingsModule } from '../parkings/parkings.module';
import { NotificationsModule } from '../notifications/notifications.module';
import { ReviewCriteria } from './entities/review-criteria.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Review, ReviewCriteria]),
    BookingsModule,
    ParkingsModule,
    NotificationsModule,
  ],
  controllers: [ReviewsController],
  providers: [ReviewsService],
  exports: [ReviewsService],
})
export class ReviewsModule {}
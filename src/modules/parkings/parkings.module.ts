import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ParkingsController } from './controllers/parkings.controller';
import { PriceRulesController } from './controllers/price-rules.controller';
import { Parking } from './entities/parking.entity';
import { PriceRule } from './entities/price-rule.entity';
import { ParkingsService } from './services/parkings.service';
import { PriceRulesService } from './services/price-rules.service';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Parking, PriceRule]),
    UsersModule,
  ],
  controllers: [ParkingsController, PriceRulesController],
  providers: [ParkingsService, PriceRulesService],
  exports: [ParkingsService, PriceRulesService],
})
export class ParkingsModule {}

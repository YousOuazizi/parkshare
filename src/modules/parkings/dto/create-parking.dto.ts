import { ApiProperty } from '@nestjs/swagger';
import { 
  IsNotEmpty, 
  IsString, 
  IsNumber, 
  IsOptional, 
  IsEnum, 
  IsBoolean, 
  IsArray, 
  ValidateNested, 
  IsObject,
  Min,
  Max 
} from 'class-validator';
import { Type } from 'class-transformer';
import { AccessMethod } from '../entities/parking.entity';

class SizeDto {
  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  @Min(0)
  length?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  @Min(0)
  width?: number;

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  @Min(0)
  height?: number;
}

class HoursRangeDto {
  @ApiProperty({ example: '08:00' })
  @IsString()
  @IsNotEmpty()
  start: string;

  @ApiProperty({ example: '18:00' })
  @IsString()
  @IsNotEmpty()
  end: string;
}

class ExceptionDto {
  @ApiProperty({ example: '2023-12-25' })
  @IsString()
  @IsNotEmpty()
  date: string;

  @ApiProperty({ example: false })
  @IsBoolean()
  available: boolean;

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  hours?: HoursRangeDto[];
}

class AvailabilityDto {
  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  monday?: HoursRangeDto[];

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  tuesday?: HoursRangeDto[];

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  wednesday?: HoursRangeDto[];

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  thursday?: HoursRangeDto[];

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  friday?: HoursRangeDto[];

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  saturday?: HoursRangeDto[];

  @ApiProperty({ type: [HoursRangeDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => HoursRangeDto)
  sunday?: HoursRangeDto[];

  @ApiProperty({ type: [ExceptionDto], required: false })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ExceptionDto)
  exceptions?: ExceptionDto[];
}

export class CreateParkingDto {
  @ApiProperty({ example: 'Parking Centre-Ville' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ example: 'Magnifique place de parking au centre-ville, facile d\'accès.' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiProperty({ example: '15 rue de la Paix, 75002 Paris' })
  @IsString()
  @IsNotEmpty()
  address: string;

  @ApiProperty({ example: 48.8566 })
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude: number;

  @ApiProperty({ example: 2.3522 })
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude: number;

  @ApiProperty({ type: SizeDto })
  @IsObject()
  @ValidateNested()
  @Type(() => SizeDto)
  size: SizeDto;

  @ApiProperty({ example: ['covered', 'secure', 'camera'] })
  @IsArray()
  @IsString({ each: true })
  features: string[];

  @ApiProperty({ example: ['https://example.com/photo1.jpg'] })
  @IsArray()
  @IsString({ each: true })
  photos: string[];

  @ApiProperty({ example: 5.5 })
  @IsNumber()
  @Min(0)
  basePrice: number;

  @ApiProperty({ example: 'EUR', default: 'EUR' })
  @IsString()
  @IsOptional()
  currency?: string;

  @ApiProperty({ type: AvailabilityDto })
  @IsObject()
  @ValidateNested()
  @Type(() => AvailabilityDto)
  availability: AvailabilityDto;

  @ApiProperty({ enum: AccessMethod, default: AccessMethod.CODE })
  @IsEnum(AccessMethod)
  @IsOptional()
  accessMethod?: AccessMethod;

  @ApiProperty({ default: true })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @ApiProperty({ default: false })
  @IsBoolean()
  @IsOptional()
  hasEVCharging?: boolean;
}
<<<<<<< HEAD
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { PriceRule } from './price-rule.entity';
import { AvailabilityException } from './availability-exception.entity';
import { AvailabilitySchedule } from './availability-schedule.entity';
import { ParkingFeature } from './parking-feature.entity';
import { ParkingPhoto } from './parking-photo.entity';
import { ParkingSize } from './parking-size.entity';

export enum AccessMethod {
  CODE = 'code',
  KEY = 'key',
  REMOTE = 'remote',
  APP = 'app',
  NONE = 'none',
}

@Entity('parkings')
export class Parking {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'ownerId' })
  ownerId: string;

  @Column()
  title: string;

  @Column('text')
  description: string;

  @Column()
  address: string;

  @Column('float')
  latitude: number;

  @Column('float')
  longitude: number;

  @Index({ spatial: true })
  @Column({
    type: 'geography',
    spatialFeatureType: 'Point',
    srid: 4326,
    nullable: true,
  })
  location: string;

  @OneToOne(() => ParkingSize, size => size.parking, { 
    cascade: true, 
    eager: true 
  })
  size: ParkingSize;

  @OneToMany(() => ParkingFeature, feature => feature.parking, { 
    cascade: true, 
    eager: true 
  })
  features: ParkingFeature[];

  @OneToMany(() => ParkingPhoto, photo => photo.parking, { 
    cascade: true, 
    eager: true 
  })
  photos: ParkingPhoto[];

  @Column('float')
  basePrice: number;

  @Column({ default: 'EUR' })
  currency: string;

  @OneToMany(() => AvailabilitySchedule, schedule => schedule.parking, {
    cascade: true,
    eager: true,
  })
  availabilitySchedules: AvailabilitySchedule[];

  @OneToMany(() => AvailabilityException, exception => exception.parking, {
    cascade: true,
    eager: true,
  })
  availabilityExceptions: AvailabilityException[];

  @Column({
    type: 'enum',
    enum: AccessMethod,
    default: AccessMethod.CODE,
  })
  accessMethod: AccessMethod;

  @Column({ default: true })
  isActive: boolean;

  @Column({ default: false })
  isVerified: boolean;

  @Column({ default: false })
  hasEVCharging: boolean;
    
  @OneToMany(() => PriceRule, priceRule => priceRule.parking)
  priceRules: PriceRule[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
=======
import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    ManyToOne,
    OneToMany,
    JoinColumn,
    Index,
  } from 'typeorm';
  import { User } from '../../users/entities/user.entity';
  import { PriceRule } from './price-rule.entity';
  
  export enum AccessMethod {
    CODE = 'code',
    KEY = 'key',
    REMOTE = 'remote',
    APP = 'app',
    NONE = 'none',
  }
  
  @Entity('parkings')
  export class Parking {
    @PrimaryGeneratedColumn('uuid')
    id: string;
  
    @Column()
    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'ownerId' })
    ownerId: string;
  
    @Column()
    title: string;
  
    @Column('text')
    description: string;
  
    @Column()
    address: string;
  
    @Column('float')
    latitude: number;
  
    @Column('float')
    longitude: number;
  
    @Index({ spatial: true })
    @Column({
      type: 'geography',
      spatialFeatureType: 'Point',
      srid: 4326,
      nullable: true,
    })
    location: string;
  
    @Column('jsonb', { default: {} })
    size: {
      length?: number;
      width?: number;
      height?: number;
    };
  
    @Column('jsonb', { default: [] })
    features: string[];
  
    @Column('jsonb', { default: [] })
    photos: string[];
  
    @Column('float')
    basePrice: number;
  
    @Column({ default: 'EUR' })
    currency: string;
  
    @Column('jsonb')
    availability: {
      monday?: { start: string; end: string }[];
      tuesday?: { start: string; end: string }[];
      wednesday?: { start: string; end: string }[];
      thursday?: { start: string; end: string }[];
      friday?: { start: string; end: string }[];
      saturday?: { start: string; end: string }[];
      sunday?: { start: string; end: string }[];
      exceptions?: { date: string; available: boolean; hours?: { start: string; end: string }[] }[];
    };
  
    @Column({
      type: 'enum',
      enum: AccessMethod,
      default: AccessMethod.CODE,
    })
    accessMethod: AccessMethod;
  
    @Column({ default: true })
    isActive: boolean;
  
    @Column({ default: false })
    isVerified: boolean;
  
    @Column({ default: false })
    hasEVCharging: boolean;
    
    @OneToMany(() => PriceRule, priceRule => priceRule.parking)
    priceRules: PriceRule[];
  
    @CreateDateColumn()
    createdAt: Date;
  
    @UpdateDateColumn()
    updatedAt: Date;
  }
>>>>>>> 4c1eb952a638ddc42b593eb5280621915e9a2ec0

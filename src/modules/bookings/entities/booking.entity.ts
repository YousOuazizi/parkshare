import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    ManyToOne,
    JoinColumn,
    Index,
  } from 'typeorm';
  import { User } from '../../users/entities/user.entity';
  import { Parking } from '../../parkings/entities/parking.entity';
  
  export enum BookingStatus {
    PENDING = 'pending',
    CONFIRMED = 'confirmed',
    CANCELED = 'canceled',
    COMPLETED = 'completed',
    REJECTED = 'rejected',
  }
  
  @Entity('bookings')
  export class Booking {
    @PrimaryGeneratedColumn('uuid')
    id: string;
  
    @Column()
    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'userId' })
    userId: string;
  
    @Column()
    @ManyToOne(() => Parking, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'parkingId' })
    parkingId: string;
  
    @Column()
    @Index()
    startTime: Date;
  
    @Column()
    @Index()
    endTime: Date;
  
    @Column({
      type: 'enum',
      enum: BookingStatus,
      default: BookingStatus.PENDING,
    })
    @Index()
    status: BookingStatus;
  
    @Column('float')
    totalPrice: number;
  
    @Column({ nullable: true })
    paymentId: string;
  
    @Column({ nullable: true })
    accessCode: string;
  
    @Column({ default: false })
    checkedIn: boolean;
  
    @Column({ nullable: true })
    checkedInTime: Date;
  
    @Column({ default: false })
    checkedOut: boolean;
  
    @Column({ nullable: true })
    checkedOutTime: Date;
  
    @Column('jsonb', { nullable: true })
    appliedPriceRules: any[];
  
    @Column({ nullable: true })
    notes: string;
  
    @CreateDateColumn()
    createdAt: Date;
  
    @UpdateDateColumn()
    updatedAt: Date;
  }
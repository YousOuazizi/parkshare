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
import { Parking } from '../../parkings/entities/parking.entity';
import { AppliedPriceRule } from './applied-price-rule.entity';

export enum BookingStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  CANCELED = 'canceled',
  COMPLETED = 'completed',
  REJECTED = 'rejected',
}

@Entity('bookings')
@Index(['userId', 'status']) // Composite index for user's bookings by status
@Index(['parkingId', 'status']) // Composite index for parking's bookings by status
@Index(['startTime', 'endTime']) // Range queries for availability
export class Booking {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  @Index() // Index for user lookups
  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  userId: string;

  @Column()
  @Index() // Index for parking lookups
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

  @OneToMany(() => AppliedPriceRule, rule => rule.booking, {
    cascade: true,
    eager: true,
  })
  appliedPriceRules: AppliedPriceRule[];

  @Column({ nullable: true })
  notes: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

// src/modules/analytics/entities/analytics-event.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

export enum AnalyticsEventType {
  PAGE_VIEW = 'page_view',
  SEARCH = 'search',
  BOOKING_STARTED = 'booking_started',
  BOOKING_COMPLETED = 'booking_completed',
  BOOKING_CANCELED = 'booking_canceled',
  PAYMENT_STARTED = 'payment_started',
  PAYMENT_COMPLETED = 'payment_completed',
  PAYMENT_FAILED = 'payment_failed',
  USER_REGISTRATION = 'user_registration',
  USER_LOGIN = 'user_login',
  PARKING_VIEWED = 'parking_viewed',
  FEATURE_USED = 'feature_used',
}

@Entity('analytics_events')
export class AnalyticsEvent {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({
    type: 'enum',
    enum: AnalyticsEventType,
  })
  @Index()
  type: AnalyticsEventType;

  @Column({ nullable: true })
  @Index()
  userId: string;

  @Column({ nullable: true })
  @Index()
  sessionId: string;

  @Column({ nullable: true })
  @Index()
  resourceId: string;

  @Column({ nullable: true })
  resourceType: string;

  @Column('jsonb', { default: {} })
  data: any;

  @Column({ nullable: true })
  userAgent: string;

  @Column({ nullable: true })
  ipAddress: string;

  @Column({ nullable: true })
  referrer: string;

  @CreateDateColumn()
  @Index()
  createdAt: Date;
}
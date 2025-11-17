/**
 * Notification Interfaces
 * Type-safe notification structures for WebSocket and database
 */

import { NotificationType } from '../constants/business-rules.constants';

/**
 * WebSocket notification payload
 */
export interface WebSocketNotification {
  id?: string;
  type: NotificationType;
  title: string;
  content: string;
  data?: NotificationData;
  timestamp: Date;
  isRead?: boolean;
}

/**
 * Notification data payload (polymorphic based on type)
 */
export type NotificationData =
  | BookingNotificationData
  | PaymentNotificationData
  | MessageNotificationData
  | ReviewNotificationData
  | SwapNotificationData
  | VerificationNotificationData;

/**
 * Booking-related notification data
 */
export interface BookingNotificationData {
  bookingId: string;
  parkingId: string;
  parkingTitle: string;
  startTime: Date;
  endTime: Date;
  amount?: number;
  status?: string;
}

/**
 * Payment-related notification data
 */
export interface PaymentNotificationData {
  paymentId: string;
  amount: number;
  currency: string;
  bookingId?: string;
  status: string;
}

/**
 * Message-related notification data
 */
export interface MessageNotificationData {
  messageId: string;
  senderId: string;
  senderName: string;
  preview: string;
  conversationId: string;
}

/**
 * Review-related notification data
 */
export interface ReviewNotificationData {
  reviewId: string;
  rating: number;
  parkingId?: string;
  bookingId?: string;
  reviewerName: string;
}

/**
 * Swap-related notification data
 */
export interface SwapNotificationData {
  swapOfferId: string;
  swapListingId: string;
  parkingTitle: string;
  offeredParkingTitle: string;
}

/**
 * Verification-related notification data
 */
export interface VerificationNotificationData {
  verificationType: 'email' | 'phone' | 'id' | 'advanced';
  newLevel: number;
  status: 'approved' | 'rejected';
  reason?: string;
}

/**
 * Create notification params
 */
export interface CreateNotificationParams {
  userId: string;
  type: NotificationType;
  title: string;
  content: string;
  data?: NotificationData;
}

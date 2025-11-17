/**
 * Business Rules Constants
 * Centralized location for all business logic values and magic numbers
 */

import { VerificationLevel } from '../../modules/users/entities/user.entity';

/**
 * Verification codes and token configuration
 */
export const VERIFICATION = {
  // Phone verification
  PHONE_CODE_LENGTH: 6,
  PHONE_CODE_MIN: 100000,
  PHONE_CODE_MAX: 999999,
  PHONE_CODE_EXPIRY_MINUTES: 10,

  // Email verification
  EMAIL_TOKEN_LENGTH: 64, // bytes for hex string (32 bytes = 64 chars)
  EMAIL_TOKEN_EXPIRY_HOURS: 24,

  // Access codes for bookings
  ACCESS_CODE_LENGTH: 6,
  ACCESS_CODE_MIN: 100000,
  ACCESS_CODE_MAX: 999999,
} as const;

/**
 * Payment limits based on verification level
 */
export const PAYMENT_LIMITS = {
  [VerificationLevel.LEVEL_0]: 0, // Cannot make payments
  [VerificationLevel.LEVEL_1]: 50, // 50€ max
  [VerificationLevel.LEVEL_2]: 200, // 200€ max
  [VerificationLevel.LEVEL_3]: 1000, // 1000€ max
  [VerificationLevel.LEVEL_4]: Number.MAX_SAFE_INTEGER, // No limit
} as const;

/**
 * Platform fees and commissions
 */
export const FEES = {
  PLATFORM_FEE_PERCENTAGE: 10, // 10% platform fee
  CURRENCY: 'EUR',
  STRIPE_MULTIPLIER: 100, // Stripe expects amounts in cents
} as const;

/**
 * Geospatial search defaults
 */
export const GEO = {
  DEFAULT_SEARCH_RADIUS_METERS: 5000, // 5km default
  MAX_SEARCH_RADIUS_METERS: 50000, // 50km max
  EARTH_RADIUS_KM: 6371, // Earth radius in kilometers
  SRID: 4326, // WGS 84 coordinate system
} as const;

/**
 * Pagination defaults
 */
export const PAGINATION = {
  DEFAULT_LIMIT: 20,
  MAX_LIMIT: 100,
  DEFAULT_OFFSET: 0,
} as const;

/**
 * Rate limiting configuration
 */
export const RATE_LIMIT = {
  // Global rate limits
  GLOBAL_TTL_MS: 60000, // 1 minute
  GLOBAL_LIMIT: 100, // 100 requests per minute

  // Authentication endpoints (stricter)
  AUTH_TTL_MS: 60000, // 1 minute
  AUTH_LOGIN_LIMIT: 5, // 5 login attempts per minute
  AUTH_REGISTER_LIMIT: 3, // 3 registrations per minute
  AUTH_REFRESH_LIMIT: 10, // 10 refresh attempts per minute

  // Verification endpoints (stricter)
  VERIFICATION_TTL_MS: 300000, // 5 minutes
  VERIFICATION_REQUEST_LIMIT: 3, // 3 verification requests per 5 minutes

  // Sensitive operations
  PASSWORD_CHANGE_TTL_MS: 3600000, // 1 hour
  PASSWORD_CHANGE_LIMIT: 3, // 3 password changes per hour
} as const;

/**
 * Security configuration
 */
export const SECURITY = {
  BCRYPT_ROUNDS: 10,
  JWT_ACCESS_TOKEN_EXPIRY: '1h',
  JWT_REFRESH_TOKEN_EXPIRY: '7d',
  MIN_PASSWORD_LENGTH: 8,
  MAX_PASSWORD_LENGTH: 128,
  PASSWORD_REGEX: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
} as const;

/**
 * File upload limits
 */
export const FILE_UPLOAD = {
  MAX_FILE_SIZE_MB: 10,
  MAX_FILE_SIZE_BYTES: 10 * 1024 * 1024, // 10MB
  ALLOWED_IMAGE_TYPES: ['image/jpeg', 'image/png', 'image/webp'],
  ALLOWED_DOCUMENT_TYPES: ['application/pdf', 'image/jpeg', 'image/png'],
  MAX_PARKING_PHOTOS: 10,
} as const;

/**
 * Database configuration
 */
export const DATABASE = {
  CONNECTION_POOL_MIN: 5,
  CONNECTION_POOL_MAX: 20,
  IDLE_TIMEOUT_MS: 30000, // 30 seconds
  CONNECTION_TIMEOUT_MS: 2000, // 2 seconds
  QUERY_TIMEOUT_MS: 10000, // 10 seconds
  SLOW_QUERY_LOG_MS: 5000, // Log queries slower than 5 seconds
  CACHE_DURATION_MS: 30000, // Cache query results for 30 seconds
} as const;

/**
 * Business logic timeouts
 */
export const TIMEOUTS = {
  BOOKING_CONFIRMATION_HOURS: 24, // Owner must confirm within 24h
  BOOKING_CANCELLATION_HOURS: 2, // Cancel at least 2h before start
  PARKING_AVAILABILITY_CACHE_MINUTES: 5, // Cache availability for 5 minutes
  NOTIFICATION_RETENTION_DAYS: 30, // Keep notifications for 30 days
  ANALYTICS_RETENTION_DAYS: 365, // Keep analytics for 1 year
} as const;

/**
 * Subscription limits
 */
export const SUBSCRIPTION = {
  MAX_SHARED_USERS: 5, // Max users to share subscription with
  MAX_PAUSES_PER_YEAR: 3, // Max number of pauses per year
  MIN_PAUSE_DAYS: 7, // Minimum pause duration
  MAX_PAUSE_DAYS: 90, // Maximum pause duration
} as const;

/**
 * Spot swap configuration
 */
export const SPOT_SWAP = {
  OFFER_EXPIRY_HOURS: 24, // Offers expire after 24 hours
  MAX_ACTIVE_LISTINGS: 5, // Max active listings per user
  MIN_PRICE_DIFFERENCE_PERCENTAGE: 10, // Min 10% price difference to swap
} as const;

/**
 * Notification types
 */
export enum NotificationType {
  BOOKING_CREATED = 'booking_created',
  BOOKING_CONFIRMED = 'booking_confirmed',
  BOOKING_CANCELLED = 'booking_cancelled',
  BOOKING_COMPLETED = 'booking_completed',
  PAYMENT_RECEIVED = 'payment_received',
  PAYMENT_FAILED = 'payment_failed',
  VERIFICATION_COMPLETED = 'verification_completed',
  MESSAGE_RECEIVED = 'message_received',
  REVIEW_RECEIVED = 'review_received',
  SWAP_OFFER_RECEIVED = 'swap_offer_received',
  SWAP_ACCEPTED = 'swap_accepted',
}

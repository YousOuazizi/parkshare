/**
 * Standardized Error Codes and Messages
 * Use these constants throughout the application for consistent error handling
 */

export const ERROR_CODES = {
  // Authentication errors (1xxx)
  AUTH_INVALID_CREDENTIALS: 'AUTH_1001',
  AUTH_USER_NOT_FOUND: 'AUTH_1002',
  AUTH_EMAIL_ALREADY_EXISTS: 'AUTH_1003',
  AUTH_INVALID_TOKEN: 'AUTH_1004',
  AUTH_TOKEN_EXPIRED: 'AUTH_1005',
  AUTH_UNAUTHORIZED: 'AUTH_1006',
  AUTH_INSUFFICIENT_VERIFICATION: 'AUTH_1007',

  // User errors (2xxx)
  USER_NOT_FOUND: 'USER_2001',
  USER_ALREADY_VERIFIED: 'USER_2002',
  USER_NOT_VERIFIED: 'USER_2003',
  USER_VERIFICATION_REQUIRED: 'USER_2004',
  USER_PHONE_ALREADY_EXISTS: 'USER_2005',

  // Parking errors (3xxx)
  PARKING_NOT_FOUND: 'PARKING_3001',
  PARKING_NOT_AVAILABLE: 'PARKING_3002',
  PARKING_ALREADY_BOOKED: 'PARKING_3003',
  PARKING_OWNER_CANNOT_BOOK: 'PARKING_3004',
  PARKING_LIMIT_REACHED: 'PARKING_3005',
  PARKING_INVALID_LOCATION: 'PARKING_3006',

  // Booking errors (4xxx)
  BOOKING_NOT_FOUND: 'BOOKING_4001',
  BOOKING_ALREADY_CONFIRMED: 'BOOKING_4002',
  BOOKING_ALREADY_CANCELLED: 'BOOKING_4003',
  BOOKING_INVALID_DATES: 'BOOKING_4004',
  BOOKING_TOO_LATE_TO_CANCEL: 'BOOKING_4005',
  BOOKING_UNAUTHORIZED: 'BOOKING_4006',
  BOOKING_OVERLAP: 'BOOKING_4007',

  // Payment errors (5xxx)
  PAYMENT_NOT_FOUND: 'PAYMENT_5001',
  PAYMENT_FAILED: 'PAYMENT_5002',
  PAYMENT_ALREADY_REFUNDED: 'PAYMENT_5003',
  PAYMENT_LIMIT_EXCEEDED: 'PAYMENT_5004',
  PAYMENT_INVALID_AMOUNT: 'PAYMENT_5005',
  PAYMENT_STRIPE_ERROR: 'PAYMENT_5006',

  // Verification errors (6xxx)
  VERIFICATION_CODE_INVALID: 'VERIFICATION_6001',
  VERIFICATION_CODE_EXPIRED: 'VERIFICATION_6002',
  VERIFICATION_TOKEN_INVALID: 'VERIFICATION_6003',
  VERIFICATION_ALREADY_COMPLETED: 'VERIFICATION_6004',
  VERIFICATION_FAILED: 'VERIFICATION_6005',

  // Validation errors (7xxx)
  VALIDATION_FAILED: 'VALIDATION_7001',
  VALIDATION_INVALID_DATE_RANGE: 'VALIDATION_7002',
  VALIDATION_PAST_DATE: 'VALIDATION_7003',
  VALIDATION_INVALID_FORMAT: 'VALIDATION_7004',
  VALIDATION_MISSING_REQUIRED_FIELD: 'VALIDATION_7005',

  // General errors (9xxx)
  INTERNAL_SERVER_ERROR: 'ERROR_9001',
  NOT_FOUND: 'ERROR_9002',
  FORBIDDEN: 'ERROR_9003',
  BAD_REQUEST: 'ERROR_9004',
  RATE_LIMIT_EXCEEDED: 'ERROR_9005',
  SERVICE_UNAVAILABLE: 'ERROR_9006',
} as const;

export const ERROR_MESSAGES = {
  // Authentication
  [ERROR_CODES.AUTH_INVALID_CREDENTIALS]: 'Invalid email or password',
  [ERROR_CODES.AUTH_USER_NOT_FOUND]: 'User not found',
  [ERROR_CODES.AUTH_EMAIL_ALREADY_EXISTS]: 'Email already registered',
  [ERROR_CODES.AUTH_INVALID_TOKEN]: 'Invalid authentication token',
  [ERROR_CODES.AUTH_TOKEN_EXPIRED]: 'Authentication token expired',
  [ERROR_CODES.AUTH_UNAUTHORIZED]: 'Unauthorized access',
  [ERROR_CODES.AUTH_INSUFFICIENT_VERIFICATION]: 'Insufficient verification level',

  // User
  [ERROR_CODES.USER_NOT_FOUND]: 'User not found',
  [ERROR_CODES.USER_ALREADY_VERIFIED]: 'User already verified',
  [ERROR_CODES.USER_NOT_VERIFIED]: 'User verification required',
  [ERROR_CODES.USER_VERIFICATION_REQUIRED]: 'Higher verification level required',
  [ERROR_CODES.USER_PHONE_ALREADY_EXISTS]: 'Phone number already in use',

  // Parking
  [ERROR_CODES.PARKING_NOT_FOUND]: 'Parking not found',
  [ERROR_CODES.PARKING_NOT_AVAILABLE]: 'Parking not available for selected dates',
  [ERROR_CODES.PARKING_ALREADY_BOOKED]: 'Parking already booked for this time slot',
  [ERROR_CODES.PARKING_OWNER_CANNOT_BOOK]: 'Parking owner cannot book their own parking',
  [ERROR_CODES.PARKING_LIMIT_REACHED]: 'Maximum number of parking listings reached',
  [ERROR_CODES.PARKING_INVALID_LOCATION]: 'Invalid parking location coordinates',

  // Booking
  [ERROR_CODES.BOOKING_NOT_FOUND]: 'Booking not found',
  [ERROR_CODES.BOOKING_ALREADY_CONFIRMED]: 'Booking already confirmed',
  [ERROR_CODES.BOOKING_ALREADY_CANCELLED]: 'Booking already cancelled',
  [ERROR_CODES.BOOKING_INVALID_DATES]: 'Invalid booking dates',
  [ERROR_CODES.BOOKING_TOO_LATE_TO_CANCEL]: 'Too late to cancel booking',
  [ERROR_CODES.BOOKING_UNAUTHORIZED]: 'Unauthorized to modify this booking',
  [ERROR_CODES.BOOKING_OVERLAP]: 'Booking overlaps with existing reservation',

  // Payment
  [ERROR_CODES.PAYMENT_NOT_FOUND]: 'Payment not found',
  [ERROR_CODES.PAYMENT_FAILED]: 'Payment failed',
  [ERROR_CODES.PAYMENT_ALREADY_REFUNDED]: 'Payment already refunded',
  [ERROR_CODES.PAYMENT_LIMIT_EXCEEDED]: 'Payment amount exceeds verification level limit',
  [ERROR_CODES.PAYMENT_INVALID_AMOUNT]: 'Invalid payment amount',
  [ERROR_CODES.PAYMENT_STRIPE_ERROR]: 'Payment processing error',

  // Verification
  [ERROR_CODES.VERIFICATION_CODE_INVALID]: 'Invalid verification code',
  [ERROR_CODES.VERIFICATION_CODE_EXPIRED]: 'Verification code expired',
  [ERROR_CODES.VERIFICATION_TOKEN_INVALID]: 'Invalid verification token',
  [ERROR_CODES.VERIFICATION_ALREADY_COMPLETED]: 'Verification already completed',
  [ERROR_CODES.VERIFICATION_FAILED]: 'Verification failed',

  // Validation
  [ERROR_CODES.VALIDATION_FAILED]: 'Validation failed',
  [ERROR_CODES.VALIDATION_INVALID_DATE_RANGE]: 'Start date must be before end date',
  [ERROR_CODES.VALIDATION_PAST_DATE]: 'Date must be in the future',
  [ERROR_CODES.VALIDATION_INVALID_FORMAT]: 'Invalid format',
  [ERROR_CODES.VALIDATION_MISSING_REQUIRED_FIELD]: 'Required field missing',

  // General
  [ERROR_CODES.INTERNAL_SERVER_ERROR]: 'Internal server error',
  [ERROR_CODES.NOT_FOUND]: 'Resource not found',
  [ERROR_CODES.FORBIDDEN]: 'Access forbidden',
  [ERROR_CODES.BAD_REQUEST]: 'Bad request',
  [ERROR_CODES.RATE_LIMIT_EXCEEDED]: 'Rate limit exceeded. Please try again later',
  [ERROR_CODES.SERVICE_UNAVAILABLE]: 'Service temporarily unavailable',
} as const;

export type ErrorCode = typeof ERROR_CODES[keyof typeof ERROR_CODES];

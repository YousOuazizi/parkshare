/**
 * Typed Request Interfaces
 * Replace 'any' types with proper TypeScript interfaces
 */

import { Request } from 'express';
import { UserRole, VerificationLevel } from '../../modules/users/entities/user.entity';

/**
 * Authenticated user information attached to requests
 */
export interface AuthenticatedUser {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: UserRole;
  verificationLevel: VerificationLevel;
  phoneNumber?: string;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  stripeCustomerId?: string;
}

/**
 * Express Request with authenticated user
 */
export interface RequestWithUser extends Request {
  user: AuthenticatedUser;
}

/**
 * JWT payload structure for access tokens
 */
export interface JwtPayload {
  sub: string; // User ID
  email: string;
  role: UserRole;
  verificationLevel: VerificationLevel;
  iat?: number; // Issued at
  exp?: number; // Expiration
}

/**
 * JWT payload for refresh tokens
 */
export interface JwtRefreshPayload {
  sub: string; // User ID
  tokenId: string; // Unique token identifier
  iat?: number;
  exp?: number;
}

/**
 * Login response DTO
 */
export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: UserRole;
    verificationLevel: VerificationLevel;
  };
}

/**
 * Validated user returned from local strategy
 */
export interface ValidatedUser {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: UserRole;
  verificationLevel: VerificationLevel;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
}

/**
 * Token refresh response
 */
export interface TokenRefreshResponse {
  accessToken: string;
  refreshToken: string;
}

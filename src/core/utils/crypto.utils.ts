/**
 * Cryptographic Utilities
 * Secure random number and token generation using crypto module
 */

import * as crypto from 'crypto';
import { VERIFICATION } from '../constants/business-rules.constants';

export class CryptoUtils {
  /**
   * Generate a secure numeric code of specified length
   * Uses crypto.randomBytes for cryptographically secure random generation
   *
   * @param length - Length of the code (default: 6)
   * @returns Secure random numeric code as string
   *
   * @example
   * const code = CryptoUtils.generateSecureCode(6); // "847293"
   */
  static generateSecureCode(length: number = VERIFICATION.PHONE_CODE_LENGTH): string {
    const max = Math.pow(10, length);
    const min = Math.pow(10, length - 1);
    const range = max - min;

    // Generate 4 random bytes and convert to unsigned 32-bit integer
    const randomBytes = crypto.randomBytes(4);
    const randomNumber = randomBytes.readUInt32BE(0);

    // Map to desired range
    return (min + (randomNumber % range)).toString();
  }

  /**
   * Generate a secure hexadecimal token
   * Uses crypto.randomBytes for cryptographically secure random generation
   *
   * @param byteLength - Number of random bytes to generate (default: 32)
   * @returns Secure random hexadecimal token
   *
   * @example
   * const token = CryptoUtils.generateSecureToken(32);
   * // "a3f8c9d2e1b4f7a6c3d8e9f0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0"
   */
  static generateSecureToken(byteLength: number = 32): string {
    return crypto.randomBytes(byteLength).toString('hex');
  }

  /**
   * Generate a secure random UUID v4
   *
   * @returns UUID v4 string
   *
   * @example
   * const uuid = CryptoUtils.generateUUID();
   * // "550e8400-e29b-41d4-a716-446655440000"
   */
  static generateUUID(): string {
    return crypto.randomUUID();
  }

  /**
   * Hash a value using SHA-256
   *
   * @param value - Value to hash
   * @returns SHA-256 hash as hexadecimal string
   *
   * @example
   * const hash = CryptoUtils.hashValue('secret');
   */
  static hashValue(value: string): string {
    return crypto.createHash('sha256').update(value).digest('hex');
  }

  /**
   * Compare two values in constant time to prevent timing attacks
   *
   * @param a - First value
   * @param b - Second value
   * @returns True if values are equal
   */
  static constantTimeCompare(a: string, b: string): boolean {
    if (a.length !== b.length) {
      return false;
    }

    const bufferA = Buffer.from(a);
    const bufferB = Buffer.from(b);

    return crypto.timingSafeEqual(bufferA, bufferB);
  }

  /**
   * Generate a secure random integer between min and max (inclusive)
   *
   * @param min - Minimum value
   * @param max - Maximum value
   * @returns Random integer
   */
  static generateSecureRandomInt(min: number, max: number): number {
    const range = max - min + 1;
    const bytesNeeded = Math.ceil(Math.log2(range) / 8);
    const maxValue = Math.pow(256, bytesNeeded);
    const randomBytes = crypto.randomBytes(bytesNeeded);
    let randomValue = 0;

    for (let i = 0; i < bytesNeeded; i++) {
      randomValue = randomValue * 256 + randomBytes[i];
    }

    // Rejection sampling to avoid modulo bias
    if (randomValue >= maxValue - (maxValue % range)) {
      return this.generateSecureRandomInt(min, max);
    }

    return min + (randomValue % range);
  }

  /**
   * Generate a verification code with specific min/max range
   *
   * @returns Secure 6-digit verification code
   */
  static generatePhoneVerificationCode(): string {
    return this.generateSecureCode(VERIFICATION.PHONE_CODE_LENGTH);
  }

  /**
   * Generate an email verification token
   *
   * @returns Secure hexadecimal token
   */
  static generateEmailVerificationToken(): string {
    return this.generateSecureToken(VERIFICATION.EMAIL_TOKEN_LENGTH / 2); // Divide by 2 because hex doubles the length
  }

  /**
   * Generate an access code for bookings
   *
   * @returns Secure 6-digit access code
   */
  static generateAccessCode(): string {
    return this.generateSecureCode(VERIFICATION.ACCESS_CODE_LENGTH);
  }
}

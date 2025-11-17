/**
 * Date Validation Utilities
 * Reusable date validation functions to eliminate code duplication
 */

import { BadRequestException } from '@nestjs/common';
import { ERROR_CODES, ERROR_MESSAGES } from '../constants/error-codes.constants';

export class DateValidator {
  /**
   * Validate that start date is before end date
   *
   * @param startDate - Start date
   * @param endDate - End date
   * @param fieldName - Optional field name for error message
   * @throws BadRequestException if validation fails
   */
  static validateDateRange(
    startDate: Date,
    endDate: Date,
    fieldName: string = 'Date range',
  ): void {
    if (startDate >= endDate) {
      throw new BadRequestException({
        code: ERROR_CODES.VALIDATION_INVALID_DATE_RANGE,
        message: ERROR_MESSAGES[ERROR_CODES.VALIDATION_INVALID_DATE_RANGE],
        field: fieldName,
      });
    }
  }

  /**
   * Validate that a date is in the future
   *
   * @param date - Date to validate
   * @param fieldName - Optional field name for error message
   * @throws BadRequestException if date is in the past
   */
  static validateFutureDate(date: Date, fieldName: string = 'Date'): void {
    const now = new Date();
    if (date < now) {
      throw new BadRequestException({
        code: ERROR_CODES.VALIDATION_PAST_DATE,
        message: ERROR_MESSAGES[ERROR_CODES.VALIDATION_PAST_DATE],
        field: fieldName,
      });
    }
  }

  /**
   * Validate that a date is within a specific range
   *
   * @param date - Date to validate
   * @param rangeStart - Start of valid range
   * @param rangeEnd - End of valid range
   * @param fieldName - Optional field name for error message
   * @throws BadRequestException if date is outside range
   */
  static validateDateInRange(
    date: Date,
    rangeStart: Date,
    rangeEnd: Date,
    fieldName: string = 'Date',
  ): void {
    if (date < rangeStart || date > rangeEnd) {
      throw new BadRequestException({
        code: ERROR_CODES.VALIDATION_FAILED,
        message: `${fieldName} must be between ${rangeStart.toISOString()} and ${rangeEnd.toISOString()}`,
        field: fieldName,
      });
    }
  }

  /**
   * Validate that end date is at least a certain duration after start date
   *
   * @param startDate - Start date
   * @param endDate - End date
   * @param minDurationMs - Minimum duration in milliseconds
   * @param fieldName - Optional field name for error message
   * @throws BadRequestException if duration is too short
   */
  static validateMinimumDuration(
    startDate: Date,
    endDate: Date,
    minDurationMs: number,
    fieldName: string = 'Duration',
  ): void {
    const duration = endDate.getTime() - startDate.getTime();
    if (duration < minDurationMs) {
      const minDurationHours = minDurationMs / (1000 * 60 * 60);
      throw new BadRequestException({
        code: ERROR_CODES.VALIDATION_FAILED,
        message: `${fieldName} must be at least ${minDurationHours} hours`,
        field: fieldName,
      });
    }
  }

  /**
   * Validate that a date is not too far in the future
   *
   * @param date - Date to validate
   * @param maxDaysInFuture - Maximum number of days in the future
   * @param fieldName - Optional field name for error message
   * @throws BadRequestException if date is too far in the future
   */
  static validateMaxFutureDate(
    date: Date,
    maxDaysInFuture: number,
    fieldName: string = 'Date',
  ): void {
    const maxDate = new Date();
    maxDate.setDate(maxDate.getDate() + maxDaysInFuture);

    if (date > maxDate) {
      throw new BadRequestException({
        code: ERROR_CODES.VALIDATION_FAILED,
        message: `${fieldName} cannot be more than ${maxDaysInFuture} days in the future`,
        field: fieldName,
      });
    }
  }

  /**
   * Check if two date ranges overlap
   *
   * @param start1 - Start of first range
   * @param end1 - End of first range
   * @param start2 - Start of second range
   * @param end2 - End of second range
   * @returns True if ranges overlap
   */
  static doDateRangesOverlap(
    start1: Date,
    end1: Date,
    start2: Date,
    end2: Date,
  ): boolean {
    return start1 < end2 && end1 > start2;
  }

  /**
   * Calculate duration between two dates in hours
   *
   * @param startDate - Start date
   * @param endDate - End date
   * @returns Duration in hours
   */
  static calculateDurationInHours(startDate: Date, endDate: Date): number {
    const durationMs = endDate.getTime() - startDate.getTime();
    return durationMs / (1000 * 60 * 60);
  }

  /**
   * Calculate duration between two dates in days
   *
   * @param startDate - Start date
   * @param endDate - End date
   * @returns Duration in days
   */
  static calculateDurationInDays(startDate: Date, endDate: Date): number {
    const durationMs = endDate.getTime() - startDate.getTime();
    return durationMs / (1000 * 60 * 60 * 24);
  }

  /**
   * Add hours to a date
   *
   * @param date - Base date
   * @param hours - Number of hours to add
   * @returns New date with hours added
   */
  static addHours(date: Date, hours: number): Date {
    const result = new Date(date);
    result.setHours(result.getHours() + hours);
    return result;
  }

  /**
   * Add days to a date
   *
   * @param date - Base date
   * @param days - Number of days to add
   * @returns New date with days added
   */
  static addDays(date: Date, days: number): Date {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  /**
   * Check if a date is in the past
   *
   * @param date - Date to check
   * @returns True if date is in the past
   */
  static isPastDate(date: Date): boolean {
    return date < new Date();
  }

  /**
   * Check if a date is today
   *
   * @param date - Date to check
   * @returns True if date is today
   */
  static isToday(date: Date): boolean {
    const today = new Date();
    return (
      date.getDate() === today.getDate() &&
      date.getMonth() === today.getMonth() &&
      date.getFullYear() === today.getFullYear()
    );
  }

  /**
   * Validate complete booking date range
   * - Start date must be before end date
   * - Start date must be in the future
   * - Minimum duration requirement
   *
   * @param startDate - Booking start date
   * @param endDate - Booking end date
   * @param minDurationHours - Minimum duration in hours (default: 1)
   */
  static validateBookingDateRange(
    startDate: Date,
    endDate: Date,
    minDurationHours: number = 1,
  ): void {
    this.validateDateRange(startDate, endDate, 'Booking dates');
    this.validateFutureDate(startDate, 'Start date');
    this.validateMinimumDuration(
      startDate,
      endDate,
      minDurationHours * 60 * 60 * 1000,
      'Booking duration',
    );
  }
}

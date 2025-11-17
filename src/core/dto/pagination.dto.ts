/**
 * Pagination DTO
 * Reusable pagination parameters for list endpoints
 */

import { IsOptional, IsInt, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { PAGINATION } from '../constants/business-rules.constants';

export class PaginationDto {
  @ApiPropertyOptional({
    description: 'Number of items to return',
    minimum: 1,
    maximum: PAGINATION.MAX_LIMIT,
    default: PAGINATION.DEFAULT_LIMIT,
    example: 20,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(PAGINATION.MAX_LIMIT)
  @Type(() => Number)
  limit?: number = PAGINATION.DEFAULT_LIMIT;

  @ApiPropertyOptional({
    description: 'Number of items to skip',
    minimum: 0,
    default: PAGINATION.DEFAULT_OFFSET,
    example: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Type(() => Number)
  offset?: number = PAGINATION.DEFAULT_OFFSET;

  @ApiPropertyOptional({
    description: 'Page number (alternative to offset)',
    minimum: 1,
    example: 1,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Type(() => Number)
  page?: number;

  /**
   * Calculate offset from page number
   */
  getOffset(): number {
    if (this.page) {
      return (this.page - 1) * (this.limit || PAGINATION.DEFAULT_LIMIT);
    }
    return this.offset || PAGINATION.DEFAULT_OFFSET;
  }

  /**
   * Get limit with default
   */
  getLimit(): number {
    return this.limit || PAGINATION.DEFAULT_LIMIT;
  }
}

/**
 * Paginated Response Wrapper
 * Standard format for paginated API responses
 */
export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    total: number;
    limit: number;
    offset: number;
    page?: number;
    totalPages?: number;
    hasNextPage: boolean;
    hasPreviousPage: boolean;
  };
}

/**
 * Helper function to create paginated response
 */
export function createPaginatedResponse<T>(
  data: T[],
  total: number,
  pagination: PaginationDto,
): PaginatedResponse<T> {
  const limit = pagination.getLimit();
  const offset = pagination.getOffset();
  const totalPages = Math.ceil(total / limit);
  const currentPage = Math.floor(offset / limit) + 1;

  return {
    data,
    meta: {
      total,
      limit,
      offset,
      page: currentPage,
      totalPages,
      hasNextPage: offset + limit < total,
      hasPreviousPage: offset > 0,
    },
  };
}

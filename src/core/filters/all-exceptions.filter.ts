/**
 * Global Exception Filter
 * Catches all exceptions and formats them consistently
 */

import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { QueryFailedError } from 'typeorm';

/**
 * Error response structure
 */
interface ErrorResponse {
  statusCode: number;
  timestamp: string;
  path: string;
  method: string;
  message: string | object;
  error?: string;
  code?: string;
  stack?: string;
}

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message: string | object = 'Internal server error';
    let error = 'Internal Server Error';
    let code: string | undefined;

    // Handle HTTP exceptions
    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();

      if (typeof exceptionResponse === 'string') {
        message = exceptionResponse;
      } else if (typeof exceptionResponse === 'object') {
        message = (exceptionResponse as any).message || exception.message;
        code = (exceptionResponse as any).code;
        error = (exceptionResponse as any).error || exception.name;
      }
    }
    // Handle TypeORM database errors
    else if (exception instanceof QueryFailedError) {
      status = HttpStatus.BAD_REQUEST;
      error = 'Database Error';

      // Parse specific database errors
      const dbError = exception as any;

      if (dbError.code === '23505') {
        // Unique constraint violation
        message = 'Resource already exists';
        code = 'DUPLICATE_ENTRY';
      } else if (dbError.code === '23503') {
        // Foreign key constraint violation
        message = 'Referenced resource not found';
        code = 'INVALID_REFERENCE';
      } else if (dbError.code === '23502') {
        // Not null violation
        message = 'Required field missing';
        code = 'MISSING_REQUIRED_FIELD';
      } else {
        message = 'Database operation failed';
        code = 'DATABASE_ERROR';
      }
    }
    // Handle other errors
    else if (exception instanceof Error) {
      message = exception.message;
      error = exception.name;
    }

    // Build error response
    const errorResponse: ErrorResponse = {
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      method: request.method,
      message,
      error,
    };

    // Add error code if available
    if (code) {
      errorResponse.code = code;
    }

    // Add stack trace in development
    if (process.env.NODE_ENV === 'development' && exception instanceof Error) {
      errorResponse.stack = exception.stack;
    }

    // Log the error
    const userId = (request as any).user?.id || 'anonymous';
    const logMessage = `${request.method} ${request.url} ${status} - User: ${userId}`;

    if (status >= 500) {
      this.logger.error(
        logMessage,
        exception instanceof Error ? exception.stack : JSON.stringify(exception),
      );
    } else if (status >= 400) {
      this.logger.warn(`${logMessage} - ${JSON.stringify(message)}`);
    }

    // Send response
    response.status(status).json(errorResponse);
  }
}

/**
 * Global Logging Interceptor
 * Logs all HTTP requests and responses with timing
 */

import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Request, Response } from 'express';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    if (context.getType() !== 'http') {
      return next.handle();
    }

    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();

    const { method, url } = request;
    const ip = request.ip || request.socket.remoteAddress || 'unknown';
    const userAgent = request.get('user-agent') || 'Unknown';
    const userId = (request as any).user?.id || 'anonymous';

    const startTime = Date.now();

    return next.handle().pipe(
      tap({
        next: () => {
          const { statusCode } = response;
          const responseTime = Date.now() - startTime;

          const logMessage = this.formatLogMessage(
            method,
            url,
            statusCode,
            responseTime,
            userId,
            ip,
          );

          if (statusCode >= 500) {
            this.logger.error(logMessage);
          } else if (statusCode >= 400) {
            this.logger.warn(logMessage);
          } else {
            this.logger.log(logMessage);
          }
        },
        error: (error) => {
          const responseTime = Date.now() - startTime;
          const statusCode = error?.status || 500;

          const logMessage = this.formatLogMessage(
            method,
            url,
            statusCode,
            responseTime,
            userId,
            ip,
            error.message,
          );

          this.logger.error(logMessage);
        },
      }),
    );
  }

  private formatLogMessage(
    method: string,
    url: string,
    statusCode: number,
    responseTime: number,
    userId: string,
    ip: string,
    errorMessage?: string,
  ): string {
    const parts = [
      method,
      url,
      statusCode,
      `${responseTime}ms`,
      `User: ${userId}`,
      `IP: ${ip}`,
    ];

    if (errorMessage) {
      parts.push(`Error: ${errorMessage}`);
    }

    return parts.join(' | ');
  }
}

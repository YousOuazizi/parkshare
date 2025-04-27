import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
    Logger,
  } from '@nestjs/common';
  import { Observable } from 'rxjs';
  import { tap } from 'rxjs/operators';
  
  @Injectable()
  export class LoggingInterceptor implements NestInterceptor {
    private readonly logger = new Logger('HTTP');
  
    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
      const req = context.switchToHttp().getRequest();
      const { method, url, body, ip } = req;
      const userAgent = req.get('user-agent') || '';
      const userId = req.user?.id || 'anonymous';
  
      const now = Date.now();
  
      return next.handle().pipe(
        tap({
          next: (res: any) => {
            const response = context.switchToHttp().getResponse();
            const statusCode = response.statusCode;
            const contentLength = response.get('content-length') || 0;
            
            this.logger.log(
              `${method} ${url} ${statusCode} ${contentLength} - ${userId} ${userAgent} ${ip} ${Date.now() - now}ms`,
            );
          },
          error: (err: any) => {
            const statusCode = err.status || 500;
            
            this.logger.error(
              `${method} ${url} ${statusCode} - ${userId} ${userAgent} ${ip} ${Date.now() - now}ms`,
              err.stack,
            );
          },
        }),
      );
    }
  }
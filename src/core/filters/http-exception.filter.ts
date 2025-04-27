import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    HttpStatus,
    Logger,
  } from '@nestjs/common';
  import { Request, Response } from 'express';
  
  @Catch()
  export class HttpExceptionFilter implements ExceptionFilter {
    private readonly logger = new Logger('Exception');
  
    catch(exception: any, host: ArgumentsHost) {
      const ctx = host.switchToHttp();
      const response = ctx.getResponse<Response>();
      const request = ctx.getRequest<Request>();
      
      const status =
        exception instanceof HttpException
          ? exception.getStatus()
          : HttpStatus.INTERNAL_SERVER_ERROR;
      
      const message =
        exception instanceof HttpException
          ? exception.getResponse()
          : { message: 'Internal server error' };
      
      // Log l'erreur
      this.logger.error(
        `${request.method} ${request.url} ${status}`,
        exception instanceof HttpException ? exception.stack : exception.stack,
      );
      
      // Structure de la réponse d'erreur
      const errorResponse = {
        statusCode: status,
        timestamp: new Date().toISOString(),
        path: request.url,
        method: request.method,
        ...(typeof message === 'object' ? message : { message }),
      };
      
      response
        .status(status)
        .json(errorResponse);
    }
  }
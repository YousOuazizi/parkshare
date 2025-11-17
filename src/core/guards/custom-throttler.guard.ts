import { Injectable, ExecutionContext } from '@nestjs/common';
import { ThrottlerGuard, ThrottlerException } from '@nestjs/throttler';
import { Reflector } from '@nestjs/core';

/**
 * Custom Throttler Guard
 *
 * Étend le ThrottlerGuard pour :
 * - Logger les tentatives d'abus
 * - Personnaliser les messages d'erreur
 * - Gérer les exceptions de rate limiting
 */
@Injectable()
export class CustomThrottlerGuard extends ThrottlerGuard {
  constructor(
    protected readonly reflector: Reflector,
  ) {
    super({
      throttlers: [],
      ignoreUserAgents: [],
      getTracker: (req) => req.ip,
      getIgnoreUserAgents: () => [],
    }, reflector);
  }

  async handleRequest(
    context: ExecutionContext,
    limit: number,
    ttl: number,
    throttler: any,
  ): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const response = context.switchToHttp().getResponse();

    try {
      const result = await super.handleRequest(context, limit, ttl, throttler);

      // Ajouter les headers de rate limiting
      response.setHeader('X-RateLimit-Limit', limit);
      response.setHeader('X-RateLimit-Remaining', result ? limit - 1 : 0);
      response.setHeader('X-RateLimit-Reset', Date.now() + ttl);

      return result;
    } catch (error) {
      // Logger les tentatives d'abus
      console.warn(`Rate limit exceeded for IP: ${request.ip}, Path: ${request.path}`);

      // Lancer une exception personnalisée
      throw new ThrottlerException(
        'Trop de requêtes. Veuillez réessayer dans quelques instants.',
      );
    }
  }
}

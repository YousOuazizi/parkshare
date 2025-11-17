/**
 * Health Check Module
 * Provides health check endpoints for monitoring and orchestration
 */

import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { HealthController } from './health.controller';

@Module({
  imports: [
    TerminusModule,
  ],
  controllers: [HealthController],
})
export class HealthModule {}

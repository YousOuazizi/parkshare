import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { DATABASE } from '../core/constants/business-rules.constants';

export const getDatabaseConfig = (
  configService: ConfigService,
): TypeOrmModuleOptions => {
  const isProduction = configService.get<string>('environment') === 'production';
  const isDevelopment = configService.get<string>('environment') === 'development';

  return {
    type: 'postgres',
    url: configService.get<string>('database.url'),
    entities: [__dirname + '/../**/*.entity{.ts,.js}'],

    // Schema synchronization (DANGEROUS in production!)
    synchronize: isDevelopment,

    // Migrations
    migrations: [__dirname + '/../database/migrations/**/*{.ts,.js}'],
    migrationsRun: isProduction, // Auto-run migrations in production

    // Logging
    logging: isDevelopment ? 'all' : ['error', 'warn'],
    maxQueryExecutionTime: DATABASE.SLOW_QUERY_LOG_MS, // Log slow queries

    // Connection pooling for better performance
    extra: {
      max: DATABASE.CONNECTION_POOL_MAX, // Maximum pool size (20 connections)
      min: DATABASE.CONNECTION_POOL_MIN, // Minimum pool size (5 connections)
      idleTimeoutMillis: DATABASE.IDLE_TIMEOUT_MS, // Close idle connections after 30s
      connectionTimeoutMillis: DATABASE.CONNECTION_TIMEOUT_MS, // Timeout after 2s

      // PostgreSQL specific settings
      application_name: 'parkshare-api',
      statement_timeout: DATABASE.QUERY_TIMEOUT_MS, // Query timeout 10s

      // SSL configuration for production
      ...(isProduction && {
        ssl: {
          rejectUnauthorized: false, // Set to true with proper certificates
        },
      }),
    },

    // Retry logic for database connections
    retryAttempts: 3,
    retryDelay: 3000, // 3 seconds between retries

    // Query result caching
    cache: isDevelopment
      ? false
      : {
          type: 'database',
          tableName: 'query_result_cache',
          duration: DATABASE.CACHE_DURATION_MS, // Cache for 30 seconds
          ignoreErrors: true, // Don't fail queries if cache fails
        },

    // PostGIS extension (uncomment when ready to use)
    // installExtensions: true,
  };
};
import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
    HttpStatus,
  } from '@nestjs/common';
  import { Observable } from 'rxjs';
  import { map } from 'rxjs/operators';
  import { VerificationLevel } from '../../modules/users/entities/user.entity';
  import { Reflector } from '@nestjs/core';
  
  @Injectable()
  export class VerificationRequirementsInterceptor implements NestInterceptor {
    constructor(private reflector: Reflector) {}
  
    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
      const requiredLevel = this.reflector.get<VerificationLevel>(
        'requiredVerificationLevel',
        context.getHandler(),
      );
      
      if (!requiredLevel) {
        return next.handle();
      }
      
      const request = context.switchToHttp().getRequest();
      const user = request.user;
      
      const levelMessages = {
        [VerificationLevel.LEVEL_1]: 'Cette action nécessite la vérification de votre email.',
        [VerificationLevel.LEVEL_2]: 'Cette action nécessite la vérification de votre téléphone.',
        [VerificationLevel.LEVEL_3]: 'Cette action nécessite la vérification de votre identité.',
        [VerificationLevel.LEVEL_4]: 'Cette action nécessite la vérification avancée.',
      };
      
      if (user && user.verificationLevel < requiredLevel) {
        // Si le niveau est insuffisant, on continue mais on enrichit la réponse
        return next.handle().pipe(
          map(data => ({
            ...data,
            _verificationRequired: {
              currentLevel: user.verificationLevel,
              requiredLevel,
              message: levelMessages[requiredLevel],
              nextSteps: this.getNextSteps(user.verificationLevel, requiredLevel),
            },
          })),
        );
      }
      
      return next.handle();
    }
  
    private getNextSteps(currentLevel: VerificationLevel, requiredLevel: VerificationLevel): string[] {
        const steps: string[] = [];
      
      if (currentLevel < VerificationLevel.LEVEL_1 && requiredLevel >= VerificationLevel.LEVEL_1) {
        steps.push('Vérifiez votre adresse email');
      }
      
      if (currentLevel < VerificationLevel.LEVEL_2 && requiredLevel >= VerificationLevel.LEVEL_2) {
        steps.push('Vérifiez votre numéro de téléphone');
      }
      
      if (currentLevel < VerificationLevel.LEVEL_3 && requiredLevel >= VerificationLevel.LEVEL_3) {
        steps.push('Complétez la vérification de votre identité');
      }
      
      if (currentLevel < VerificationLevel.LEVEL_4 && requiredLevel >= VerificationLevel.LEVEL_4) {
        steps.push('Complétez la vérification avancée');
      }
      
      return steps;
    }
  }
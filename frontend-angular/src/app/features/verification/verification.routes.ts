import { Routes } from '@angular/router';

export const VERIFICATION_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/verification-wizard/verification-wizard.component').then(m => m.VerificationWizardComponent)
  }
];

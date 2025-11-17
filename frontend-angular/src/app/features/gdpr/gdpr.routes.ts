import { Routes } from '@angular/router';

export const GDPR_ROUTES: Routes = [
  {
    path: 'consent',
    loadComponent: () => import('./pages/consent-management/consent-management.component').then(m => m.ConsentManagementComponent)
  },
  {
    path: 'data-export',
    loadComponent: () => import('./pages/data-export/data-export.component').then(m => m.DataExportComponent)
  },
  {
    path: 'data-deletion',
    loadComponent: () => import('./pages/data-deletion/data-deletion.component').then(m => m.DataDeletionComponent)
  },
  {
    path: '',
    redirectTo: 'consent',
    pathMatch: 'full'
  }
];

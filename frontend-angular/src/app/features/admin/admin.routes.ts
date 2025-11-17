import { Routes } from '@angular/router';

export const ADMIN_ROUTES: Routes = [
  {
    path: 'users',
    loadComponent: () => import('./pages/user-management/user-management.component').then(m => m.UserManagementComponent)
  },
  {
    path: 'parking-verification',
    loadComponent: () => import('./pages/parking-verification/parking-verification.component').then(m => m.ParkingVerificationComponent)
  },
  {
    path: 'system-health',
    loadComponent: () => import('./pages/system-health/system-health.component').then(m => m.SystemHealthComponent)
  },
  {
    path: '',
    redirectTo: 'users',
    pathMatch: 'full'
  }
];

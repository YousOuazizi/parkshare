import { Routes } from '@angular/router';
import { authGuard } from '../../core/guards/auth.guard';
import { verificationLevelGuard } from '../../core/guards/verification-level.guard';
import { VerificationLevel } from '../../core/models';

export const PARKING_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/parking-list/parking-list.component').then(m => m.ParkingListComponent)
  },
  {
    path: 'my-parkings',
    canActivate: [authGuard, verificationLevelGuard],
    data: { verificationLevel: VerificationLevel.LEVEL_3 },
    loadComponent: () => import('./pages/my-parkings/my-parkings.component').then(m => m.MyParkingsComponent)
  },
  {
    path: 'create',
    canActivate: [authGuard, verificationLevelGuard],
    data: { verificationLevel: VerificationLevel.LEVEL_3 },
    loadComponent: () => import('./pages/parking-create/parking-create.component').then(m => m.ParkingCreateComponent)
  },
  {
    path: ':id',
    loadComponent: () => import('./pages/parking-detail/parking-detail.component').then(m => m.ParkingDetailComponent)
  },
  {
    path: ':id/edit',
    canActivate: [authGuard, verificationLevelGuard],
    data: { verificationLevel: VerificationLevel.LEVEL_3 },
    loadComponent: () => import('./pages/parking-create/parking-create.component').then(m => m.ParkingCreateComponent)
  }
];

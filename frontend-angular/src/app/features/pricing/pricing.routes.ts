import { Routes } from '@angular/router';

export const PRICING_ROUTES: Routes = [
  {
    path: 'dashboard/:parkingId',
    loadComponent: () => import('./pages/pricing-dashboard/pricing-dashboard.component').then(m => m.PricingDashboardComponent)
  },
  {
    path: '',
    redirectTo: '/parkings/my-parkings',
    pathMatch: 'full'
  }
];

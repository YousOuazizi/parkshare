import { Routes } from '@angular/router';

export const PAYMENT_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/payment-list/payment-list.component').then(m => m.PaymentListComponent)
  },
  {
    path: ':id',
    loadComponent: () => import('./pages/payment-detail/payment-detail.component').then(m => m.PaymentDetailComponent)
  }
];

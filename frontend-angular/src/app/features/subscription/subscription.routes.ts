import { Routes } from '@angular/router';

export const SUBSCRIPTION_ROUTES: Routes = [
  {
    path: 'plans',
    loadComponent: () => import('./pages/subscription-plans/subscription-plans.component').then(m => m.SubscriptionPlansComponent)
  },
  {
    path: 'my-subscriptions',
    loadComponent: () => import('./pages/my-subscriptions/my-subscriptions.component').then(m => m.MySubscriptionsComponent)
  },
  {
    path: '',
    redirectTo: 'plans',
    pathMatch: 'full'
  }
];

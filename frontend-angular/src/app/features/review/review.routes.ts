import { Routes } from '@angular/router';

export const REVIEW_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/review-list/review-list.component').then(m => m.ReviewListComponent)
  }
];

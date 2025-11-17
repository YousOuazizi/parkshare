import { Routes } from '@angular/router';

export const SWAP_ROUTES: Routes = [
  {
    path: 'listings',
    loadComponent: () => import('./pages/swap-listings/swap-listings.component').then(m => m.SwapListingsComponent)
  },
  {
    path: 'my-listings',
    loadComponent: () => import('./pages/my-swap-listings/my-swap-listings.component').then(m => m.MySwapListingsComponent)
  },
  {
    path: 'offers',
    loadComponent: () => import('./pages/swap-offers/swap-offers.component').then(m => m.SwapOffersComponent)
  },
  {
    path: '',
    redirectTo: 'listings',
    pathMatch: 'full'
  }
];

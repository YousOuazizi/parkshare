import { Routes } from '@angular/router';

export const BOOKING_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/booking-list/booking-list.component').then(m => m.BookingListComponent)
  },
  {
    path: 'create/:parkingId',
    loadComponent: () => import('./pages/create-booking/create-booking.component').then(m => m.CreateBookingComponent)
  },
  {
    path: ':id',
    loadComponent: () => import('./pages/booking-detail/booking-detail.component').then(m => m.BookingDetailComponent)
  }
];

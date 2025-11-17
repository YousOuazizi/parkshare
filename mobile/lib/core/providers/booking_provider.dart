import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking_model.dart';
import '../../data/services/booking_service.dart';
import 'service_providers.dart';

// All Bookings Provider
final bookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getAllBookings();
});

// Active Bookings Provider
final activeBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final bookingService = ref.watch(bookingServiceProvider);
  final bookings = await bookingService.getAllBookings();
  return bookings.where((b) => b.isActive).toList();
});

// Past Bookings Provider
final pastBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final bookingService = ref.watch(bookingServiceProvider);
  final bookings = await bookingService.getAllBookings();
  return bookings.where((b) => b.isCompleted).toList();
});

// Cancelled Bookings Provider
final cancelledBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final bookingService = ref.watch(bookingServiceProvider);
  final bookings = await bookingService.getAllBookings();
  return bookings.where((b) => b.isCancelled).toList();
});

// Booking by ID Provider
final bookingByIdProvider = FutureProvider.family<BookingModel, String>((ref, id) async {
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getBookingById(id);
});

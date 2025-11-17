import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/user_service.dart';
import '../../data/services/parking_service.dart';
import '../../data/services/booking_service.dart';
import '../../data/services/review_service.dart';
import '../../data/services/spotswap_service.dart';
import '../../data/services/analytics_service.dart';

// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Service Providers
final authServiceProvider = Provider<AuthService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthService(dioClient);
});

final userServiceProvider = Provider<UserService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UserService(dioClient);
});

final parkingServiceProvider = Provider<ParkingService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ParkingService(dioClient);
});

final bookingServiceProvider = Provider<BookingService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return BookingService(dioClient);
});

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ReviewService(dioClient);
});

final spotSwapServiceProvider = Provider<SpotSwapService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SpotSwapService(dioClient);
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AnalyticsService(dioClient);
});

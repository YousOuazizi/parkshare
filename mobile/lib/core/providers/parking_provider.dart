import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/parking_model.dart';
import '../../data/services/parking_service.dart';
import 'service_providers.dart';

// Parkings List Provider
final parkingsProvider = FutureProvider<List<ParkingModel>>((ref) async {
  final parkingService = ref.watch(parkingServiceProvider);
  return await parkingService.getAllParkings();
});

// Parking by ID Provider
final parkingByIdProvider = FutureProvider.family<ParkingModel, String>((ref, id) async {
  final parkingService = ref.watch(parkingServiceProvider);
  return await parkingService.getParkingById(id);
});

// Search Parkings Provider
final searchParkingsProvider = FutureProvider.autoDispose.family<List<ParkingModel>, SearchParams>((ref, params) async {
  final parkingService = ref.watch(parkingServiceProvider);
  return await parkingService.searchParkings(
    latitude: params.latitude,
    longitude: params.longitude,
    radius: params.radius,
    minPrice: params.minPrice,
    maxPrice: params.maxPrice,
    features: params.features,
  );
});

class SearchParams {
  final double? latitude;
  final double? longitude;
  final double? radius;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? features;

  SearchParams({
    this.latitude,
    this.longitude,
    this.radius,
    this.minPrice,
    this.maxPrice,
    this.features,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          radius == other.radius &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice;

  @override
  int get hashCode => Object.hash(latitude, longitude, radius, minPrice, maxPrice);
}

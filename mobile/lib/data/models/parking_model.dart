import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingModel {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final double pricePerHour;
  final List<String> photos;
  final List<String> features;
  final bool isAvailable;
  final int totalSpots;
  final int availableSpots;
  final double rating;
  final int reviewsCount;
  final DateTime createdAt;

  ParkingModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.pricePerHour,
    required this.photos,
    required this.features,
    required this.isAvailable,
    required this.totalSpots,
    required this.availableSpots,
    required this.rating,
    required this.reviewsCount,
    required this.createdAt,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      id: json['id'],
      ownerId: json['ownerId'] ?? json['owner']?['id'] ?? '',
      name: json['name'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] ?? '',
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      photos: List<String>.from(json['photos'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      totalSpots: json['totalSpots'] ?? 1,
      availableSpots: json['availableSpots'] ?? 1,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'pricePerHour': pricePerHour,
      'photos': photos,
      'features': features,
      'isAvailable': isAvailable,
      'totalSpots': totalSpots,
      'availableSpots': availableSpots,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  LatLng get position => LatLng(latitude, longitude);
}

class CreateParkingDto {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final double pricePerHour;
  final List<String> features;
  final int totalSpots;

  CreateParkingDto({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.pricePerHour,
    required this.features,
    required this.totalSpots,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'pricePerHour': pricePerHour,
      'features': features,
      'totalSpots': totalSpots,
    };
  }
}

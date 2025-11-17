class CreateParkingDto {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final double pricePerHour;
  final List<String> features;
  final List<String> images;
  final bool isActive;

  CreateParkingDto({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.pricePerHour,
    required this.features,
    required this.images,
    this.isActive = true,
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
      'images': images,
      'isActive': isActive,
    };
  }
}

class SwapListing {
  final String id;
  final String userId;
  final String parkingId;
  final String parkingName;
  final String location;
  final DateTime availableFrom;
  final DateTime availableTo;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  SwapListing({
    required this.id,
    required this.userId,
    required this.parkingId,
    required this.parkingName,
    required this.location,
    required this.availableFrom,
    required this.availableTo,
    this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory SwapListing.fromJson(Map<String, dynamic> json) {
    return SwapListing(
      id: json['id'],
      userId: json['userId'],
      parkingId: json['parkingId'],
      parkingName: json['parkingName'],
      location: json['location'],
      availableFrom: DateTime.parse(json['availableFrom']),
      availableTo: DateTime.parse(json['availableTo']),
      description: json['description'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'parkingId': parkingId,
      'parkingName': parkingName,
      'location': location,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class SwapOffer {
  final String id;
  final String listingId;
  final String offererId;
  final String offererParkingId;
  final String offererParkingName;
  final String offererLocation;
  final String status; // pending, accepted, rejected
  final String? message;
  final DateTime createdAt;

  SwapOffer({
    required this.id,
    required this.listingId,
    required this.offererId,
    required this.offererParkingId,
    required this.offererParkingName,
    required this.offererLocation,
    required this.status,
    this.message,
    required this.createdAt,
  });

  factory SwapOffer.fromJson(Map<String, dynamic> json) {
    return SwapOffer(
      id: json['id'],
      listingId: json['listingId'],
      offererId: json['offererId'],
      offererParkingId: json['offererParkingId'],
      offererParkingName: json['offererParkingName'],
      offererLocation: json['offererLocation'],
      status: json['status'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

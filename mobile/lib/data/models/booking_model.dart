class BookingModel {
  final String id;
  final String userId;
  final String parkingId;
  final String parkingName;
  final String parkingAddress;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final double totalPrice;
  final String status; // pending, confirmed, active, completed, cancelled
  final String? paymentIntentId;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.parkingId,
    required this.parkingName,
    required this.parkingAddress,
    required this.startDateTime,
    required this.endDateTime,
    required this.totalPrice,
    required this.status,
    this.paymentIntentId,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['userId'],
      parkingId: json['parkingId'],
      parkingName: json['parking']?['name'] ?? json['parkingName'] ?? '',
      parkingAddress: json['parking']?['address'] ?? json['parkingAddress'] ?? '',
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'],
      paymentIntentId: json['paymentIntentId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'parkingId': parkingId,
      'parkingName': parkingName,
      'parkingAddress': parkingAddress,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status,
      'paymentIntentId': paymentIntentId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isActive => status == 'active' || status == 'confirmed';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

class CreateBookingDto {
  final String parkingId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String paymentMethodId;

  CreateBookingDto({
    required this.parkingId,
    required this.startDateTime,
    required this.endDateTime,
    required this.paymentMethodId,
  });

  Map<String, dynamic> toJson() {
    return {
      'parkingId': parkingId,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'paymentMethodId': paymentMethodId,
    };
  }
}

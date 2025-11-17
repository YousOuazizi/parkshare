import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';

class AnalyticsService {
  final DioClient _dioClient;

  AnalyticsService(this._dioClient);

  Future<OwnerStats> getOwnerStats() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.ownerStats);
      return OwnerStats.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RevenueData>> getOwnerRevenue({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.ownerRevenue,
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => RevenueData.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<BookingStats>> getOwnerBookings({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.ownerBookings,
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => BookingStats.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final message = error.response!.data['message'];
        return message ?? 'Une erreur est survenue';
      }
      return 'Erreur de connexion au serveur';
    }
    return error.toString();
  }
}

class OwnerStats {
  final int totalParkings;
  final int totalBookings;
  final double totalRevenue;
  final double averageRating;
  final int totalReviews;

  OwnerStats({
    required this.totalParkings,
    required this.totalBookings,
    required this.totalRevenue,
    required this.averageRating,
    required this.totalReviews,
  });

  factory OwnerStats.fromJson(Map<String, dynamic> json) {
    return OwnerStats(
      totalParkings: json['totalParkings'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

class RevenueData {
  final DateTime date;
  final double amount;

  RevenueData({
    required this.date,
    required this.amount,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class BookingStats {
  final DateTime date;
  final int count;

  BookingStats({
    required this.date,
    required this.count,
  });

  factory BookingStats.fromJson(Map<String, dynamic> json) {
    return BookingStats(
      date: DateTime.parse(json['date']),
      count: json['count'] ?? 0,
    );
  }
}

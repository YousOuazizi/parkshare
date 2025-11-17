import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../features/reviews/domain/entities/review.dart';

class ReviewService {
  final DioClient _dioClient;

  ReviewService(this._dioClient);

  Future<List<Review>> getReviewsByParkingId(String parkingId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.reviewsByParkingId(parkingId),
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Review> createReview({
    required String parkingId,
    required double rating,
    required String comment,
    List<String>? photos,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.reviews,
        data: {
          'parkingId': parkingId,
          'rating': rating,
          'comment': comment,
          'photos': photos ?? [],
        },
      );

      return Review.fromJson(response.data);
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

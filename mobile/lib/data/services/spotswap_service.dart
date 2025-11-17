import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../features/spotswap/domain/entities/swap_listing.dart';

class SpotSwapService {
  final DioClient _dioClient;

  SpotSwapService(this._dioClient);

  Future<List<SwapListing>> getAllListings() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.swapListings);

      final List<dynamic> data = response.data;
      return data.map((json) => SwapListing.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<SwapListing> createListing({
    required String parkingId,
    required DateTime availableFrom,
    required DateTime availableTo,
    String? description,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.swapListings,
        data: {
          'parkingId': parkingId,
          'availableFrom': availableFrom.toIso8601String(),
          'availableTo': availableTo.toIso8601String(),
          'description': description,
        },
      );

      return SwapListing.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<SwapOffer> createOffer({
    required String listingId,
    required String offererParkingId,
    String? message,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.swapOffers,
        data: {
          'listingId': listingId,
          'offererParkingId': offererParkingId,
          'message': message,
        },
      );

      return SwapOffer.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<SwapOffer> acceptOffer(String offerId) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.acceptSwapOffer(offerId),
      );

      return SwapOffer.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<SwapOffer> rejectOffer(String offerId) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.rejectSwapOffer(offerId),
      );

      return SwapOffer.fromJson(response.data);
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

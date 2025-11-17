import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/parking_model.dart';

class ParkingService {
  final DioClient _dioClient;

  ParkingService(this._dioClient);

  Future<List<ParkingModel>> getAllParkings({String? userId}) async {
    try {
      final queryParams = userId != null ? {'userId': userId} : null;
      final response = await _dioClient.dio.get(
        ApiEndpoints.parkings,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ParkingModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ParkingModel> getParkingById(String id) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.parkingById(id),
      );

      return ParkingModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ParkingModel>> searchParkings({
    double? latitude,
    double? longitude,
    double? radius,
    double? minPrice,
    double? maxPrice,
    List<String>? features,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (radius != null) queryParams['radius'] = radius;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (features != null && features.isNotEmpty) {
        queryParams['features'] = features.join(',');
      }

      final response = await _dioClient.dio.get(
        ApiEndpoints.searchParkings,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ParkingModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ParkingModel> createParking(CreateParkingDto dto) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.parkings,
        data: dto.toJson(),
      );

      return ParkingModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ParkingModel> updateParking(String id, CreateParkingDto dto) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.parkingById(id),
        data: dto.toJson(),
      );

      return ParkingModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteParking(String id) async {
    try {
      await _dioClient.dio.delete(ApiEndpoints.parkingById(id));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> checkAvailability({
    required String parkingId,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.checkAvailability(parkingId),
        queryParameters: {
          'startDateTime': startDateTime.toIso8601String(),
          'endDateTime': endDateTime.toIso8601String(),
        },
      );

      return response.data['available'] ?? false;
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

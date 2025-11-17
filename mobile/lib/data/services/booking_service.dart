import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/booking_model.dart';

class BookingService {
  final DioClient _dioClient;

  BookingService(this._dioClient);

  Future<List<BookingModel>> getAllBookings({String? status}) async {
    try {
      final queryParams = status != null ? {'status': status} : null;
      final response = await _dioClient.dio.get(
        ApiEndpoints.bookings,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> getBookingById(String id) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.bookingById(id),
      );

      return BookingModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> createBooking(CreateBookingDto dto) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.bookings,
        data: dto.toJson(),
      );

      return BookingModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> cancelBooking(String id) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.cancelBooking(id),
      );

      return BookingModel.fromJson(response.data);
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

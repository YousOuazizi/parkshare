import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this._dioClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      final user = UserModel.fromJson(response.data['user']);

      // Save tokens
      await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
      await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
      await _storage.write(key: AppConstants.userIdKey, value: user.id);
      await _storage.write(key: AppConstants.userEmailKey, value: user.email);

      return {
        'user': user,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        },
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      final user = UserModel.fromJson(response.data['user']);

      // Save tokens
      await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
      await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
      await _storage.write(key: AppConstants.userIdKey, value: user.id);
      await _storage.write(key: AppConstants.userEmailKey, value: user.email);

      return {
        'user': user,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dioClient.dio.post(ApiEndpoints.logout);
    } catch (e) {
      // Continue even if API call fails
    } finally {
      // Clear local storage
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      await _storage.delete(key: AppConstants.userIdKey);
      await _storage.delete(key: AppConstants.userEmailKey);
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: AppConstants.userIdKey);
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

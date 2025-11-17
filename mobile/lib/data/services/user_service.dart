import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

class UserService {
  final DioClient _dioClient;

  UserService(this._dioClient);

  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateProfile(UpdateProfileDto dto) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.updateProfile,
        data: dto.toJson(),
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dioClient.dio.post(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _dioClient.dio.post(
        '/users/avatar',
        data: formData,
      );

      return response.data['avatarUrl'];
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

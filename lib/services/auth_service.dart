import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../core/config/api_config.dart';
import '../models/login_response.dart';
import '../core/storage/secure_storage.dart';

class AuthService {
  final Dio _dio = DioClient.dio;

  // =========================
  // LOGIN
  // =========================

  Future<LoginResponse> login(String login, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,

        data: {'login': login, 'password': password},
      );

      final result = LoginResponse.fromJson(response.data);

      // simpan token

      await SecureStorage.saveToken(result.token);

      // simpan user untuk profile

      await SecureStorage.saveUser(result.user.toJson());

      return result;
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? e.response?.data['message']?.toString()
          : e.message;

      throw Exception(message ?? 'Login gagal');
    }
  }

  // =========================
  // REGISTER
  // =========================

  Future<Map<String, dynamic>> register({
    required String name,

    String? email,

    required String phone,

    required String address,

    required String beneficiaryType,

    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,

        'phone': phone,

        'address': address,

        'beneficiary_type': beneficiaryType,

        'password': password,

        'password_confirmation': password,
      };

      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      }

      final response = await _dio.post(ApiConfig.register, data: data);

      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        // Laravel validation

        if (data['errors'] != null) {
          final errors = data['errors'];

          throw Exception(errors.values.first[0]);
        }

        throw Exception(data['message'] ?? 'Registrasi gagal');
      }

      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  // =========================
  // CHANGE PASSWORD
  // =========================

  Future<void> changePassword({
    required String currentPassword,

    required String newPassword,

    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.changePassword,

        data: {
          'current_password': currentPassword,

          'password': newPassword,

          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Gagal mengubah password');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        if (data['errors'] != null) {
          final errors = data['errors'];

          throw Exception(errors.values.first[0]);
        }

        throw Exception(data['message'] ?? 'Gagal mengubah password');
      }

      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    try {
      await _dio.post(ApiConfig.logout);
    } catch (_) {
    } finally {
      await SecureStorage.deleteToken();
    }
  }

  // =========================
  // FORGOT PASSWORD
  // =========================

  Future<void> forgotPassword(String contact) async {
    try {
      await _dio.post(ApiConfig.forgotPassword, data: {"contact": contact});
    } on DioException catch (e) {
      final data = e.response?.data;

      throw Exception(data?['message'] ?? "Gagal mengirim OTP");
    }
  }

  // =========================
  // VERIFY OTP
  // =========================

  Future<String> verifyOtp({
    required String contact,

    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.verifyOtp,

        data: {"contact": contact, "otp": otp},
      );

      return response.data['reset_token'];
    } on DioException catch (e) {
      final data = e.response?.data;

      throw Exception(data?['message'] ?? "OTP tidak valid");
    }
  }

  // =========================
  // RESET PASSWORD
  // =========================

  Future<void> resetPassword({
    required String contact,

    required String resetToken,

    required String password,

    required String passwordConfirmation,
  }) async {
    try {
      await _dio.post(
        ApiConfig.resetPassword,

        data: {
          "contact": contact,

          "reset_token": resetToken,

          "password": password,

          "password_confirmation": passwordConfirmation,
        },
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      throw Exception(data?['message'] ?? "Gagal reset password");
    }
  }
}

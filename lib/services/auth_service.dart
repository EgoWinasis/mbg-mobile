import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
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
        '/auth/login',

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

      final response = await _dio.post('/auth/register', data: data);

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
}

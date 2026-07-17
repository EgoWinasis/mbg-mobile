import 'dart:io';

import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';

import '../models/confirmation_model.dart';

class ConfirmationService {
  final Dio _dio = Dio();

  // ============================================
  // CEK SUDAH VERIFIKASI
  // ============================================

  Future<ConfirmationModel?> getLatestConfirmation() async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Token tidak ditemukan");
      }

      final response = await _dio.get(
        ApiConfig.latestConfirmation,

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
      );

      if (response.data['data'] == null) {
        return null;
      }

      return ConfirmationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // ============================================
  // KIRIM VERIFIKASI
  // ============================================

  Future<ConfirmationModel> sendConfirmation({
    required int distributionId,

    required int rating,

    String? kritik,

    required File photo,

    required double latitude,

    required double longitude,
  }) async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Silakan login ulang");
      }

      final formData = FormData.fromMap({
        "distribution_id": distributionId,

        "rating": rating,

        "kritik": kritik ?? "",

        "latitude": latitude,

        "longitude": longitude,

        "photo": await MultipartFile.fromFile(
          photo.path,

          filename: photo.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConfig.confirmations,

        data: formData,

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",

            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return ConfirmationModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}

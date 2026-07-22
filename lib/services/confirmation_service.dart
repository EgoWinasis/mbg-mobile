import 'dart:io';

import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';

import '../models/confirmation_model.dart';

class ConfirmationService {
  final Dio _dio = Dio();

  // ============================================
  // CEK VERIFIKASI TERAKHIR
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
  // CEK SUDAH MENGISI HARI INI
  // ============================================

  Future<ConfirmationModel?> getTodayConfirmation() async {
    return await getLatestConfirmation();
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

  // ============================================
  // RIWAYAT VERIFIKASI
  // ============================================

  Future<List<ConfirmationModel>> getHistoryConfirmation({
    int? month,
    int? year,
  }) async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Token tidak ditemukan");
      }

      final response = await _dio.get(
        ApiConfig.confirmations,

        queryParameters: {
          if (month != null) "month": month,

          if (year != null) "year": year,
        },

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
      );

      final List data = response.data['data'];

      return data.map((item) => ConfirmationModel.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // ============================================
  // DETAIL CONFIRMATION
  // ============================================

  Future<ConfirmationModel?> getConfirmationDetail(int id) async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Token tidak ditemukan");
      }

      final response = await _dio.get(
        ApiConfig.confirmationDetail(id),

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
}

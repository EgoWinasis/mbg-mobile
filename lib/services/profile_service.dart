import 'dart:io';

import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';

class ProfileService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,

      headers: {"Accept": "application/json"},
    ),
  );

  // =========================
  // HEADER TOKEN
  // =========================

  Future<Map<String, String>> _headers() async {
    final token = await SecureStorage.getToken();

    return {"Accept": "application/json", "Authorization": "Bearer $token"};
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<void> updateProfile({
    required String name,

    required String phone,

    required String email,

    required String address,

    required String nik,

    required String birthDate,

    required String gender,

    required String beneficiaryType,

    // tambahan
    String? childName,

    String? childBirthDate,
  }) async {
    try {
      final response = await dio.put(
        ApiConfig.updateProfile,

        data: {
          "name": name,

          "phone": phone,

          "email": email,

          "address": address,

          "nik": nik,

          "birth_date": birthDate,

          "gender": gender,

          "beneficiary_type": beneficiaryType,

          // tambahan anak / kehamilan
          "child_name": childName,

          "child_birth_date": childBirthDate,
        },

        options: Options(headers: await _headers()),
      );

      // =========================
      // UPDATE LOCAL STORAGE
      // =========================

      if (response.data != null && response.data['user'] != null) {
        await SecureStorage.saveUser(
          Map<String, dynamic>.from(response.data['user']),
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Gagal update profile");
    }
  }

  // =========================
  // UPLOAD FOTO PROFILE
  // =========================

  Future<void> uploadPhoto(File file) async {
    try {
      final formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile(
          file.path,

          filename: file.path.split('/').last,
        ),
      });

      final response = await dio.post(
        ApiConfig.profilePhoto,

        data: formData,

        options: Options(
          headers: await _headers(),

          contentType: "multipart/form-data",
        ),
      );

      // =========================
      // UPDATE FOTO DI STORAGE
      // =========================

      final user = await SecureStorage.getUser();

      if (user != null &&
          user['profile'] != null &&
          response.data['photo'] != null) {
        user['profile']['photo'] = response.data['photo'];

        await SecureStorage.saveUser(user);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Gagal upload foto");
    }
  }
}

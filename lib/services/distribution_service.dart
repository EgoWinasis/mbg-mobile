import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';
import '../models/distribution_model.dart';

class DistributionService {
  final Dio _dio = Dio();

  Future<DistributionModel?> getToday() async {
    final token = await SecureStorage.getToken();

    if (token == null) {
      throw Exception("Belum login");
    }

    try {
      final response = await _dio.get(
        ApiConfig.distributionToday,

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
      );

      final data = response.data['data'];

      // Tidak ada distribusi hari ini
      if (data == null) {
        return null;
      }

      // Jika backend mengirim object kosong {}
      if (data is Map && data.isEmpty) {
        return null;
      }

      return DistributionModel.fromJson(data);
    } on DioException catch (e) {
      // API 404 = belum ada distribusi hari ini

      if (e.response?.statusCode == 404) {
        return null;
      }

      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}

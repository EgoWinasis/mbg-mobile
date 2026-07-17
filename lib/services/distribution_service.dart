import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';
import '../models/distribution_model.dart';

class DistributionService {
  final Dio _dio = Dio();

  Future<DistributionModel> getToday() async {
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

      return DistributionModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}

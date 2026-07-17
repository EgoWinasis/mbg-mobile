import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  final Dio dio = Dio();

  Future<List<ScheduleModel>> getSchedules({
    String? type,

    String? month,
  }) async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Silakan login terlebih dahulu");
      }

      final response = await dio.get(
        ApiConfig.schedules,

        queryParameters: {
          if (type != null) "type": type,

          if (month != null) "month": month,
        },

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
      );

      if (response.data['success'] == true) {
        final List data = response.data['data'];

        return data.map((e) {
          return ScheduleModel.fromJson(e);
        }).toList();
      }

      throw Exception("Gagal mengambil jadwal");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Sesi login habis, silakan login ulang");
      }

      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<ScheduleModel> detail(int id) async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Silakan login terlebih dahulu");
      }

      final response = await dio.get(
        ApiConfig.scheduleDetail(id),

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
      );

      if (response.data['success'] == true) {
        return ScheduleModel.fromJson(response.data['data']);
      }

      throw Exception("Detail jadwal tidak ditemukan");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Sesi login habis, silakan login ulang");
      }

      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}

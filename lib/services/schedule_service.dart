import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  final Dio dio = Dio();

  Future<List<ScheduleModel>> getSchedules({
    String? type,

    String? month,
  }) async {
    final response = await dio.get(
      ApiConfig.schedules,

      queryParameters: {
        if (type != null) "type": type,

        if (month != null) "month": month,
      },
    );

    if (response.data['success'] == true) {
      final List data = response.data['data'];

      return data.map((e) => ScheduleModel.fromJson(e)).toList();
    }

    throw Exception("Gagal mengambil jadwal");
  }

  Future<ScheduleModel> detail(int id) async {
    final response = await dio.get(ApiConfig.scheduleDetail(id));

    if (response.data['success'] == true) {
      return ScheduleModel.fromJson(response.data['data']);
    }

    throw Exception("Detail jadwal tidak ditemukan");
  }
}

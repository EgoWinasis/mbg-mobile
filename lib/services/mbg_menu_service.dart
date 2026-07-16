import 'package:dio/dio.dart';

import '../models/mbg_menu_model.dart';
import '../core/config/api_config.dart';

class MbgMenuService {
  final Dio dio = Dio();

  Future<MbgMenuModel> getMenu({String? date}) async {
    try {
      final response = await dio.get(
        ApiConfig.mbgMenu,

        queryParameters: {if (date != null) "date": date},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          return MbgMenuModel.fromJson(data['data']);
        }

        throw Exception("Menu belum tersedia untuk tanggal tersebut");
      }

      throw Exception("Server tidak merespon");
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Koneksi timeout, periksa jaringan");
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception("Tidak dapat terhubung ke server");
      }

      if (e.response?.statusCode == 404) {
        throw Exception("Menu belum tersedia");
      }

      throw Exception("Terjadi kesalahan mengambil menu");
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}

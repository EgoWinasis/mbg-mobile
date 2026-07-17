import 'package:dio/dio.dart';

import '../models/mbg_menu_model.dart';
import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';

class MbgMenuService {
  final Dio dio = Dio();

  Future<MbgMenuModel> getMenu({String? date}) async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception("Silakan login terlebih dahulu");
      }

      final response = await dio.get(
        ApiConfig.mbgMenu,

        queryParameters: {if (date != null) "date": date},

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Accept": "application/json",
          },
        ),
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

      if (e.response?.statusCode == 401) {
        throw Exception("Sesi login habis, silakan login ulang");
      }

      if (e.response?.statusCode == 404) {
        throw Exception("Menu belum tersedia");
      }

      throw Exception(
        e.response?.data['message'] ?? "Terjadi kesalahan mengambil menu",
      );
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}

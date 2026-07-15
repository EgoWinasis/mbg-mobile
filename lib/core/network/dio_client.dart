import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await SecureStorage.deleteToken();
          }

          handler.next(error);
        },
      ),
    );

    return dio;
  }
}

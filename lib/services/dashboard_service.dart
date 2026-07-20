import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import '../models/dashboard_model.dart';
import '../core/storage/secure_storage.dart';

class DashboardService {
  Future<DashboardModel> getDashboard() async {
    final token = await SecureStorage.getToken();

    final response = await http.get(
      Uri.parse(ApiConfig.dashboard),

      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return DashboardModel.fromJson(json['data']);
    } else {
      throw Exception('Gagal mengambil dashboard');
    }
  }
}

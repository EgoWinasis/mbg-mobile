import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../models/category_model.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConfig.categories);

      final List data = response.data['data'];

      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}

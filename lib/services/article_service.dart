import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../models/article_model.dart';



class ArticleService {


  final Dio _dio = Dio();





  Future<List<ArticleModel>> getArticles({

    int? categoryId,

    String? keyword,

  }) async {


    try {


      final response = await _dio.get(


        ApiConfig.articles,



        queryParameters: {


          if(keyword != null &&
              keyword.isNotEmpty)

            "keyword":
            keyword,



          if(categoryId != null)

            "category_id":
            categoryId,


        },


      );




      final List data =
          response.data['data'];




      return data.map((item){


        return ArticleModel.fromJson(
          item,
        );


      }).toList();



    } on DioException catch(e){



      throw Exception(

        e.response?.data['message']

        ??
        e.message,

      );


    }


  }









  Future<ArticleModel> getArticleDetail(

      String slug

      ) async {



    try {


      final response =
      await _dio.get(


        ApiConfig.articleDetail(
          slug,
        ),


      );




      return ArticleModel.fromJson(

        response.data['data'],

      );



    } on DioException catch(e){



      throw Exception(

        e.response?.data['message']

        ??
        e.message,

      );


    }


  }



}
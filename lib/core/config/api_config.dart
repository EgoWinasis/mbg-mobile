class ApiConfig {
  // Local Development
  static const String baseUrl = 'http://192.168.52.52:8000/api';

  static String get serverUrl {

    return baseUrl.replaceFirst('/api', '');

  }


  static String imageUrl(String path) {

    return "$serverUrl/storage/$path";

  }
  

  // Auth
  static const String login = '$baseUrl/auth/login';

  // User
  static const String profile = '$baseUrl/auth/profile';

  // Lainnya jika ada
  static const String register = '$baseUrl/auth/register';
  static const String logout = '$baseUrl/auth/logout';

  // PROFILE
  static const String updateProfile =
      '$baseUrl/profile';


  static const String profilePhoto =
      '$baseUrl/profile/photo';



  // EDUKASI
  static const String categories =
      '$baseUrl/education/categories';

  static const String articles =
      '$baseUrl/education/articles';

  static String articleDetail(String slug) =>
      '$baseUrl/education/articles/$slug';


  static const String mbgMenu = '$baseUrl/mbg/menu';

  static const String schedules = '$baseUrl/schedules';

  static String scheduleDetail(int id) => '$baseUrl/schedules/$id';


  // Production nanti ganti:
  // static const String baseUrl = 'https://domainanda.com/api';
}

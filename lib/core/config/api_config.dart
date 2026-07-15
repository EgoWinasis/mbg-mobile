class ApiConfig {
  // Local Development
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth
  static const String login = '$baseUrl/auth/login';

  // User
  static const String profile = '$baseUrl/auth/profile';

  // Lainnya jika ada
  static const String register = '$baseUrl/auth/register';
  static const String logout = '$baseUrl/auth/logout';

  // Production nanti ganti:
  // static const String baseUrl = 'https://domainanda.com/api';
}

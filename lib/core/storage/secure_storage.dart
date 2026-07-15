import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  // =========================
  // TOKEN
  // =========================

  static Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  // =========================
  // USER DATA
  // =========================

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await storage.write(key: 'user', value: jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final String? data = await storage.read(key: 'user');

    if (data == null) {
      return null;
    }

    return jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<void> deleteUser() async {
    await storage.delete(key: 'user');
  }

  // =========================
  // CHECK LOGIN
  // =========================

  static Future<bool> isLogin() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }

  // =========================
  // LOGOUT
  // =========================

  static Future<void> logout() async {
    await storage.deleteAll();
  }
}

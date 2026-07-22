import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // =========================
  // PREFERENSI APLIKASI
  // =========================

  static const String suara = "pref_suara";

  static const String getar = "pref_getar";

  // =========================
  // SIMPAN NILAI
  // =========================

  static Future<void> save(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  // =========================
  // AMBIL NILAI
  // =========================

  static Future<bool> get(String key, {bool defaultValue = true}) async {
    final value = await _storage.read(key: key);

    if (value == null) {
      return defaultValue;
    }

    return value == "true";
  }

  // =========================
  // HAPUS PREFERENSI
  // =========================

  static Future<void> clear() async {
    await _storage.delete(key: suara);

    await _storage.delete(key: getar);
  }
}

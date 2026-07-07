import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/splash_screen.dart';

Future<void> requestAppPermission() async {
  await [
    // Notifikasi Android 13+
    Permission.notification,

    // Kamera
    Permission.camera,

    // Foto / Galeri
    Permission.photos,

    // Lokasi
    Permission.location,
  ].request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestAppPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Monitoring MBG',

      theme: ThemeData(primarySwatch: Colors.blue),

      home: const SplashScreen(),
    );
  }
}

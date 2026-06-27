import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (_, _, _) => const LoginScreen(),
    transitionsBuilder: (_, animation, _, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // LOGO
            Image.asset(
              'assets/images/logo.png',
              width: 140,
              height: 140,
            ),

            const SizedBox(height: 20),

            const Text(
              "SMPM MBG",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            

          ],
        ),
      ),
    );
  }
}
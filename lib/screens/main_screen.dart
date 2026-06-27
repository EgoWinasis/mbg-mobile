import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'edukasi_screen.dart';
import '../widgets/app_bottom_nav.dart';
import 'menu_screen.dart';
import 'jadwal_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;


  final List<Widget> pages = const [
  DashboardScreen(),

  // Index 1
  JadwalScreen(),

  // Index 2
  MenuScreen(),

  EdukasiScreen(),

  ProfileScreen(),
];


  @override
  Widget build(BuildContext context) {

    return Scaffold(  

      backgroundColor: Colors.white,


      body: IndexedStack(

        index: currentIndex,

        children: pages,

      ),


      bottomNavigationBar: AppBottomNav(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });

        },

      ),

    );
  }
}
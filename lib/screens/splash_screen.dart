import 'dart:async';

import 'package:flutter/material.dart';

import '../core/storage/secure_storage.dart';

import 'login_screen.dart';
import 'main_screen.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}




class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {



  @override
  void initState() {

    super.initState();

    checkLogin();

  }





  Future<void> checkLogin() async {


    await Future.delayed(
      const Duration(seconds: 3),
    );



    final isLogin =
        await SecureStorage.isLogin();




    if(!mounted) return;




    Navigator.pushReplacement(

      context,


      PageRouteBuilder(

        pageBuilder:
            (_, animation, secondaryAnimation) {


          if(isLogin){

            return const MainScreen();

          }


          return const LoginScreen();

        },


        transitionsBuilder:
            (_, animation, _, child){


          return FadeTransition(

            opacity: animation,

            child: child,

          );


        },


      ),

    );


  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      Colors.blue,


      body:

      Center(

        child:

        Column(


          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [



            Image.asset(

              'assets/images/logo.png',

              width:140,

              height:140,

            ),




            const SizedBox(
              height:20,
            ),




            const Text(

              "SMPM MBG",

              style:

              TextStyle(

                fontSize:28,

                color:Colors.white,

                fontWeight:
                FontWeight.bold,

              ),

            ),



          ],

        ),

      ),

    );

  }

}
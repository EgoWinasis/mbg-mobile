import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../core/storage/secure_storage.dart';

import 'login_screen.dart';


class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({super.key});

  @override
  State<UbahPasswordScreen> createState() =>
      _UbahPasswordScreenState();
}


class _UbahPasswordScreenState
    extends State<UbahPasswordScreen> {

  final oldPasswordController =
      TextEditingController();

  final newPasswordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();


  final AuthService authService =
      AuthService();


  bool loading = false;



  Future<void> ubahPassword() async {

    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Semua password wajib diisi",
          ),
        ),
      );

      return;
    }



    if (newPasswordController.text.length < 8) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password baru minimal 8 karakter",
          ),
        ),
      );

      return;
    }



    if (newPasswordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Konfirmasi password tidak sama",
          ),
        ),
      );

      return;
    }



    try {

      setState(() {
        loading = true;
      });



      await authService.changePassword(

        currentPassword:
            oldPasswordController.text,

        newPassword:
            newPasswordController.text,

        passwordConfirmation:
            confirmPasswordController.text,

      );



      await SecureStorage.deleteToken();



      if (!mounted) return;



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password berhasil diubah",
          ),
        ),
      );



      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),

        (route) => false,

      );



    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            e.toString()
                .replaceFirst(
                  "Exception: ",
                  "",
                ),
          ),
        ),

      );


    } finally {

      if (mounted) {

        setState(() {
          loading = false;
        });

      }

    }

  }




  Widget inputPassword(
    String label,
    TextEditingController controller,
  ) {

    return TextField(

      controller: controller,

      obscureText: true,

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: const Icon(
          Icons.lock_outline,
        ),

        border: OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(12),

        ),

      ),

    );

  }




  @override
  void dispose() {

    oldPasswordController.dispose();

    newPasswordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      body: SafeArea(

        child: Padding(

          padding:
              const EdgeInsets.all(16),


          child: Column(

            children: [


              // HEADER

              Row(

                children: [


                  IconButton(

                    onPressed: () {

                      Navigator.pop(context);

                    },


                    icon: const Icon(

                      Icons.arrow_back,

                      color: Colors.blue,

                      size: 30,

                    ),

                  ),



                  const Expanded(

                    child: Text(

                      "Ubah Password",


                      textAlign:
                          TextAlign.center,


                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                  ),



                  const SizedBox(

                    width: 48,

                  ),



                ],

              ),



              const SizedBox(

                height: 20,

              ),




              Expanded(

                child: ListView(

                  children: [


                    inputPassword(

                      "Password Sekarang",

                      oldPasswordController,

                    ),



                    const SizedBox(

                      height: 16,

                    ),




                    inputPassword(

                      "Password Baru",

                      newPasswordController,

                    ),



                    const SizedBox(

                      height: 16,

                    ),




                    inputPassword(

                      "Konfirmasi Password Baru",

                      confirmPasswordController,

                    ),




                    const SizedBox(

                      height: 24,

                    ),




                    Container(

                      padding:
                          const EdgeInsets.all(14),


                      decoration:
                          BoxDecoration(

                        color:
                            Colors.blue.shade50,


                        borderRadius:
                            BorderRadius.circular(12),

                      ),



                      child:
                          const Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,


                        children: [


                          Text(

                            "Aturan Keamanan",

                            style:
                                TextStyle(

                              fontWeight:
                                  FontWeight.bold,

                            ),

                          ),



                          SizedBox(

                            height: 8,

                          ),




                          Text(

                            "• Minimal 8 karakter\n"
                            "• Gunakan kombinasi huruf dan angka\n"
                            "• Hindari menggunakan password lama",

                          ),


                        ],

                      ),

                    ),




                    const SizedBox(

                      height: 24,

                    ),




                    SizedBox(

                      height: 48,


                      child: ElevatedButton(


                        onPressed:
                            loading
                                ? null
                                : ubahPassword,



                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.blue,


                          foregroundColor:
                              Colors.white,


                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(12),

                          ),

                        ),



                        child:
                            loading


                                ? const SizedBox(

                                    height: 22,

                                    width: 22,

                                    child:
                                        CircularProgressIndicator(

                                      color:
                                          Colors.white,

                                      strokeWidth:
                                          2,

                                    ),

                                  )



                                : const Text(

                                    "Simpan Password",

                                  ),


                      ),

                    ),



                  ],

                ),

              ),


            ],

          ),

        ),

      ),

    );

  }

}
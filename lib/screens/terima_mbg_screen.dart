import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../models/distribution_model.dart';

import '../services/distribution_service.dart';
import '../services/confirmation_service.dart';



class RiwayatMBGScreen extends StatefulWidget {

  const RiwayatMBGScreen({
    super.key,
  });


  @override
  State<RiwayatMBGScreen> createState() =>
      _RiwayatMBGScreenState();

}





class _RiwayatMBGScreenState
    extends State<RiwayatMBGScreen> {



  final ConfirmationService _confirmationService =
      ConfirmationService();



  final DistributionService _distributionService =
      DistributionService();




  DistributionModel? distribution;




  bool loading = true;


  bool _isSubmitting = false;



  bool alreadySubmitted = false;



  bool noDistribution = false;




  double _rating = 0;



  final TextEditingController _kritikController =
      TextEditingController();



  File? _photo;



  double? latitude;


  double? longitude;






  @override
  void initState() {

    super.initState();

    _loadDistribution();

  }






  @override
  void dispose() {

    _kritikController.dispose();

    super.dispose();

  }








  Future<void> _loadDistribution() async {

    try {


      final result =
          await _distributionService.getToday();




      if(!mounted) return;





      if(result == null){


        setState(() {

          noDistribution = true;

          loading = false;

        });


        return;

      }





      final confirmation =
          await _confirmationService
              .getLatestConfirmation();





      if(!mounted) return;






      setState(() {


        distribution = result;



        alreadySubmitted =
            confirmation != null &&
            confirmation.distributionId == result.id;



        loading = false;



      });




    }catch(e){



      if(!mounted)return;




      final error =
          e.toString().toLowerCase();




      if(
        error.contains("404") ||
        error.contains("not found") ||
        error.contains("tidak ada") ||
        error.contains("belum")
      ){



        setState(() {

          noDistribution = true;

          loading = false;

        });



        return;

      }






      setState(() {

        loading = false;

      });





      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

        ),

      );


    }


  }









  Widget _statusCard({

    required IconData icon,

    required Color color,

    required String title,

    required String message,

  }){


    return Container(

      margin:
      const EdgeInsets.all(16),



      padding:
      const EdgeInsets.all(20),




      decoration:

      BoxDecoration(

        color:
        color.withOpacity(0.08),



        borderRadius:
        BorderRadius.circular(18),



        border:

        Border.all(

          color:
          color.withOpacity(0.3),

        ),


      ),




      child:

      Column(

        children: [



          Icon(

            icon,

            size:60,

            color:color,

          ),





          const SizedBox(
            height:16,
          ),






          Text(

            title,


            textAlign:
            TextAlign.center,


            style:

            const TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,

            ),


          ),





          const SizedBox(
            height:10,
          ),





          Text(

            message,


            textAlign:
            TextAlign.center,



            style:

            TextStyle(

              color:
              Colors.grey.shade700,

              fontSize:14,

            ),


          ),





          const SizedBox(
            height:20,
          ),





          SizedBox(

            width:
            double.infinity,



            child:

            ElevatedButton(

              onPressed:(){

                Navigator.pop(context);

              },



              style:

              ElevatedButton.styleFrom(

                backgroundColor:
                color,

                foregroundColor:
                Colors.white,


                shape:

                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(12),

                ),


              ),




              child:

              const Text(
                "Kembali",
              ),


            ),


          ),



        ],


      ),


    );


  }









  String get tanggalPenerimaan {


    return DateTime.now()
        .toString()
        .substring(0,10);


  }

  Widget _buildStar(int index) {

    return IconButton(

      onPressed: () {

        setState(() {

          _rating = index.toDouble();

        });

      },


      icon: Icon(

        Icons.star,

        size:32,


        color:

        _rating >= index

            ? Colors.orange

            : Colors.grey,

      ),

    );

  }







  Future<void> _pickImage() async {

    try {


      final picker =
          ImagePicker();




      final image =
          await picker.pickImage(

        source:
        ImageSource.camera,

        imageQuality:
        95,

      );




      if(image == null) return;






      final gps =
          await Geolocator.isLocationServiceEnabled();




      if(!gps){


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text(
              "Aktifkan GPS terlebih dahulu",
            ),

          ),

        );


        return;

      }







      LocationPermission permission =
          await Geolocator.checkPermission();




      if(permission ==
          LocationPermission.denied){


        permission =
            await Geolocator.requestPermission();


      }






      if(permission ==
          LocationPermission.deniedForever){


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text(
              "Izinkan akses lokasi terlebih dahulu",
            ),

          ),

        );


        return;

      }








      final posisi =
          await Geolocator.getCurrentPosition(

        desiredAccuracy:
        LocationAccuracy.high,

      );





      latitude =
          posisi.latitude;



      longitude =
          posisi.longitude;







      final bytes =
          await File(image.path)
              .readAsBytes();





      img.Image? foto =
          img.decodeImage(bytes);





      if(foto == null) return;





      foto =
          img.bakeOrientation(foto);







      final waktu =
          DateTime.now()
              .toString()
              .substring(0,19);






      img.fillRect(

        foto,

        x1:0,

        y1:
        foto.height - 300,

        x2:
        foto.width,

        y2:
        foto.height,

        color:
        img.ColorRgba8(
          0,
          0,
          0,
          170,
        ),

      );








      img.drawString(

        foto,


        "SPPM MBG\n"
        "$waktu\n"
        "Lat:$latitude\n"
        "Lng:$longitude",




        font:
        img.arial48,



        x:40,



        y:
        foto.height - 230,



        color:

        img.ColorRgb8(
          255,
          255,
          0,
        ),


      );








      final directory =
          await getTemporaryDirectory();





      final file =
          File(

        "${directory.path}/mbg_${DateTime.now().millisecondsSinceEpoch}.jpg",

      );





      await file.writeAsBytes(

        img.encodeJpg(

          foto,

          quality:95,

        ),

      );






      if(!mounted)return;





      setState(() {

        _photo = file;

      });




    }catch(e){



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

        ),

      );


    }


  }








  void _deletePhoto(){


    setState(() {

      _photo = null;

    });


  }









  Future<void> _submit() async {



    if(alreadySubmitted){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Anda sudah mengisi penilaian hari ini",
          ),

        ),

      );


      return;

    }






    if(distribution == null){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Tidak ada penerimaan MBG hari ini",
          ),

        ),

      );


      return;

    }







    if(_rating == 0){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Silakan beri rating terlebih dahulu",
          ),

        ),

      );


      return;

    }






    if(_photo == null){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Silakan ambil foto bukti",
          ),

        ),

      );


      return;

    }







    try{


      setState(() {

        _isSubmitting = true;

      });








      await _confirmationService.sendConfirmation(


        distributionId:
        distribution!.id,



        rating:
        _rating.toInt(),



        kritik:
        _kritikController.text,



        photo:
        _photo!,



        latitude:
        latitude ?? 0,



        longitude:
        longitude ?? 0,

      );







      if(!mounted)return;







      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Penilaian berhasil dikirim",
          ),

        ),

      );






      Navigator.pop(context);






    }catch(e){



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

        ),

      );



    }finally{



      if(mounted){


        setState(() {

          _isSubmitting = false;

        });


      }


    }


  }

    @override
  Widget build(BuildContext context) {


    if(loading){


      return const Scaffold(

        body:

        Center(

          child:
          CircularProgressIndicator(),

        ),

      );

    }






    if(noDistribution){


      return Scaffold(

        backgroundColor:
        Colors.white,


        body:

        SafeArea(

          child:

          Column(

            children: [


              const SizedBox(
                height:40,
              ),



              _statusCard(

                icon:
                Icons.restaurant_outlined,


                color:
                Colors.orange,



                title:
                "Belum Ada Penerimaan MBG",



                message:
                "Belum ada distribusi MBG hari ini. Penilaian hanya dapat dilakukan setelah menerima makanan.",

              ),


            ],


          ),

        ),

      );


    }







    if(alreadySubmitted){



      return Scaffold(

        backgroundColor:
        Colors.white,


        body:

        SafeArea(

          child:

          Column(

            children: [


              const SizedBox(
                height:40,
              ),



              _statusCard(

                icon:
                Icons.check_circle_outline,



                color:
                Colors.green,



                title:
                "Penilaian Sudah Dikirim",



                message:
                "Anda sudah memberikan penilaian MBG hari ini. Penilaian berikutnya dapat dilakukan setelah penerimaan berikutnya.",


              ),



            ],


          ),


        ),


      );


    }






    return Scaffold(


      backgroundColor:
      Colors.white,



      body:

      SafeArea(


        child:

        ListView(


          padding:
          const EdgeInsets.all(16),



          children: [





            Row(


              children: [



                IconButton(

                  onPressed:(){

                    Navigator.pop(context);

                  },


                  icon:

                  const Icon(

                    Icons.arrow_back,

                    color:
                    Colors.blue,

                    size:30,

                  ),

                ),





                const Expanded(

                  child:

                  Text(

                    "Penilaian MBG",

                    textAlign:
                    TextAlign.center,


                    style:

                    TextStyle(

                      fontSize:18,

                      fontWeight:
                      FontWeight.bold,

                    ),


                  ),


                ),





                const SizedBox(
                  width:48,
                ),



              ],


            ),






            const SizedBox(
              height:25,
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



                border:

                Border.all(

                  color:
                  Colors.blue.shade200,

                ),


              ),




              child:

              Row(

                children: [



                  const Icon(

                    Icons.calendar_month,

                    color:
                    Colors.blue,

                  ),



                  const SizedBox(
                    width:10,
                  ),





                  Text(

                    "Tanggal Penerimaan: $tanggalPenerimaan",



                    style:

                    const TextStyle(

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                ],


              ),


            ),







            const SizedBox(
              height:20,
            ),







            Container(

              padding:
              const EdgeInsets.all(14),


              decoration:

              BoxDecoration(

                borderRadius:
                BorderRadius.circular(12),


                border:

                Border.all(

                  color:
                  Colors.blue.shade200,

                ),

              ),



              child:

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [



                  const Text(

                    "Rating Penerimaan",


                    style:

                    TextStyle(

                      fontSize:16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),




                  Center(

                    child:

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.center,


                      children:

                      List.generate(

                        5,

                        (index)=>

                            _buildStar(index+1),


                      ),


                    ),


                  ),


                ],


              ),


            ),






            const SizedBox(
              height:20,
            ),







            Container(

              padding:
              const EdgeInsets.all(14),



              decoration:

              BoxDecoration(

                borderRadius:
                BorderRadius.circular(12),


                border:

                Border.all(

                  color:
                  Colors.blue.shade200,

                ),

              ),




              child:

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [



                  const Text(

                    "Kritik & Saran",


                    style:

                    TextStyle(

                      fontSize:16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),




                  const SizedBox(
                    height:10,
                  ),




                  TextField(

                    controller:
                    _kritikController,


                    maxLines:
                    4,



                    decoration:

                    InputDecoration(

                      hintText:
                      "Tulis kritik dan saran...",


                      filled:
                      true,


                      fillColor:
                      Colors.grey.shade100,



                      border:

                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(12),


                        borderSide:
                        BorderSide.none,

                      ),

                    ),


                  ),



                ],


              ),


            ),







            const SizedBox(
              height:20,
            ),






            Container(

              padding:
              const EdgeInsets.all(14),


              decoration:

              BoxDecoration(

                borderRadius:
                BorderRadius.circular(12),


                border:

                Border.all(

                  color:
                  Colors.blue.shade200,

                ),

              ),



              child:

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [



                  const Text(

                    "Bukti Foto",


                    style:

                    TextStyle(

                      fontSize:16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),





                  const SizedBox(
                    height:10,
                  ),





                  GestureDetector(

                    onTap:
                    _pickImage,



                    child:

                    Container(

                      height:300,


                      width:
                      double.infinity,



                      decoration:

                      BoxDecoration(

                        color:
                        Colors.grey.shade100,


                        borderRadius:
                        BorderRadius.circular(16),

                      ),




                      child:

                      _photo == null

                          ?

                      const Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,


                        children: [



                          Icon(

                            Icons.camera_alt,

                            size:60,

                            color:
                            Colors.blue,

                          ),




                          SizedBox(
                            height:12,
                          ),




                          Text(
                            "Ambil foto bukti",
                          ),



                        ],


                      )


                          :



                      GestureDetector(

                        onTap:(){

                          Navigator.push(

                            context,


                            MaterialPageRoute(

                              builder:(_)=>

                                  FullImagePreview(

                                    image:
                                    _photo!,

                                  ),


                            ),


                          );


                        },



                        child:

                        ClipRRect(

                          borderRadius:
                          BorderRadius.circular(16),



                          child:

                          Image.file(

                            _photo!,


                            fit:
                            BoxFit.cover,


                            width:
                            double.infinity,


                          ),


                        ),


                      ),


                    ),


                  ),





                  if(_photo != null)

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.center,


                      children: [



                        ElevatedButton.icon(

                          onPressed:
                          _pickImage,


                          icon:

                          const Icon(
                            Icons.camera_alt,
                          ),



                          label:

                          const Text(
                            "Retake",
                          ),


                        ),




                        const SizedBox(
                          width:10,
                        ),





                        ElevatedButton.icon(

                          style:

                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.red,

                          ),



                          onPressed:
                          _deletePhoto,


                          icon:

                          const Icon(
                            Icons.delete,
                          ),



                          label:

                          const Text(
                            "Hapus",
                          ),



                        ),



                      ],


                    ),



                ],


              ),


            ),






            const SizedBox(
              height:25,
            ),







            SizedBox(

              height:50,


              child:

              ElevatedButton(

                onPressed:

                _isSubmitting

                    ? null

                    : _submit,



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

                _isSubmitting


                    ?

                const CircularProgressIndicator(

                  color:
                  Colors.white,

                )


                    :

                const Text(

                  "Simpan",

                  style:

                  TextStyle(

                    fontSize:16,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



              ),


            ),



          ],


        ),


      ),


    );


  }

}





class FullImagePreview extends StatelessWidget {


  final File image;



  const FullImagePreview({

    super.key,

    required this.image,

  });




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      Colors.black,



      appBar:

      AppBar(

        backgroundColor:
        Colors.black,


        iconTheme:

        const IconThemeData(

          color:
          Colors.white,

        ),

      ),



      body:

      Center(

        child:

        InteractiveViewer(

          minScale:
          0.5,


          maxScale:
          5,



          child:

          Image.file(

            image,

            fit:
            BoxFit.contain,

          ),


        ),


      ),


    );


  }


}
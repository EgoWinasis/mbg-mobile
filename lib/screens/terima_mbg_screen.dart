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



  double _rating = 0;



  final TextEditingController _kritikController =
      TextEditingController();



  File? _photo;



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


      if (!mounted) return;


      setState(() {

        distribution = result;

        loading = false;

      });


    } catch(e) {


      if (!mounted) return;


      setState(() {

        loading = false;

      });


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),

      );


    }

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

          _rating =
              index.toDouble();

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

        source: ImageSource.camera,

        imageQuality:95,

      );



      if(image == null) return;





      bool gps =
          await Geolocator
              .isLocationServiceEnabled();



      if(!gps){


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
            Text("Aktifkan GPS terlebih dahulu"),
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


        return;

      }





      Position posisi =
          await Geolocator.getCurrentPosition(

        desiredAccuracy:
        LocationAccuracy.high,

      );





      final bytes =
          await File(image.path)
              .readAsBytes();



      img.Image? foto =
          img.decodeImage(bytes);



      if(foto == null) return;



      foto =
          img.bakeOrientation(foto);





      String waktu =
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
            "Lat:${posisi.latitude}\n"
            "Lng:${posisi.longitude}",


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




      if(!mounted) return;


      setState(() {

        _photo=file;

      });



    }catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text(e.toString()),
        ),

      );


    }


  }





  void _deletePhoto(){


    setState(() {

      _photo=null;

    });


  }





  Future<void> _submit() async {


    if(_rating==0){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Silakan beri rating"),
        ),

      );


      return;

    }




    if(_photo==null){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Silakan ambil foto bukti"),
        ),

      );


      return;

    }




    if(distribution==null){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Distribusi belum tersedia"),
        ),

      );


      return;

    }




    try{


      setState(() {

        _isSubmitting=true;

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


        latitude:0,


        longitude:0,

      );




      if(!mounted)return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Verifikasi berhasil dikirim"),
        ),

      );



      Navigator.pop(context);



    }catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text(e.toString()),
        ),

      );


    }finally{


      if(mounted){

        setState(() {

          _isSubmitting=false;

        });

      }


    }


  }


    @override
  Widget build(BuildContext context) {


    if (loading) {

      return const Scaffold(

        body: Center(

          child:
          CircularProgressIndicator(),

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

                  onPressed: () {

                    Navigator.pop(context);

                  },


                  icon:

                  const Icon(

                    Icons.arrow_back,

                    color: Colors.blue,

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
                    color: Colors.blue,
                  ),


                  const SizedBox(
                    width:10,
                  ),



                  Text(

                    "Tanggal Penerimaan: "
                        "$tanggalPenerimaan",



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


                    maxLines:4,



                    decoration:

                    InputDecoration(

                      hintText:
                      "Tulis kritik dan saran...",


                      filled:true,


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

                            color:Colors.blue,

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

                        onTap: () {


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



                            frameBuilder:

                                (
                                context,
                                child,
                                frame,
                                sync,
                                )

                            {


                              if(frame != null ||
                                  sync){

                                return child;

                              }



                              return const Center(

                                child:

                                CircularProgressIndicator(),

                              );


                            },

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


                  disabledBackgroundColor:
                  Colors.blue.shade300,


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

                const SizedBox(

                  width:25,

                  height:25,


                  child:

                  CircularProgressIndicator(

                    color:
                    Colors.white,


                    strokeWidth:3,

                  ),

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

          minScale:0.5,

          maxScale:5,



          child:

          Image.file(

            image,


            fit:
            BoxFit.contain,



            frameBuilder:

                (
                context,
                child,
                frame,
                sync,
                )

            {


              if(frame != null ||
                  sync){

                return child;

              }



              return const Center(

                child:

                CircularProgressIndicator(

                  color:
                  Colors.white,

                ),

              );


            },

          ),


        ),

      ),


    );


  }


}
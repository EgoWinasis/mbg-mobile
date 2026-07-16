import 'package:flutter/material.dart';

import '../models/mbg_menu_model.dart';
import '../services/mbg_menu_service.dart';
import '../core/config/api_config.dart';

import 'main_screen.dart';



class MenuScreen extends StatefulWidget {

  const MenuScreen({
    super.key,
  });


  @override
  State<MenuScreen> createState() =>
      _MenuScreenState();

}

class FullScreenImage extends StatelessWidget {


  final String imageUrl;



  const FullScreenImage({

    super.key,

    required this.imageUrl,

  });





  @override
  Widget build(BuildContext context){


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

          minScale:0.8,

          maxScale:4,


          child:

          Image.network(

            imageUrl,


            fit:
            BoxFit.contain,


            errorBuilder:

            (context,error,stack){


              return const Icon(

                Icons.image_not_supported,

                color:
                Colors.white,

                size:60,

              );


            },


          ),

        ),

      ),

    );


  }


}






class _MenuScreenState extends State<MenuScreen> {


  final MbgMenuService service =
      MbgMenuService();



  late Future<MbgMenuModel> futureMenu;



  DateTime selectedDate =
      DateTime.now();






  @override
  void initState(){

    super.initState();

    loadMenu();

  }






  void loadMenu(){

    setState(() {

      futureMenu =
          service.getMenu(

            date:
            formatDate(selectedDate),

          );

    });

  }






  String formatDate(DateTime date){

    return "${date.year}-"
        "${date.month.toString().padLeft(2,'0')}-"
        "${date.day.toString().padLeft(2,'0')}";

  }






  String formatIndonesia(DateTime date){

    const bulan=[

      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"

    ];


    return "${date.day} ${bulan[date.month-1]} ${date.year}";

  }







  String hari(DateTime date){

    const namaHari=[

      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu"

    ];


    return namaHari[date.weekday-1];

  }







  @override
  Widget build(BuildContext context){


    return Scaffold(

      backgroundColor:
      Colors.white,



      body:

      CustomScrollView(

        slivers:[



          SliverAppBar(

            backgroundColor:
            Colors.white,


            elevation:
            0,


            leading:

            IconButton(

              icon:

              const Icon(

                Icons.arrow_back,

                color:
                Colors.blue,

              ),


              onPressed:(){


                if(Navigator.canPop(context)){


                  Navigator.pop(context);


                }else{


                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(

                      builder:
                      (_)=>
                      const MainScreen(),

                    ),

                  );


                }


              },

            ),




            title:

            const Text(

              "Menu MBG",

              style:

              TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:18,

              ),

            ),




            centerTitle:true,


          ),




          SliverToBoxAdapter(

            child:

            Padding(

              padding:
              const EdgeInsets.all(16),


              child:

              Column(

                children:[



                  GestureDetector(

                    onTap:() async{


                      final picked =
                      await showDatePicker(

                        context:
                        context,


                        initialDate:
                        selectedDate,


                        firstDate:
                        DateTime(2020),


                        lastDate:
                        DateTime(2030),


                      );



                      if(picked != null){


                        setState(() {

                          selectedDate =
                              picked;

                        });


                        loadMenu();


                      }


                    },



                    child:

                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal:12,

                        vertical:8,

                      ),


                      decoration:

                      BoxDecoration(

                        color:
                        Colors.blue.shade50,


                        borderRadius:
                        BorderRadius.circular(20),


                      ),


                      child:

                      Row(

                        mainAxisSize:
                        MainAxisSize.min,


                        children:[



                          const Icon(

                            Icons.calendar_month,

                            color:
                            Colors.blue,

                            size:16,

                          ),



                          const SizedBox(
                            width:6,
                          ),



                          Text(

                            "${hari(selectedDate)}, "
                            "${formatIndonesia(selectedDate)}",


                            style:

                            const TextStyle(

                              color:
                              Colors.blue,


                              fontWeight:
                              FontWeight.bold,


                              fontSize:12,

                            ),

                          ),



                        ],

                      ),

                    ),

                  ),





                  const SizedBox(
                    height:20,
                  ),

                                    FutureBuilder<MbgMenuModel>(

                    future:
                    futureMenu,


                    builder:(context,snapshot){



                      if(snapshot.connectionState ==
                          ConnectionState.waiting){


                        return const Padding(

                          padding:
                          EdgeInsets.all(40),


                          child:

                          CircularProgressIndicator(),

                        );


                      }






                      if(snapshot.hasError){


                        return Card(

                          elevation:2,


                          child:

                          Padding(

                            padding:
                            const EdgeInsets.all(20),


                            child:

                            Column(

                              children:[



                                const Icon(

                                  Icons.restaurant_menu,

                                  size:60,

                                  color:
                                  Colors.blue,

                                ),




                                const SizedBox(
                                  height:15,
                                ),




                                const Text(

                                  "Menu belum tersedia",

                                  style:

                                  TextStyle(

                                    fontSize:18,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

                                ),




                                const SizedBox(
                                  height:8,
                                ),




                                Text(

                                  snapshot.error
                                      .toString()
                                      .replaceFirst(
                                      "Exception: ",
                                      ""
                                  ),


                                  textAlign:
                                  TextAlign.center,


                                ),





                                const SizedBox(
                                  height:15,
                                ),




                                ElevatedButton.icon(

                                  onPressed:
                                  loadMenu,


                                  icon:

                                  const Icon(
                                    Icons.refresh,
                                  ),



                                  label:

                                  const Text(
                                    "Coba Lagi",
                                  ),


                                ),




                              ],

                            ),

                          ),

                        );


                      }






                      final menu =
                      snapshot.data!;




                      return Column(

                        children:[




                          Text(

                            menu.title,


                            textAlign:
                            TextAlign.center,


                            style:

                            const TextStyle(

                              color:
                              Colors.blue,


                              fontSize:18,


                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),




                          Text(

                            "${hari(selectedDate)}, "
                            "${formatIndonesia(selectedDate)}",


                            style:

                            const TextStyle(

                              fontSize:16,

                            ),


                          ),





                          const SizedBox(
                            height:15,
                          ),






                          if(menu.image != null)

                            ClipRRect(

                              borderRadius:
                              BorderRadius.circular(15),



                              child:

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                        imageUrl: ApiConfig.imageUrl(
                                          menu.image!,
                                        ),
                                      ),
                                    ),
                                  );
                                },

                                child: Image.network(
                                  ApiConfig.imageUrl(menu.image!),

                                  height: 170,

                                  width: double.infinity,

                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stack) {
                                    return Container(
                                      height: 170,

                                      color: Colors.grey.shade200,

                                      child: const Icon(
                                        Icons.image_not_supported,

                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),

                            ),






                          const SizedBox(
                            height:15,
                          ),






                          Row(

                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,



                            children:

                            menu.items.map((item){



                              return MenuItem(

                                emoji:
                                item.icon,


                                text:
                                item.name,

                              );


                            }).toList(),



                          ),





                          const SizedBox(
                            height:20,
                          ),





                          Card(

                            elevation:2,


                            child:

                            Padding(

                              padding:
                              const EdgeInsets.all(15),


                              child:

                              Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,


                                children:[



                                  const Text(

                                    "Informasi Gizi",

                                    style:

                                    TextStyle(

                                      fontSize:18,

                                      fontWeight:
                                      FontWeight.bold,

                                    ),

                                  ),





                                  const SizedBox(
                                    height:15,
                                  ),





                                  Row(

                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,


                                    children:

                                    menu.nutritions.map((g){


                                      return Gizi(

                                        icon:
                                        g.icon,


                                        angka:
                                        g.value,


                                        nama:
                                        g.name,


                                      );


                                    }).toList(),



                                  ),



                                ],


                              ),


                            ),


                          ),






                          const SizedBox(
                            height:15,
                          ),
                                                    Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    "Manfaat Menu Ini",

                                    style: TextStyle(
                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  ...menu.benefits.map((item) {
                                    return manfaat(item.description);
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Icon(
                                  Icons.lightbulb,

                                  color: Colors.amber,

                                  size: 20,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    menu.description ??
                                        "Menu ini telah disusun sesuai kebutuhan gizi ibu hamil dan balita.",

                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget manfaat(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Icon(Icons.check_circle, color: Colors.blue, size: 18),

        const SizedBox(width: 8),

        Expanded(child: Text(text)),
      ],
    ),
  );
}

class MenuItem extends StatelessWidget {
  final String emoji;

  final String text;

  const MenuItem({super.key, required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),

        Text(
          text,

          textAlign: TextAlign.center,

          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class Gizi extends StatelessWidget {
  final String icon;

  final String angka;

  final String nama;

  const Gizi({
    super.key,

    required this.icon,

    required this.angka,

    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),

        Text(
          angka,

          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),

        Text(nama, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

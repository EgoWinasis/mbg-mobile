import 'package:flutter/material.dart';
import 'package:mbg_app/screens/main_screen.dart';

import '../models/category_model.dart';
import '../models/article_model.dart';

import '../services/category_service.dart';
import '../services/article_service.dart';

import 'artikel_detail_screen.dart';



class EdukasiScreen extends StatefulWidget {


  const EdukasiScreen({
    super.key,
  });



  @override
  State<EdukasiScreen> createState() =>
      _EdukasiScreenState();

}





class _EdukasiScreenState
    extends State<EdukasiScreen> {



  final CategoryService categoryService =
      CategoryService();



  final ArticleService articleService =
      ArticleService();




  late Future<List<CategoryModel>> categories;

  late Future<List<ArticleModel>> articles;




  int? selectedCategoryId;



  String keyword = "";




  final TextEditingController searchController =
      TextEditingController();





  @override
  void initState() {

    super.initState();



    categories =
        categoryService.getCategories();



    articles =
        articleService.getArticles();


  }





  @override
  void dispose(){

    searchController.dispose();

    super.dispose();

  }






  void loadArticles(){


    setState((){


      articles =
          articleService.getArticles(


            categoryId:
            selectedCategoryId,



            keyword:
            keyword,


          );



    });


  }






  Color hexToColor(String hex){


    hex =
        hex.replaceAll("#", "");



    if(hex.length == 6){

      hex =
      "FF$hex";

    }



    return Color(

      int.parse(

        hex,

        radix:16,

      ),

    );


  }





  IconData categoryIcon(String icon){


    switch(icon.toLowerCase()){


      case "mbg":

        return Icons.card_giftcard;



      case "gizi":

        return Icons.apple;



      case "kesehatan":

        return Icons.favorite;



      case "stunting":

        return Icons.child_friendly;



      default:

        return Icons.category;


    }


  }







  @override
  Widget build(BuildContext context) {



    return Scaffold(


      backgroundColor:
      Colors.white,



      body:

      SafeArea(


        child:

        SingleChildScrollView(


          padding:
          const EdgeInsets.all(16),



          child:

          Column(


            crossAxisAlignment:
            CrossAxisAlignment.start,



            children:[






              // HEADER


              Row(


                children:[



                  IconButton(


                    onPressed:(){



                      if(
                      Navigator.canPop(context)
                      ){


                        Navigator.pop(context);


                      }else{


                        Navigator.pushReplacement(

                          context,

                          MaterialPageRoute(

                            builder:(_)=>
                            const MainScreen(),

                          ),

                        );


                      }



                    },



                    icon:
                    const Icon(

                      Icons.arrow_back,

                      color:
                      Colors.blue,

                    ),


                  ),






                  const Expanded(


                    child:
                    Center(


                      child:
                      Text(

                        "Edukasi",


                        style:
                        TextStyle(


                          fontSize:
                          18,


                          fontWeight:
                          FontWeight.bold,


                        ),


                      ),


                    ),


                  ),





                  const SizedBox(
                    width:48,
                  ),



                ],


              ),





              const SizedBox(
                height:12,
              ),







              // SEARCH


              Container(


                height:
                45,



                decoration:
                BoxDecoration(


                  color:
                  Colors.grey.shade100,



                  borderRadius:
                  BorderRadius.circular(25),


                ),





                child:

                TextField(


                  controller:
                  searchController,



                  onChanged:(value){


                    keyword =
                        value;


                    loadArticles();


                  },




                  decoration:
                  const InputDecoration(



                    hintText:

                    "Cari artikel, topik, atau kata kunci...",



                    prefixIcon:

                    Icon(

                      Icons.search,

                      color:
                      Colors.grey,

                    ),




                    border:

                    InputBorder.none,


                  ),


                ),



              ),






              const SizedBox(
                height:20,
              ),







              // CATEGORY


              SizedBox(


                height:
                90,



                child:

                FutureBuilder<List<CategoryModel>>(



                  future:
                  categories,




                  builder:(context,snapshot){



                    if(snapshot.connectionState ==
                        ConnectionState.waiting){


                      return const Center(

                        child:
                        CircularProgressIndicator(),

                      );


                    }




                    final data =
                        snapshot.data ?? [];





                    return ListView.builder(



                      scrollDirection:
                      Axis.horizontal,



                      itemCount:
                      data.length + 1,



                      itemBuilder:(context,index){



                        if(index == 0){



                          return GestureDetector(


                            onTap:(){


                              selectedCategoryId =
                              null;


                              loadArticles();


                            },



                            child:

                            const CategoryItem(


                              icon:
                              Icons.grid_view,


                              title:
                              "Semua",


                              color:
                              Colors.green,


                            ),



                          );


                        }






                        final category =
                            data[index-1];




                        return GestureDetector(


                          onTap:(){



                            selectedCategoryId =
                                category.id;



                            loadArticles();


                          },



                          child:

                          CategoryItem(


                            icon:
                            categoryIcon(
                              category.icon,
                            ),



                            title:
                            category.name,



                            color:
                            hexToColor(
                              category.color,
                            ),



                          ),



                        );



                      },



                    );



                  },


                ),


              ),




              const SizedBox(
                height:15,
              ),




              const Text(


                "Artikel Terbaru",



                style:

                TextStyle(


                  fontSize:
                  16,


                  fontWeight:
                  FontWeight.bold,


                ),



              ),




              const SizedBox(
                height:12,
              ),
                            // ARTICLE LIST
              FutureBuilder<List<ArticleModel>>(
                future: articles,

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final data = snapshot.data ?? [];

                  if (data.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),

                        child: Text("Artikel tidak ditemukan"),
                      ),
                    );
                  }

                  return Column(
                    children: data.map((article) {
                      return ArticleCard(
                        image: article.thumbnail,

                        title: article.title,

                        summary: article.summary,

                        tag: article.categoryName,

                        time: "${article.readingTime} min baca",

                        color: hexToColor(article.categoryColor),

                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  ArtikelDetailScreen(slug: article.slug),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                height: 45,

                child: OutlinedButton(
                  onPressed: () {
                    // jika nanti pagination
                  },

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text(
                    "Lihat Semua Artikel",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================
// CATEGORY ITEM
// ==========================

class CategoryItem extends StatelessWidget {
  final IconData icon;

  final String title;

  final Color color;

  const CategoryItem({
    super.key,

    required this.icon,

    required this.title,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,

      margin: const EdgeInsets.only(right: 12),

      child: Column(
        children: [
          Container(
            width: 50,

            height: 50,

            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),

              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 6),

          Text(
            title,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ==========================
// ARTICLE CARD
// ==========================

class ArticleCard extends StatelessWidget {
  final String image;

  final String title;

  final String summary;

  final String tag;

  final String time;

  final Color color;

  final VoidCallback onTap;

  const ArticleCard({
    super.key,

    required this.image,

    required this.title,

    required this.summary,

    required this.tag,

    required this.time,

    required this.color,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(15),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(8),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

          border: Border.all(color: Colors.grey.withValues(alpha: .15)),
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                image,

                width: 100,

                height: 95,

                fit: BoxFit.cover,

                errorBuilder: (context, error, stack) {
                  return Container(
                    width: 100,

                    height: 95,

                    color: Colors.grey.shade200,

                    child: const Icon(Icons.image),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 14,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    summary,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,

                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .12),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          tag,

                          style: TextStyle(fontSize: 10, color: color),
                        ),
                      ),

                      Text(
                        time,

                        style: const TextStyle(
                          fontSize: 11,

                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

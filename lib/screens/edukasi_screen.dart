import 'package:flutter/material.dart';
import 'package:mbg_app/screens/main_screen.dart';
import 'artikel_detail_screen.dart';


class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  static const primaryGreen = Color(0xFF2E8B57);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [


              // HEADER
              Row(
                children: [

                  IconButton(
                   onPressed: () async {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                  ),


                  const Expanded(
                    child: Center(
                      child: Text(
                        'Edukasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),

                ],
              ),



              const SizedBox(height: 12),



              // SEARCH
              Container(
                height: 45,

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(25),
                ),

                child: const TextField(
                  decoration: InputDecoration(

                    hintText:
                        'Cari artikel, topik, atau kata kunci...',

                    hintStyle: TextStyle(
                      fontSize: 13,
                    ),

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),

                    border: InputBorder.none,

                    contentPadding:
                        EdgeInsets.only(top: 12),

                  ),
                ),
              ),



              const SizedBox(height: 20),



              // CATEGORY
              SizedBox(
                height: 90,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: const [

                    CategoryItem(
                      icon: Icons.grid_view,
                      title: 'Semua',
                      color: Colors.green,
                    ),

                    CategoryItem(
                      icon: Icons.child_friendly,
                      title: 'Stunting',
                      color: Colors.pink,
                    ),

                    CategoryItem(
                      icon: Icons.apple,
                      title: 'Gizi',
                      color: Colors.orange,
                    ),

                    CategoryItem(
                      icon: Icons.card_giftcard,
                      title: 'MBG',
                      color: Colors.blue,
                    ),

                    CategoryItem(
                      icon: Icons.more_horiz,
                      title: 'Lainnya',
                      color: Colors.purple,
                    ),

                  ],
                ),
              ),



              const SizedBox(height: 10),



              const Text(
                'Artikel Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),



              const SizedBox(height: 12),



              ArticleCard(
  image: 'assets/images/balita.png',
  title: 'Apa Itu Stunting dan Bagaimana Mencegahnya?',
  tag: 'Stunting',
  time: '5 min baca',
  color: Colors.purple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ArtikelDetailScreen(),
      ),
    );
  },
),

ArticleCard(
  image: 'assets/images/balita.png',
  title: 'Gizi Penting untuk Ibu Hamil Trimester 2',
  tag: 'Gizi Ibu Hamil',
  time: '6 min baca',
  color: Colors.blue,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ArtikelDetailScreen(),
      ),
    );
  },
),

ArticleCard(
  image: 'assets/images/balita.png',
  title: 'Mengenal Program Makan Bergizi Gratis (MBG)',
  tag: 'MBG',
  time: '4 min baca',
  color: Colors.green,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ArtikelDetailScreen(),
      ),
    );
  },
),

ArticleCard(
  image: 'assets/images/balita.png',
  title: 'MPASI Sehat untuk Tumbuh Kembang Optimal',
  tag: 'Gizi Balita',
  time: '5 min baca',
  color: Colors.pink,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ArtikelDetailScreen(),
      ),
    );
  },
),



              const SizedBox(height: 15),



              // BUTTON
              SizedBox(
  width: double.infinity,
  height: 45,

  child: OutlinedButton(
    onPressed: () {},

    style: ButtonStyle(
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (states) {
          return const BorderSide(
            color: Colors.blue,
          );
        },
      ),

      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),

      backgroundColor:
          WidgetStateProperty.resolveWith<Color?>(
        (states) {

          if (states.contains(WidgetState.pressed)) {
            return Colors.blue;
          }

          if (states.contains(WidgetState.hovered)) {
            return Colors.blue.withValues(alpha: 0.1);
          }

          return Colors.transparent;
        },
      ),

      foregroundColor:
          WidgetStateProperty.resolveWith<Color?>(
        (states) {

          if (states.contains(WidgetState.pressed)) {
            return Colors.white;
          }

          return Colors.blue;
        },
      ),
    ),

    child: const Text(
      'Lihat Semua Artikel',
      style: TextStyle(
        fontWeight: FontWeight.bold,
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




// =============================
// CATEGORY ITEM
// =============================

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

      width: 70,

      margin:
          const EdgeInsets.only(right: 12),

      child: Column(

        children: [

          Container(

            width: 50,
            height: 50,

            decoration: BoxDecoration(

              color:
                  color.withValues(alpha:0.15),

              shape:
                  BoxShape.circle,

            ),

            child: Icon(
              icon,
              color: color,
            ),

          ),


          const SizedBox(height: 6),


          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

        ],
      ),
    );
  }
}




// =============================
// ARTICLE CARD
// =============================

class ArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final String tag;
  final String time;
  final Color color;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.image,
    required this.title,
    required this.tag,
    required this.time,
    required this.color,
    this.onTap,
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
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.15),
          ),
        ),

        child: Row(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.asset(
                image,
                width: 100,
                height: 85,
                fit: BoxFit.cover,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color:
                              color.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: Text(
                          tag,

                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                          ),
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
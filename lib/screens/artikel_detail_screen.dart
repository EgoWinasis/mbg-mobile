import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/article_service.dart';

class ArtikelDetailScreen extends StatefulWidget {
  final String slug;

  const ArtikelDetailScreen({super.key, required this.slug});

  @override
  State<ArtikelDetailScreen> createState() => _ArtikelDetailScreenState();
}

class _ArtikelDetailScreenState extends State<ArtikelDetailScreen> {
  final ArticleService service = ArticleService();

  late Future<ArticleModel> futureArticle;

  @override
  void initState() {
    super.initState();

    futureArticle = service.getArticleDetail(widget.slug);
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");

    if (hex.length == 6) {
      hex = "FF$hex";
    }

    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: FutureBuilder<ArticleModel>(
        future: futureArticle,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }

          final article = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,

                pinned: true,

                backgroundColor: Colors.white,

                leading: Container(
                  margin: const EdgeInsets.all(8),

                  decoration: const BoxDecoration(
                    color: Colors.white,

                    shape: BoxShape.circle,
                  ),

                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    article.thumbnail,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stack) {
                      return Container(
                        color: Colors.grey.shade200,

                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // CATEGORY + TIME
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,

                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: hexToColor(
                                article.categoryColor,
                              ).withValues(alpha: .12),

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              article.categoryName,

                              style: TextStyle(
                                color: hexToColor(article.categoryColor),

                                fontSize: 12,

                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.schedule,

                            size: 18,

                            color: Colors.grey,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            "${article.readingTime} min baca",

                            style: const TextStyle(
                              color: Colors.grey,

                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        article.title,

                        style: const TextStyle(
                          fontSize: 24,

                          fontWeight: FontWeight.bold,

                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Dipublikasikan ${formatTanggalIndonesia(article.publishedAt)}",

                        style: const TextStyle(
                          color: Colors.grey,

                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: .06),

                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.blue),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                article.summary,

                                style: const TextStyle(
                                  fontSize: 13,

                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        article.content.replaceAll(RegExp(r'<[^>]*>'), ''),

                        style: const TextStyle(
                          fontSize: 15,

                          height: 1.9,

                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: .08),

                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "Terapkan informasi dari artikel ini untuk mendukung kesehatan dan tumbuh kembang yang optimal.",

                                style: const TextStyle(height: 1.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  String formatTanggalIndonesia(String? date) {
    if (date == null || date.isEmpty) {
      return "";
    }

    final parsedDate = DateTime.parse(date).toLocal();

    final bulan = [
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

      "Desember",
    ];

    return "${parsedDate.day} "
        "${bulan[parsedDate.month - 1]} "
        "${parsedDate.year}";
  }
}

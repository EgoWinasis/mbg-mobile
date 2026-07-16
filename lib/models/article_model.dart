import '../core/config/api_config.dart';

class ArticleModel {
  final int id;
  final int categoryId;

  final String title;
  final String slug;

  final String thumbnail;
  final String summary;
  final String content;

  final String status;

  final bool isFeatured;

  final int views;
  final int readingTime;

  final int? authorId;

  final String? publishedAt;

  // CATEGORY
  final String categoryName;
  final String categorySlug;
  final String categoryIcon;
  final String categoryColor;

  ArticleModel({
    required this.id,

    required this.categoryId,

    required this.title,

    required this.slug,

    required this.thumbnail,

    required this.summary,

    required this.content,

    required this.status,

    required this.isFeatured,

    required this.views,

    required this.readingTime,

    this.authorId,

    this.publishedAt,

    required this.categoryName,

    required this.categorySlug,

    required this.categoryIcon,

    required this.categoryColor,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] ?? {};

    return ArticleModel(
      id: json['id'] ?? 0,

      categoryId: json['category_id'] ?? 0,

      title: json['title'] ?? "",

      slug: json['slug'] ?? "",

      thumbnail: json['thumbnail'] != null
          ? ApiConfig.imageUrl(json['thumbnail'])
          : "",

      summary: json['summary'] ?? "",

      content: json['content'] ?? "",

      status: json['status'] ?? "",

      isFeatured: json['is_featured'] ?? false,

      views: json['views'] ?? 0,

      readingTime: json['reading_time'] ?? 0,

      authorId: json['author_id'],

      publishedAt: json['published_at'],

      // CATEGORY
      categoryName: category['name'] ?? "",

      categorySlug: category['slug'] ?? "",

      categoryIcon: category['icon'] ?? "category",

      categoryColor: category['color'] ?? "#9E9E9E",
    );
  }
}

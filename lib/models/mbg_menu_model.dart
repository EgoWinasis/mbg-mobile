class MbgMenuModel {
  final int id;

  final String date;

  final String title;

  final String? image;

  final String? description;

  final bool isActive;

  final List<MenuItemModel> items;

  final List<NutritionModel> nutritions;

  final List<BenefitModel> benefits;

  MbgMenuModel({
    required this.id,

    required this.date,

    required this.title,

    this.image,

    this.description,

    required this.isActive,

    required this.items,

    required this.nutritions,

    required this.benefits,
  });

  factory MbgMenuModel.fromJson(Map<String, dynamic> json) {
    return MbgMenuModel(
      id: json['id'] ?? 0,

      date: json['date'] ?? '',

      title: json['title'] ?? '',

      image: json['image'],

      description: json['description'],

      isActive: json['is_active'] ?? false,

      items: (json['items'] as List? ?? [])
          .map((e) => MenuItemModel.fromJson(e))
          .toList(),

      nutritions: (json['nutritions'] as List? ?? [])
          .map((e) => NutritionModel.fromJson(e))
          .toList(),

      benefits: (json['benefits'] as List? ?? [])
          .map((e) => BenefitModel.fromJson(e))
          .toList(),
    );
  }
}

class MenuItemModel {
  final String name;

  final String type;

  MenuItemModel({required this.name, required this.type});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      name: json['name'] ?? '',

      type: json['type'] ?? 'lainnya',
    );
  }

  String get icon {
    switch (type.toLowerCase()) {
      case "karbohidrat":
        return "🍚";

      case "protein":
        return "🍗";

      case "sayur":
      case "sayuran":
        return "🥬";

      case "buah":
        return "🍊";

      case "minuman":
        return "🥛";

      default:
        return "🍽️";
    }
  }
}

class NutritionModel {
  final String name;

  final String value;

  NutritionModel({required this.name, required this.value});

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(name: json['name'] ?? '', value: json['value'] ?? '');
  }

  String get icon {
    final text = name.toLowerCase();

    if (text.contains("kalori")) {
      return "🔥";
    }

    if (text.contains("protein")) {
      return "💪";
    }

    if (text.contains("karbohidrat")) {
      return "🌾";
    }

    if (text.contains("lemak")) {
      return "🧈";
    }

    if (text.contains("vitamin")) {
      return "🍊";
    }

    return "🥗";
  }
}

class BenefitModel {
  final String description;

  BenefitModel({required this.description});

  factory BenefitModel.fromJson(Map<String, dynamic> json) {
    return BenefitModel(description: json['description'] ?? '');
  }
}

class DashboardModel {
  final ProfileModel profile;
  final StatisticModel statistics;

  final List<ConfirmationModel> latestConfirmations;

  final ScheduleModel? nextSchedule;

  final MenuModel? todayMenu;

  final DistributionModel? todayDistribution;

  DashboardModel({
    required this.profile,
    required this.statistics,
    required this.latestConfirmations,
    this.nextSchedule,
    this.todayMenu,
    this.todayDistribution,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      profile: ProfileModel.fromJson(json['profile'] ?? {}),

      statistics: StatisticModel.fromJson(json['statistics'] ?? {}),

      latestConfirmations: ((json['latest_confirmations'] ?? []) as List)
          .map((e) => ConfirmationModel.fromJson(e))
          .toList(),

      nextSchedule: json['next_schedule'] != null
          ? ScheduleModel.fromJson(json['next_schedule'])
          : null,

      todayMenu: json['today_menu'] != null
          ? MenuModel.fromJson(json['today_menu'])
          : null,

      todayDistribution: json['today_distribution'] != null
          ? DistributionModel.fromJson(json['today_distribution'])
          : null,
    );
  }
}

// ==================================================
// PROFILE MODEL
// ==================================================

class ProfileModel {
  String name;

  final String? email;

  String? beneficiaryType;

  final String? childName;

  final String? childBirthDate;

  final String? photo;

  ProfileModel({
    required this.name,

    this.email,

    this.beneficiaryType,

    this.childName,

    this.childBirthDate,

    this.photo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name']?.toString() ?? '',

      email: json['email']?.toString(),

      beneficiaryType:
          json['beneficiary_type']?.toString() ?? json['type']?.toString(),

      childName: json['child_name']?.toString(),

      childBirthDate: json['child_birth_date']?.toString(),

      photo: json['photo']?.toString() ?? json['photo_url']?.toString(),
    );
  }
}

// ==================================================
// STATISTIC MODEL
// ==================================================

class StatisticModel {
  final int confirmationCount;

  final int? childAge;

  final PregnancyAgeModel? pregnancyAge;

  final int educationCount;

  StatisticModel({
    required this.confirmationCount,

    this.childAge,

    this.pregnancyAge,

    required this.educationCount,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) {
    return StatisticModel(
      confirmationCount:
          int.tryParse(json['confirmation_count']?.toString() ?? '0') ?? 0,

      childAge: json['child_age'] != null
          ? int.tryParse(json['child_age'].toString())
          : null,

      pregnancyAge: json['pregnancy_age'] != null
          ? PregnancyAgeModel.fromJson(json['pregnancy_age'])
          : null,

      educationCount:
          int.tryParse(json['education_count']?.toString() ?? '0') ?? 0,
    );
  }
}

// ==================================================
// PREGNANCY AGE MODEL
// ==================================================

class PregnancyAgeModel {
  final int weeks;

  final int months;

  PregnancyAgeModel({required this.weeks, required this.months});

  factory PregnancyAgeModel.fromJson(Map<String, dynamic> json) {
    return PregnancyAgeModel(
      weeks: int.tryParse(json['weeks']?.toString() ?? '0') ?? 0,

      months: int.tryParse(json['months']?.toString() ?? '0') ?? 0,
    );
  }
}

// ==================================================
// CONFIRMATION MODEL
// ==================================================

class ConfirmationModel {
  final int id;

  final String date;

  final String status;

  final int? rating;

  ConfirmationModel({
    required this.id,

    required this.date,

    required this.status,

    this.rating,
  });

  factory ConfirmationModel.fromJson(Map<String, dynamic> json) {
    return ConfirmationModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      date: json['date']?.toString() ?? json['received_at']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

      rating: json['rating'] != null
          ? int.tryParse(json['rating'].toString())
          : null,
    );
  }
}

// ==================================================
// SCHEDULE MODEL
// ==================================================

class ScheduleModel {
  final int id;

  final String title;

  final String date;

  final String startTime;

  final String endTime;

  final String location;

  final String address;

  final String? image;

  ScheduleModel({
    required this.id,

    required this.title,

    required this.date,

    required this.startTime,

    required this.endTime,

    required this.location,

    required this.address,

    this.image,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      title: json['title']?.toString() ?? '',

      date: json['date']?.toString() ?? '',

      startTime: json['start_time']?.toString() ?? '',

      endTime: json['end_time']?.toString() ?? '',

      location: json['location']?.toString() ?? '',

      address: json['address']?.toString() ?? '',

      image: json['image']?.toString() ?? json['image_url']?.toString(),
    );
  }
}

// ==================================================
// MENU MODEL
// ==================================================

class MenuModel {
  final int id;

  final String title;

  final String description;

  final String? image;

  final List<dynamic> items;

  final List<dynamic> nutrition;

  final List<dynamic> benefits;

  MenuModel({
    required this.id,

    required this.title,

    required this.description,

    this.image,

    required this.items,

    required this.nutrition,

    required this.benefits,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      title: json['title']?.toString() ?? '',

      description: json['description']?.toString() ?? '',

      image: json['image']?.toString() ?? json['image_url']?.toString(),

      items: json['items'] ?? [],

      nutrition: json['nutrition'] ?? json['nutritions'] ?? [],

      benefits: json['benefits'] ?? [],
    );
  }
}

// ==================================================
// DISTRIBUTION MODEL
// ==================================================

class DistributionModel {
  final String status;

  final int jumlahDikirim;

  final String? keterangan;

  DistributionModel({
    required this.status,

    required this.jumlahDikirim,

    this.keterangan,
  });

  factory DistributionModel.fromJson(Map<String, dynamic> json) {
    return DistributionModel(
      status: json['status']?.toString() ?? '',

      jumlahDikirim:
          int.tryParse(json['jumlah_dikirim']?.toString() ?? '0') ?? 0,

      keterangan: json['keterangan']?.toString(),
    );
  }
}

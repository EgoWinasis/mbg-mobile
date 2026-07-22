class ScheduleModel {
  final int id;

  final String type;

  final String date;

  final String title;

  final String? startTime;

  final String? endTime;

  final String? location;

  final String? address;

  final String? image;

  final String? description;

  ScheduleModel({
    required this.id,

    required this.type,

    required this.date,

    required this.title,

    this.startTime,

    this.endTime,

    this.location,

    this.address,

    this.image,

    this.description,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      type: json['type']?.toString().toLowerCase() ?? '',

      date: json['date']?.toString() ?? '',

      title: json['title']?.toString() ?? '',

      startTime: json['start_time']?.toString(),

      endTime: json['end_time']?.toString(),

      location: json['location']?.toString(),

      address: json['address']?.toString(),

      image: json['image']?.toString() ?? json['image_url']?.toString(),

      description: json['description']?.toString(),
    );
  }

  // =========================
  // KATEGORI UI
  // =========================

  String get kategori {
    switch (type) {
      case "mbg":
        return "Pembagian MBG";

      case "posyandu":
        return "Posyandu";

      default:
        return "Kegiatan";
    }
  }

  String get icon {
    if (type == "mbg") {
      return "🍱";
    }

    if (type == "posyandu") {
      return "🏥";
    }

    return "📅";
  }

  bool get isMbg {
    return type == "mbg";
  }

  bool get isPosyandu {
    return type == "posyandu";
  }

  // =========================
  // FORMAT TANGGAL
  // =========================

  DateTime get dateObject {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get tanggal {
    return dateObject.day.toString();
  }

  String get bulan {
    const list = [
      "JAN",

      "FEB",

      "MAR",

      "APR",

      "MEI",

      "JUN",

      "JUL",

      "AGU",

      "SEP",

      "OKT",

      "NOV",

      "DES",
    ];

    return list[dateObject.month - 1];
  }

  String get tahun {
    return dateObject.year.toString();
  }

  // =========================
  // STATUS JADWAL
  // =========================

  bool get isExpired {
    final now = DateTime.now();

    final scheduleDate = DateTime(
      dateObject.year,

      dateObject.month,

      dateObject.day,
    );

    final today = DateTime(now.year, now.month, now.day);

    return scheduleDate.isBefore(today);
  }

  String get status {
    if (isExpired) {
      return "Sudah selesai";
    }

    return "Akan datang";
  }
}

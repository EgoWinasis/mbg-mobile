import 'schedule_model.dart';

class DistributionModel {
  final int id;

  final int? scheduleId;

  final int? menuId;

  final int jumlahDikirim;

  final String? keterangan;

  final String? status;

  final ScheduleModel? schedule;

  DistributionModel({
    required this.id,

    this.scheduleId,

    this.menuId,

    required this.jumlahDikirim,

    this.keterangan,

    this.status,

    this.schedule,
  });

  factory DistributionModel.fromJson(Map<String, dynamic> json) {
    return DistributionModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      scheduleId: json['schedule_id'] != null
          ? int.tryParse(json['schedule_id'].toString())
          : null,

      menuId: json['menu_id'] != null
          ? int.tryParse(json['menu_id'].toString())
          : null,

      jumlahDikirim:
          int.tryParse(json['jumlah_dikirim']?.toString() ?? '0') ?? 0,

      keterangan: json['keterangan']?.toString(),

      status: json['status']?.toString(),

      schedule: json['schedule'] != null
          ? ScheduleModel.fromJson(json['schedule'])
          : null,
    );
  }
}

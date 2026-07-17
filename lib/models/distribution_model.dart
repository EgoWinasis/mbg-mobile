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
      id: json['id'],

      scheduleId: json['schedule_id'],

      menuId: json['menu_id'],

      jumlahDikirim: json['jumlah_dikirim'] ?? 0,

      keterangan: json['keterangan'],

      status: json['status'],

      schedule: json['schedule'] != null
          ? ScheduleModel.fromJson(json['schedule'])
          : null,
    );
  }
}

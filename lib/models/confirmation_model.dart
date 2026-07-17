import 'distribution_model.dart';

class ConfirmationModel {
  final int id;

  final int distributionId;

  final int? userId;

  final int? rating;

  final String? kritik;

  final String? photo;

  final double? latitude;

  final double? longitude;

  final String? status;

  final DateTime? receivedAt;

  final DistributionModel? distribution;

  ConfirmationModel({
    required this.id,

    required this.distributionId,

    this.userId,

    this.rating,

    this.kritik,

    this.photo,

    this.latitude,

    this.longitude,

    this.status,

    this.receivedAt,

    this.distribution,
  });

  factory ConfirmationModel.fromJson(Map<String, dynamic> json) {
    return ConfirmationModel(
      id: json['id'],

      distributionId: json['distribution_id'],

      userId: json['user_id'],

      rating: json['rating'],

      kritik: json['kritik'],

      photo: json['photo'],

      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : null,

      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : null,

      status: json['status'],

      receivedAt: json['received_at'] != null
          ? DateTime.parse(json['received_at'])
          : null,

      distribution: json['distribution'] != null
          ? DistributionModel.fromJson(json['distribution'])
          : null,
    );
  }
}

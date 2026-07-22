class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String role;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final ProfileModel? profile;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.role,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,

      name: json['name'] ?? '',

      email: json['email'],

      phone: json['phone'],

      role: json['role'] ?? '',

      status: json['status'] ?? '',

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,

      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,

      'email': email,

      'phone': phone,

      'role': role,

      'status': status,

      'created_at': createdAt?.toIso8601String(),

      'updated_at': updatedAt?.toIso8601String(),

      'profile': profile?.toJson(),
    };
  }
}

class ProfileModel {
  final int id;

  final String? address;

  final String? birthDate;

  final String? gender;

  final String? beneficiaryType;

  final String? nik;

  final String? photo;

  // tambahan
  final String? childName;

  final String? childBirthDate;

  // hasil perhitungan backend
  final String? ageInformation;

  ProfileModel({
    required this.id,

    this.address,

    this.birthDate,

    this.gender,

    this.beneficiaryType,

    this.nik,

    this.photo,

    this.childName,

    this.childBirthDate,

    this.ageInformation,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,

      address: json['address'],

      birthDate: json['birth_date'],

      gender: json['gender'],

      beneficiaryType: json['beneficiary_type'],

      nik: json['nik'],

      photo: json['photo'],

      childName: json['child_name'],

      childBirthDate: json['child_birth_date'],

      ageInformation: json['age_information'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'address': address,

      'birth_date': birthDate,

      'gender': gender,

      'beneficiary_type': beneficiaryType,

      'nik': nik,

      'photo': photo,

      'child_name': childName,

      'child_birth_date': childBirthDate,

      'age_information': ageInformation,
    };
  }
}

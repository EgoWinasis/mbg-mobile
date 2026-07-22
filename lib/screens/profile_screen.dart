import 'package:flutter/material.dart';

import '../core/storage/secure_storage.dart';

import 'login_screen.dart';
import 'bantuan_screen.dart';
import 'pengaturan_notifikasi_screen.dart';
import 'keamanan_screen.dart';
import 'edit_profile_screen.dart';

import '../core/config/api_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const primaryBlue = Color(0xFF1976D2);

  String nama = "-";

  String phone = "-";

  String email = "-";

  String alamat = "-";

  String beneficiaryType = "-";

  String nik = "-";

  String birthDate = "-";

  String gender = "-";

  String photo = "-";

  // tambahan
  String childName = "-";

  String childBirthDate = "-";

  String ageInformation = "-";

  String childDateLabel = "Tanggal Anak";

  String ageLabel = "Usia";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {
    final user = await SecureStorage.getUser();

    if (!mounted) return;

    if (user != null) {
      final profile = user['profile'];

      setState(() {
        nama = user['name'] ?? "-";

        phone = user['phone'] ?? "-";

        email = user['email'] ?? "-";

        if (profile != null) {
          alamat = profile['address'] ?? "-";

          nik = profile['nik'] ?? "-";

          birthDate = profile['birth_date'] ?? "-";

          photo = profile['photo'] ?? "-";

          // tambahan data anak
          childName = profile['child_name'] ?? "-";

          childBirthDate = profile['child_birth_date'] ?? "-";

          ageInformation = profile['age_information'] ?? "-";

          switch (profile['gender']) {
            case "male":
              gender = "Laki-laki";

              break;

            case "female":
              gender = "Perempuan";

              break;

            default:
              gender = "-";
          }

          switch (profile['beneficiary_type']) {
            case "pregnant":
              beneficiaryType = "Ibu Hamil";

              childDateLabel = "Tanggal Awal Kehamilan (HPHT)";

              ageLabel = "Usia Kandungan";

              break;

            case "toddler_parent":
              beneficiaryType = "Orang Tua Balita";

              childDateLabel = "Tanggal Lahir Anak";

              ageLabel = "Usia Anak";

              break;

            default:
              beneficiaryType = "-";

              childDateLabel = "Tanggal Anak";

              ageLabel = "Usia";
          }
        }

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String displayValue(String value) {
    if (value.isEmpty || value == "-") {
      return "Belum diisi";
    }

    return value;
  }

  ImageProvider getProfileImage() {
    if (photo.isEmpty || photo == "-") {
      return const AssetImage("assets/images/balita.png");
    }

    return NetworkImage(ApiConfig.imageUrl(photo));
  }

  Future<void> logout() async {
    await SecureStorage.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (_) => const LoginScreen()),

      (route) => false,
    );
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (result == true) {
      loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),

          child: Column(
            children: [
              // HEADER PROFILE
              Container(
                width: double.infinity,

                padding: const EdgeInsets.only(top: 35, bottom: 30),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),

                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,

                      backgroundColor: Colors.white,

                      child: CircleAvatar(
                        radius: 50,

                        backgroundImage: getProfileImage(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      displayValue(nama),

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 25,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      displayValue(beneficiaryType),

                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: _openEditProfile,

                      icon: const Icon(Icons.edit),

                      label: const Text("Edit Profil"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        foregroundColor: primaryBlue,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),

                child: Column(
                  children: [
                    ProfileInfoCard(
                      title: "Informasi Akun",

                      icon: Icons.person_outline,

                      children: [
                        ProfileItem(
                          label: "Nama Lengkap",

                          value: displayValue(nama),
                        ),

                        ProfileItem(
                          label: "Nomor Telepon",

                          value: displayValue(phone),
                        ),

                        ProfileItem(label: "Email", value: displayValue(email)),
                      ],
                    ),

                    const SizedBox(height: 15),

                    ProfileInfoCard(
                      title: "Data Pribadi",

                      icon: Icons.badge_outlined,

                      children: [
                        ProfileItem(label: "NIK", value: displayValue(nik)),

                        ProfileItem(
                          label: "Tanggal Lahir",

                          value: displayValue(birthDate),
                        ),

                        ProfileItem(
                          label: "Jenis Kelamin",

                          value: displayValue(gender),
                        ),

                        ProfileItem(
                          label: "Alamat",

                          value: displayValue(alamat),
                        ),

                        ProfileItem(
                          label: "Status Penerima",

                          value: displayValue(beneficiaryType),
                        ),

                        // tambahan hanya muncul jika balita
                        if (beneficiaryType == "Orang Tua Balita")
                          ProfileItem(
                            label: "Nama Anak",

                            value: displayValue(childName),
                          ),

                        ProfileItem(
                          label: childDateLabel,

                          value: displayValue(childBirthDate),
                        ),

                        ProfileItem(
                          label: ageLabel,

                          value: displayValue(ageInformation),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(22),

                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                      ),

                      child: Column(
                        children: [
                          MenuProfile(
                            icon: Icons.notifications_none,

                            title: "Notifikasi",

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      const PengaturanNotifikasiScreen(),
                                ),
                              );
                            },
                          ),

                          MenuProfile(
                            icon: Icons.lock_outline,

                            title: "Keamanan",

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const KeamananScreen(),
                                ),
                              );
                            },
                          ),

                          MenuProfile(
                            icon: Icons.help_outline,

                            title: "Bantuan",

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const BantuanScreen(),
                                ),
                              );
                            },
                          ),

                          MenuProfile(
                            icon: Icons.logout,

                            title: "Keluar",

                            color: Colors.red,

                            onTap: logout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================
// PROFILE INFO CARD
// =====================================

class ProfileInfoCard extends StatelessWidget {
  static const primaryBlue = Color(0xFF1976D2);

  final String title;

  final IconData icon;

  final List<Widget> children;

  const ProfileInfoCard({
    super.key,

    required this.title,

    required this.icon,

    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 42,

                height: 42,

                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),

                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: primaryBlue),
              ),

              const SizedBox(width: 12),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 17,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...children,
        ],
      ),
    );
  }
}

// =====================================
// PROFILE ITEM
// =====================================

class ProfileItem extends StatelessWidget {
  final String label;

  final String value;

  const ProfileItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            flex: 2,

            child: Text(
              label,

              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 3,

            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================
// MENU PROFILE
// =====================================

class MenuProfile extends StatelessWidget {
  final IconData icon;

  final String title;

  final Color color;

  final VoidCallback? onTap;

  const MenuProfile({
    super.key,

    required this.icon,

    required this.title,

    this.color = Colors.black87,

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),

      leading: Container(
        width: 42,

        height: 42,

        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),

          shape: BoxShape.circle,
        ),

        child: Icon(icon, color: color, size: 22),
      ),

      title: Text(
        title,

        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,

        size: 16,

        color: Colors.grey,
      ),

      onTap: onTap,
    );
  }
}

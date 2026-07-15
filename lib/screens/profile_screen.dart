import 'package:flutter/material.dart';

import '../core/storage/secure_storage.dart';

import 'login_screen.dart';
import 'bantuan_screen.dart';
import 'pengaturan_notifikasi_screen.dart';
import 'keamanan_screen.dart';
import 'edit_profile_screen.dart';

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

          switch (profile['gender']) {
            case 'male':
              gender = "Laki-laki";
              break;
            case 'female':
              gender = "Perempuan";
              break;
            default:
              gender = "-";
          }

          switch (profile['beneficiary_type']) {
            case 'pregnant':
              beneficiaryType = "Ibu Hamil";
              break;
            case 'parent':
              beneficiaryType = "Orang Tua Balita";
              break;
            default:
              beneficiaryType = "-";
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 30, bottom: 35),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
                        backgroundImage: (photo != "-" && photo.isNotEmpty)
                            ? NetworkImage(photo)
                            : const AssetImage("assets/images/balita.png")
                                  as ImageProvider,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      beneficiaryType,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: _openEditProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
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
                    ProfileCard(
                      icon: Icons.person_outline,
                      title: "Nama Lengkap",
                      value: nama,
                      color: Colors.blue,
                    ),

                    ProfileCard(
                      icon: Icons.phone_outlined,
                      title: "Nomor Telepon",
                      value: phone,
                      color: Colors.green,
                    ),

                    ProfileCard(
                      icon: Icons.email_outlined,
                      title: "Email",
                      value: email,
                      color: Colors.indigo,
                    ),

                    ProfileCard(
                      icon: Icons.badge_outlined,
                      title: "NIK",
                      value: nik,
                      color: Colors.teal,
                    ),

                    ProfileCard(
                      icon: Icons.cake_outlined,
                      title: "Tanggal Lahir",
                      value: birthDate,
                      color: Colors.pink,
                    ),

                    ProfileCard(
                      icon: Icons.wc_outlined,
                      title: "Jenis Kelamin",
                      value: gender,
                      color: Colors.deepPurple,
                    ),

                    ProfileCard(
                      icon: Icons.location_on_outlined,
                      title: "Alamat",
                      value: alamat,
                      color: Colors.orange,
                    ),

                    ProfileCard(
                      icon: Icons.child_care_outlined,
                      title: "Status Penerima",
                      value: beneficiaryType,
                      color: Colors.purple,
                    ),

                    ProfileCard(
                      icon: Icons.image_outlined,
                      title: "Foto Profil",
                      value: photo == "-" ? "-" : "Sudah diunggah",
                      color: Colors.brown,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(8),
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
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================
// PROFILE CARD
// ==========================

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const ProfileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================
// MENU PROFILE
// ==========================

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
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'bantuan_screen.dart';
import 'pengaturan_notifikasi_screen.dart';
import 'keamanan_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const primaryBlue = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==========================
              // HEADER PROFILE
              // ==========================
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
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,

                          backgroundColor: Colors.white,

                          child: const CircleAvatar(
                            radius: 50,

                            backgroundImage: AssetImage(
                              'assets/images/balita.png',
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),

                        Positioned(
                          right: 0,

                          bottom: 5,

                          child: Container(
                            width: 35,

                            height: 35,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),

                            child: const Icon(
                              Icons.edit,

                              size: 18,

                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Ibu Siti',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 26,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Ibu dari Balita • 24 Bulan',

                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================
              // DATA PROFILE
              // ==========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),

                child: Column(
                  children: [
                    ProfileCard(
                      icon: Icons.person_outline,

                      title: 'Nama Lengkap',

                      value: 'Siti Rahmawati',

                      color: Colors.blue,
                    ),

                    ProfileCard(
                      icon: Icons.phone_outlined,

                      title: 'Nomor Telepon',

                      value: '0812 3456 7890',

                      color: Colors.green,
                    ),

                    ProfileCard(
                      icon: Icons.location_on_outlined,

                      title: 'Alamat',

                      value: 'Jl. Mawar No.10, Bandung',

                      color: Colors.orange,
                    ),

                    ProfileCard(
                      icon: Icons.child_care_outlined,

                      title: 'Data Balita',

                      value: 'Nama Anak • 24 Bulan',

                      color: Colors.purple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================
              // MENU PROFILE
              // ==========================
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
                        title: 'Notifikasi',
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
                        title: 'Keamanan',
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
                        title: 'Bantuan',
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

                        title: 'Keluar',

                        color: Colors.red,

                        onTap: () {
                          Navigator.pushReplacement(
                            context,

                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
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

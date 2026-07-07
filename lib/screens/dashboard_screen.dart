import 'package:flutter/material.dart';

import '../widgets/dashboard_card.dart';
import '../widgets/section_card.dart';
import 'notifikasi_screen.dart';
import 'terima_mbg_screen.dart';
import 'riwayat_penilaian_screen.dart';
import '../widgets/riwayat_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEAF4FF), Color(0xFFDCEEFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    // ICON NOTIFIKASI
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotifikasiScreen(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: primaryBlue,
                                  size: 26,
                                ),
                              ),
                            ),

                            // titik merah notifikasi
                            Positioned(
                              right: 10,
                              top: 8,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ISI HEADER
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Selamat Datang,',
                                  style: TextStyle(fontSize: 18),
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  'Ibu Siti',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Text('👶 Balita • 24 Bulan'),
                                ),
                              ],
                            ),
                          ),

                          Image.asset('assets/images/balita.png', height: 170),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// STAT CARD
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
                children: const [
                  DashboardCard(
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                    title: 'Jadwal Berikutnya',
                    value: '22',
                    subtitle: 'Juni 2026',
                  ),
                  DashboardCard(
                    icon: Icons.check_circle,
                    color: Colors.orange,
                    title: 'Penerimaan',
                    value: '3',
                    subtitle: 'Kali',
                  ),
                  DashboardCard(
                    icon: Icons.child_care,
                    color: Colors.indigo,
                    title: 'Usia Balita',
                    value: '24',
                    subtitle: 'Bulan',
                  ),
                  DashboardCard(
                    icon: Icons.menu_book,
                    color: Colors.purple,
                    title: 'Edukasi',
                    value: '5',
                    subtitle: 'Artikel',
                  ),
                ],
              ),

              const SizedBox(height: 18),
              SectionCard(
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Riwayat Penerimaan MBG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                         onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RiwayatPenilaianScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const RiwayatItem(
                      tanggal: '15 Juni 2026',
                      status: 'Diterima',
                    ),

                    const RiwayatItem(
                      tanggal: '08 Juni 2026',
                      status: 'Diterima',
                    ),

                    const RiwayatItem(
                      tanggal: '01 Juni 2026',
                      status: 'Diterima',
                    ),

                    const RiwayatItem(
                      tanggal: '25 Mei 2026',
                      status: 'Diterima',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              /// JADWAL
              SectionCard(
                color: Colors.green,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // KIRI: TANGGAL
                    Container(
                      width: 75,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Posyandu",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "22",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            "Juni",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // TENGAH: DETAIL
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 6),
                              Text('08.00 - 10.00 WIB'),
                            ],
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.child_care_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 6),
                              Text('Posyandu Melati'),
                            ],
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 6),
                              Expanded(child: Text('Jl. Mawar No.10, Bandung')),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // KANAN: GAMBAR
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/posyandu.png", // ganti sesuai file kamu
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// MENU
              SectionCard(
                color: Colors.indigo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu Hari Ini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/menu_hari_ini.jpg',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Detail Menu',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Nasi, Ayam Goreng, Sayur Bayam, dan Jeruk',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Menu bergizi seimbang yang disiapkan untuk memenuhi kebutuhan gizi harian siswa.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              SectionCard(
                color: Colors.green,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Beri Penilaian Menu Hari Ini',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: List.generate(
                              5,
                              (index) => const Padding(
                                padding: EdgeInsets.only(right: 2),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Bagaimana menu yang diberikan hari ini?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 14),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RiwayatMBGScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Beri Penilaian'),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward_ios, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/rating_menu.png', // ganti sesuai nama file kamu
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              /// EDUKASI
              SectionCard(
                color: Colors.blue,
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        size: 40,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cegah Stunting Sejak Dini',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ketahui cara mencegah stunting pada anak sejak usia dini.',
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

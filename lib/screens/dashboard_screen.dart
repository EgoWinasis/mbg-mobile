import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';
import '../core/storage/secure_storage.dart';

import '../widgets/dashboard_card.dart';
import '../widgets/section_card.dart';
import '../widgets/riwayat_item.dart';

import 'notifikasi_screen.dart';
import 'terima_mbg_screen.dart';
import 'riwayat_penilaian_screen.dart';
import 'jadwal_screen.dart';
import 'edukasi_screen.dart';
import 'menu_screen.dart';
import '../core/config/api_config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardModel? dashboard;

  bool loading = true;

  static const primaryBlue = Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();

    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final data = await DashboardService().getDashboard();

      final user = await SecureStorage.getUser();

      if (user != null) {
        data.profile.name = user['name'] ?? data.profile.name;

        data.profile.type = user['type'] ?? data.profile.type;
      }

      if (!mounted) return;

      setState(() {
        dashboard = data;

        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  String getProfileImage() {
    final type = dashboard?.profile.type?.toLowerCase();

    if (type == 'ibu_hamil') {
      return 'assets/images/hamil.png';
    }

    return 'assets/images/balita.png';
  }

  String getProfileLabel() {
    final type = dashboard?.profile.type?.toLowerCase();

    if (type == 'ibu_hamil') {
      return '🤰 Ibu Hamil';
    }

    final umur = dashboard?.statistics.childAge;

    if (umur != null) {
      return '👶 Balita • $umur Bulan';
    }

    return '👶 Balita';
  }

  String formatDay(String? date) {
    if (date == null || date.isEmpty) {
      return '-';
    }

    final split = date.split('-');

    if (split.length < 3) {
      return date;
    }

    return split[2];
  }

  String formatMonth(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    final split = date.split('-');

    if (split.length < 2) {
      return '';
    }

    final month = int.tryParse(split[1]);

    const months = [
      '',

      'Januari',

      'Februari',

      'Maret',

      'April',

      'Mei',

      'Juni',

      'Juli',

      'Agustus',

      'September',

      'Oktober',

      'November',

      'Desember',
    ];

    if (month == null || month > 12) {
      return '';
    }

    return months[month];
  }

  String formatTime(String time) {
    if (time.isEmpty) {
      return '-';
    }

    final data = time.split(':');

    if (data.length >= 2) {
      return '${data[0]}:${data[1]}';
    }

    return time;
  }

  String getShortMonth(String date) {
    final split = date.split('-');

    if (split.length < 3) {
      return '';
    }

    const months = [
      '',

      'JAN',

      'FEB',

      'MAR',

      'APR',

      'MEI',

      'JUN',

      'JUL',

      'AGU',

      'SEP',

      'OKT',

      'NOV',

      'DES',
    ];

    final month = int.tryParse(split[1]) ?? 0;

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month];
  }

  String getYear(String date) {
    final split = date.split('-');

    if (split.length < 1) {
      return '';
    }

    return split[0];
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dashboard == null) {
      return const Scaffold(
        body: Center(child: Text('Data dashboard tidak tersedia')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),

          child: Column(
            children: [
              _header(),

              const SizedBox(height: 20),

              _statistics(),

              const SizedBox(height: 18),

              _history(),

              const SizedBox(height: 18),

              _schedule(),

              const SizedBox(height: 18),

              _menu(),

              const SizedBox(height: 18),

              _rating(),

              const SizedBox(height: 18),

              _education(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF4FF), Color(0xFFDCEEFF)],
        ),

        borderRadius: BorderRadius.circular(28),
      ),

      child: Stack(
        children: [
          Positioned(
            right: 0,

            top: 0,

            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const NotifikasiScreen()),
                );
              },

              child: Container(
                width: 42,

                height: 42,

                decoration: BoxDecoration(
                  color: Colors.white,

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.notifications_none_rounded,

                  color: primaryBlue,

                  size: 26,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 35),

            child: Row(
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

                      Text(
                        dashboard!.profile.name,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
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

                        child: Text(getProfileLabel()),
                      ),
                    ],
                  ),
                ),

                Image.asset(
                  getProfileImage(),

                  height: 150,

                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STATISTIC =================

  Widget _statistics() {
    return GridView.count(
      crossAxisCount: 2,

      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      crossAxisSpacing: 12,

      mainAxisSpacing: 12,

      childAspectRatio: 0.9,

      children: [
        DashboardCard(
          icon: Icons.calendar_month,

          color: Colors.blue,

          title: 'Jadwal Berikutnya',

          value: dashboard!.nextSchedule != null
              ? formatDay(dashboard!.nextSchedule!.date)
              : '-',

          subtitle: dashboard!.nextSchedule != null
              ? formatMonth(dashboard!.nextSchedule!.date)
              : '',
        ),

        DashboardCard(
          icon: Icons.check_circle,

          color: Colors.orange,

          title: 'Penerimaan',

          value: dashboard!.statistics.confirmationCount.toString(),

          subtitle: 'Kali',
        ),

        DashboardCard(
          icon: Icons.child_care,

          color: Colors.indigo,

          title: 'Usia Balita',

          value: dashboard!.statistics.childAge?.toString() ?? '-',

          subtitle: 'Bulan',
        ),

        DashboardCard(
          icon: Icons.menu_book,

          color: Colors.purple,

          title: 'Edukasi',

          value: dashboard!.statistics.educationCount.toString(),

          subtitle: 'Artikel',
        ),
      ],
    );
  }

  // ================= HISTORY =================

  Widget _history() {
    return SectionCard(
      color: Colors.blue,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                'Riwayat Penerimaan MBG',

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => const RiwayatPenilaianScreen(),
                    ),
                  );
                },

                child: const Text(
                  'Lihat Semua',

                  style: TextStyle(color: Colors.green, fontSize: 11),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (dashboard!.latestConfirmations.isEmpty)
            const Text('Belum ada riwayat penerimaan')
          else
            ...dashboard!.latestConfirmations.map(
              (item) => RiwayatItem(tanggal: item.date, status: item.status),
            ),
        ],
      ),
    );
  }
  // ================= SCHEDULE =================

  Widget _schedule() {
    final schedule = dashboard!.nextSchedule;

    if (schedule == null) {
      return const SizedBox();
    }

    return SectionCard(
      color: Colors.green,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Colors.green,
                size: 22,
              ),

              const SizedBox(width: 8),

              const Text(
                'Jadwal Posyandu',

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // TANGGAL
              Container(
                width: 85,

                height: 100,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      formatDay(schedule.date),

                      style: const TextStyle(
                        fontSize: 30,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      getShortMonth(schedule.date),

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // DETAIL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Colors.green,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '${formatTime(schedule.startTime)} - ${formatTime(schedule.endTime)} WIB',

                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.green,
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            schedule.location,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: Colors.green,
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            schedule.address,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // BUTTON
          SizedBox(
            width: double.infinity,

            height: 40,

            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const JadwalScreen()),
                );
              },

              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,

                side: const BorderSide(color: Colors.green),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.arrow_forward_rounded, size: 18),

                  SizedBox(width: 8),

                  Text('Lihat Jadwal Lengkap', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU HARI INI =================

  Widget _menu() {
    final menu = dashboard!.todayMenu;

    if (menu == null) {
      return const SizedBox();
    }

    return SectionCard(
      color: Colors.indigo,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
          Row(
            children: [
              const Icon(
                Icons.restaurant_menu_rounded,
                color: Colors.indigo,
                size: 22,
              ),

              const SizedBox(width: 8),

              const Text(
                'Menu Hari Ini',

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),

            child: menu.image != null
                ? Image.network(
                    ApiConfig.imageUrl(menu.image!),

                    height: 180,

                    width: double.infinity,

                    fit: BoxFit.cover,

                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/images/menu_hari_ini.jpg',

                        height: 180,

                        width: double.infinity,

                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/menu_hari_ini.jpg',

                    height: 180,

                    width: double.infinity,

                    fit: BoxFit.cover,
                  ),
          ),

          const SizedBox(height: 12),

          // TITLE
          Text(
            menu.title,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 6),

          // DESCRIPTION
          Text(
            menu.description,

            maxLines: 3,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 18),

          // BUTTON
          SizedBox(
            width: double.infinity,

            height: 40,

            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                );
              },

              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,

                side: const BorderSide(color: Colors.indigo),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.arrow_forward_rounded, size: 18),

                  SizedBox(width: 8),

                  Text('Lihat Menu Lengkap', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= RATING =================

  Widget _rating() {
    return SectionCard(
      color: Colors.green,

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Beri Penilaian Menu Hari Ini',

                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Row(
                  children: List.generate(
                    5,

                    (index) =>
                        const Icon(Icons.star, color: Colors.amber, size: 22),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Bagaimana menu yang diberikan hari ini?',

                  style: TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 14),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const RiwayatMBGScreen(),
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

          Image.asset(
            'assets/images/rating_menu.png',

            width: 100,

            height: 100,

            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // ================= EDUCATION =================

  Widget _education() {
    return SectionCard(
      color: Colors.blue,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: primaryBlue, size: 22),

              const SizedBox(width: 8),

              const Text(
                'Edukasi',

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Cegah Stunting Sejak Dini',

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${dashboard!.statistics.educationCount} artikel tersedia untuk dipelajari.',

                      style: TextStyle(
                        color: Colors.grey.shade700,

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,

            height: 40,

            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const EdukasiScreen()),
                );
              },

              style: OutlinedButton.styleFrom(
                foregroundColor: primaryBlue,

                side: const BorderSide(color: primaryBlue),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.arrow_forward_rounded, size: 18),

                  SizedBox(width: 8),

                  Text('Lihat Edukasi Lengkap', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

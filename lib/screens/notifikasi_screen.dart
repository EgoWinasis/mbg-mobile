import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../services/schedule_service.dart';

import 'pengaturan_notifikasi_screen.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  final ScheduleService scheduleService = ScheduleService();

  List<ScheduleModel> schedules = [];

  bool loading = true;

  String selectedCategory = "Semua";

  @override
  void initState() {
    super.initState();

    loadNotification();
  }

  Future<void> loadNotification() async {
    try {
      final result = await scheduleService.getSchedules();

      setState(() {
        schedules = result;

        loading = false;
      });
    } catch (e) {
      debugPrint("ERROR NOTIFIKASI : $e");

      setState(() {
        loading = false;
      });
    }
  }

  String formatTanggal(String? date) {
    if (date == null) {
      return "-";
    }

    final parsed = DateTime.tryParse(date);

    if (parsed == null) {
      return date;
    }

    return "${parsed.day} "
        "${namaBulan(parsed.month)} "
        "${parsed.year}";
  }

  String namaBulan(int bulan) {
    const bulanList = [
      "",

      "Januari",

      "Februari",

      "Maret",

      "April",

      "Mei",

      "Juni",

      "Juli",

      "Agustus",

      "September",

      "Oktober",

      "November",

      "Desember",
    ];

    return bulanList[bulan];
  }

  List<ScheduleModel> get filteredSchedules {
    if (selectedCategory == "Semua") {
      return schedules;
    }

    return schedules.where((item) {
      final type = item.type?.toLowerCase() ?? "";

      return type == selectedCategory.toLowerCase();
    }).toList();
  }

  bool isLewat(ScheduleModel item) {
    if (item.date == null) {
      return false;
    }

    final tanggal = DateTime.tryParse(item.date!);

    if (tanggal == null) {
      return false;
    }

    return tanggal.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredSchedules;

    final akanDatang = data.where((e) => !isLewat(e)).toList();

    final sudahLewat = data.where((e) => isLewat(e)).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Notifikasi",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const PengaturanNotifikasiScreen(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.settings, color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // FILTER
              SizedBox(
                height: 42,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    filterChip("Semua"),

                    filterChip("MBG"),

                    filterChip("Posyandu"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : data.isEmpty
                    ? const Center(child: Text("Tidak ada jadwal"))
                    : ListView(
                        children: [
                          if (akanDatang.isNotEmpty)
                            const SectionTitle(title: "Jadwal Akan Datang"),

                          ...akanDatang.map(
                            (item) => NotificationCard(
                              item: item,

                              sudahLewat: false,

                              tanggal: formatTanggal(item.date),
                            ),
                          ),

                          if (sudahLewat.isNotEmpty)
                            const SectionTitle(title: "Jadwal Terlewati"),

                          ...sudahLewat.map(
                            (item) => NotificationCard(
                              item: item,

                              sudahLewat: true,

                              tanggal: formatTanggal(item.date),
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

  Widget filterChip(String title) {
    final aktif = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 10),

        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

        decoration: BoxDecoration(
          color: aktif ? Colors.blue : Colors.grey.shade100,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: aktif ? Colors.white : Colors.black87,

            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),

      child: Text(
        title,

        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final ScheduleModel item;

  final bool sudahLewat;

  final String tanggal;

  const NotificationCard({
    super.key,

    required this.item,

    required this.sudahLewat,

    required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    final type = item.type?.toLowerCase() ?? "mbg";

    final isPosyandu = type == "posyandu";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: sudahLewat ? Colors.grey.shade300 : Colors.blue.shade100,
        ),
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (isPosyandu ? Colors.purple : Colors.green)
                .withOpacity(.15),

            child: Icon(
              isPosyandu ? Icons.child_care : Icons.restaurant,

              color: isPosyandu ? Colors.purple : Colors.green,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  isPosyandu ? "Posyandu" : "MBG",

                  style: TextStyle(
                    color: isPosyandu ? Colors.purple : Colors.green,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  item.title ?? "-",

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(tanggal),

                if (sudahLewat)
                  const Text(
                    "Sudah terlaksana",

                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),

            child: Image.asset(
              isPosyandu
                  ? "assets/images/posyandu.png"
                  : "assets/images/mbg.png",

              width: 70,

              height: 70,

              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

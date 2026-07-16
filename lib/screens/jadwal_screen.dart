import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../services/schedule_service.dart';

import 'main_screen.dart';
import 'jadwal_detail_screen.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  final ScheduleService service = ScheduleService();

  late Future<List<ScheduleModel>> futureSchedule;

  String selectedFilter = "semua";

  String? selectedMonth;

  @override
  void initState() {
    super.initState();

    loadSchedule();
  }

  void loadSchedule() {
    futureSchedule = service.getSchedules(
      type: selectedFilter == "semua" ? null : selectedFilter,

      month: selectedMonth,
    );
  }

  void changeFilter(String value) {
    setState(() {
      selectedFilter = value;

      loadSchedule();
    });
  }

  void selectMonth() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2025),

      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedMonth =
            "${picked.year}-"
            "${picked.month.toString().padLeft(2, '0')}";

        loadSchedule();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: FutureBuilder<List<ScheduleModel>>(
          future: futureSchedule,

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.error_outline,

                      size: 50,

                      color: Colors.red,
                    ),

                    const SizedBox(height: 10),

                    const Text("Gagal mengambil jadwal"),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loadSchedule();
                        });
                      },

                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }

            final schedules = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const MainScreen(),
                              ),
                            );
                          }
                        },

                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            "Jadwal MBG & Posyandu",

                            style: TextStyle(
                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: selectMonth,

                        icon: const Icon(
                          Icons.calendar_month,

                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                      children: [
                        FilterChipWidget(
                          text: "Semua",

                          selected: selectedFilter == "semua",

                          onTap: () {
                            changeFilter("semua");
                          },
                        ),

                        const SizedBox(width: 10),

                        FilterChipWidget(
                          text: "Posyandu",

                          selected: selectedFilter == "posyandu",

                          onTap: () {
                            changeFilter("posyandu");
                          },
                        ),

                        const SizedBox(width: 10),

                        FilterChipWidget(
                          text: "MBG",

                          selected: selectedFilter == "mbg",

                          onTap: () {
                            changeFilter("mbg");
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (selectedMonth != null)
                    Text(
                      "Bulan : $selectedMonth",

                      style: const TextStyle(color: Colors.blue),
                    ),

                  const SizedBox(height: 20),

                  const Text(
                    "Jadwal Terdekat",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  if (schedules.isEmpty)
                    emptySchedule()
                  else
                    Column(
                      children: schedules.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),

                          child: JadwalCard(data: item),
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,

    required this.text,

    required this.selected,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade100,

          borderRadius: BorderRadius.circular(25),
        ),

        child: Text(
          text,

          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,

            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class JadwalCard extends StatelessWidget {
  final ScheduleModel data;

  const JadwalCard({super.key, required this.data});

  Color get cardColor {
    return data.isMbg ? Colors.orange : Colors.green;
  }

  String get ilustrasi {
    if (data.isMbg) {
      return "assets/images/mbg.png";
    }

    return "assets/images/posyandu.png";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(builder: (_) => JadwalDetailScreen(data: data)),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: cardColor.withValues(alpha: 0.15)),
        ),

        child: Row(
          children: [
            Container(
              width: 75,

              padding: const EdgeInsets.symmetric(vertical: 10),

              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.08),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  Text(
                    data.kategori,

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 10,

                      color: cardColor,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    data.tanggal,

                    style: TextStyle(
                      fontSize: 30,

                      fontWeight: FontWeight.bold,

                      color: cardColor,
                    ),
                  ),

                  Text(
                    data.bulan,

                    style: TextStyle(
                      color: cardColor,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(data.tahun, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    data.title,

                    style: const TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "🕒 ${data.startTime ?? '-'} - ${data.endTime ?? '-'} WIB",

                    style: const TextStyle(fontSize: 12),
                  ),

                  Text(
                    "📍 ${data.location ?? '-'}",

                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,

                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: data.isExpired
                          ? Colors.grey.shade200
                          : cardColor.withValues(alpha: 0.12),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      data.status,

                      style: TextStyle(
                        color: data.isExpired ? Colors.grey : cardColor,

                        fontSize: 11,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // GAMBAR ILUSTRASI
            // BUKAN GAMBAR API
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.asset(
                ilustrasi,

                width: 70,

                height: 70,

                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JadwalListItem extends StatelessWidget {
  final ScheduleModel data;

  const JadwalListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(builder: (_) => JadwalDetailScreen(data: data)),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

          border: Border.all(color: Colors.grey.shade200),
        ),

        child: Row(
          children: [
            Column(
              children: [
                Text(
                  data.tanggal,

                  style: const TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  data.bulan,

                  style: const TextStyle(
                    color: Colors.blue,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    data.kategori,

                    style: const TextStyle(color: Colors.blue),
                  ),

                  Text(
                    data.title,

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "🕒 ${data.startTime ?? '-'} WIB",

                    style: const TextStyle(fontSize: 12),
                  ),

                  Text(
                    "📍 ${data.location ?? '-'}",

                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

Widget emptySchedule() {
  return Container(
    width: double.infinity,

    padding: const EdgeInsets.all(25),

    decoration: BoxDecoration(
      color: Colors.blue.shade50,

      borderRadius: BorderRadius.circular(20),
    ),

    child: Column(
      children: [
        const Icon(Icons.event_busy, size: 50, color: Colors.blue),

        const SizedBox(height: 10),

        const Text(
          "Belum ada jadwal",

          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          "Jadwal MBG dan Posyandu akan muncul di sini",

          textAlign: TextAlign.center,

          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    ),
  );
}

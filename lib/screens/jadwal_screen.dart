import 'package:flutter/material.dart';
import 'main_screen.dart';


class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  static const primaryBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // HEADER
              Row(
                children: [

                  IconButton(
                   onPressed: () async {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Jadwal MBG & Posyandu',
                       style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 16),

              // FILTER
              const Row(
                children: [

                  FilterChipWidget(
                    text: "Semua",
                    selected: true,
                  ),

                  SizedBox(width: 10),

                  FilterChipWidget(
                    text: "Posyandu",
                  ),

                  SizedBox(width: 10),

                  FilterChipWidget(
                    text: "MBG",
                  ),

                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Jadwal Terdekat",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const JadwalCard(
                color: Colors.green,
                kategori: "Posyandu",
                tanggal: "22",
                bulan: "JUN",
                tahun: "2026",
                judul: "Posyandu Bulan Juni",
                waktu: "08.00 - 11.00 WIB",
                lokasi: "Posyandu Melati",
                alamat: "Jl. Mawar No. 10, Bandung",
                 image: "assets/images/posyandu.png",
              ),

              const SizedBox(height: 12),

              const JadwalCard(
                color: Colors.orange,
                kategori: "Pembagian MBG",
                tanggal: "24",
                bulan: "JUN",
                tahun: "2026",
                judul: "Pembagian MBG",
                waktu: "09.00 - 10.00 WIB",
                lokasi: "Posyandu Melati",
                alamat: "Jl. Mawar No. 10, Bandung",
                 image: "assets/images/mbg.png",
              ),

              const SizedBox(height: 24),

              const Text(
                "Jadwal Lainnya",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const JadwalListItem(
                kategori: "Posyandu",
                tanggal: "20",
                bulan: "JUL",
                judul: "Posyandu Bulan Juli",
              ),

              const JadwalListItem(
                kategori: "Pembagian MBG",
                tanggal: "22",
                bulan: "JUL",
                judul: "Pembagian MBG",
              ),

              const JadwalListItem(
                kategori: "Posyandu",
                tanggal: "17",
                bulan: "AUG",
                judul: "Posyandu Bulan Agustus",
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String text;
  final bool selected;

  const FilterChipWidget({
    super.key,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: selected
            ? Colors.blue
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected
              ? Colors.white
              : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class JadwalCard extends StatelessWidget {
  final Color color;
  final String kategori;
  final String tanggal;
  final String bulan;
  final String tahun;
  final String judul;
  final String waktu;
  final String lokasi;
  final String alamat;
  final String image;

  const JadwalCard({
    super.key,
    required this.color,
    required this.kategori,
    required this.tanggal,
    required this.bulan,
    required this.tahun,
    required this.judul,
    required this.waktu,
    required this.lokasi,
    required this.alamat,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT DATE BOX
          Container(
            width: 75,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  kategori,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  tanggal,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1,
                  ),
                ),
                Text(
                  bulan,
                  style: TextStyle(fontWeight: FontWeight.w600, color: color),
                ),
                Text(tahun, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // MIDDLE CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        waktu,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.green),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        lokasi,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  alamat,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Akan datang",
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // RIGHT IMAGE + ARROW
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
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
    );
  }
}

class JadwalListItem extends StatelessWidget {
  final String kategori;
  final String tanggal;
  final String bulan;
  final String judul;

  const JadwalListItem({
    super.key,
    required this.kategori,
    required this.tanggal,
    required this.bulan,
    required this.judul,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          SizedBox(
            width: 55,

            child: Column(
              children: [

                Text(
                  tanggal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                Text(
                  bulan,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  kategori,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "🕒 08.00 - 11.00 WIB",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

                const Text(
                  "📍 Posyandu Melati",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),

              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),

        ],
      ),
    );
  }
}
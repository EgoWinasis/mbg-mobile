import 'package:flutter/material.dart';

import '../models/schedule_model.dart';

class JadwalDetailScreen extends StatelessWidget {
  final ScheduleModel data;

  const JadwalDetailScreen({super.key, required this.data});

  Color get color {
    return data.isMbg ? Colors.orange : Colors.green;
  }

  void openImage(BuildContext context) {
    if (data.image == null) {
      return;
    }

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) => FullscreenImageScreen(imageUrl: data.image!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.blue),

        title: Text(
          data.kategori,

          style: const TextStyle(
            color: Colors.black,

            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // FOTO API
            if (data.image != null)
              GestureDetector(
                onTap: () {
                  openImage(context);
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: Image.network(
                    data.image!,

                    width: double.infinity,

                    height: 220,

                    fit: BoxFit.cover,

                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 220,

                        color: Colors.grey.shade200,

                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Text(
              data.title,

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),

                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                children: [
                  DetailRow(
                    icon: Icons.calendar_month,

                    text: "${data.tanggal} ${data.bulan} ${data.tahun}",
                  ),

                  DetailRow(
                    icon: Icons.access_time,

                    text:
                        "${data.startTime ?? '-'} - ${data.endTime ?? '-'} WIB",
                  ),

                  DetailRow(
                    icon: Icons.location_on,

                    text: data.location ?? "-",
                  ),

                  if (data.address != null)
                    DetailRow(icon: Icons.home, text: data.address!),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: data.isExpired
                    ? Colors.red.shade50
                    : Colors.green.shade50,

                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [
                  Icon(
                    data.isExpired ? Icons.info : Icons.check_circle,

                    color: data.isExpired ? Colors.red : Colors.green,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      data.isExpired
                          ? "Jadwal ini sudah selesai"
                          : "Jadwal akan datang",

                      style: TextStyle(
                        color: data.isExpired ? Colors.red : Colors.green,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (data.description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Keterangan",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(data.description!, style: const TextStyle(fontSize: 15)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;

  final String text;

  const DetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),

          const SizedBox(width: 10),

          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class FullscreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullscreenImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,

          maxScale: 4,

          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

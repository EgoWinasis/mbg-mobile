import 'package:flutter/material.dart';

import '../models/confirmation_model.dart';
import '../services/confirmation_service.dart';
import '../core/config/api_config.dart';

class DetailPenilaianScreen extends StatefulWidget {
  final int confirmationId;

  const DetailPenilaianScreen({super.key, required this.confirmationId});

  @override
  State<DetailPenilaianScreen> createState() => _DetailPenilaianScreenState();
}

class _DetailPenilaianScreenState extends State<DetailPenilaianScreen> {
  final ConfirmationService confirmationService = ConfirmationService();

  ConfirmationModel? confirmation;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final result = await confirmationService.getConfirmationDetail(
        widget.confirmationId,
      );

      setState(() {
        confirmation = result;

        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR DETAIL : $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildStar(double rating, int index) {
    return Icon(
      Icons.star,

      size: 32,

      color: rating >= index ? Colors.orange : Colors.grey.shade300,
    );
  }

  String formatTanggal(DateTime? date) {
    if (date == null) {
      return "-";
    }

    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (confirmation == null) {
      return const Scaffold(body: Center(child: Text("Data tidak ditemukan")));
    }

    final item = confirmation!;

    final fotoUrl = item.photo != null ? ApiConfig.imageUrl(item.photo!) : "";

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            // HEADER
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),

                  icon: const Icon(
                    Icons.arrow_back,

                    color: Colors.blue,

                    size: 30,
                  ),
                ),

                const Expanded(
                  child: Text(
                    "Detail Penilaian MBG",

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(width: 48),
              ],
            ),

            const SizedBox(height: 24),

            // TANGGAL
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.blue),

                  const SizedBox(width: 10),

                  Text(
                    "Tanggal Penerimaan: "
                    "${formatTanggal(item.receivedAt)}",

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // RATING
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Rating",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        5,

                        (index) =>
                            _buildStar(item.rating?.toDouble() ?? 0, index + 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // KRITIK
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Kritik & Saran",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(item.kritik ?? "-"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // FOTO
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Bukti Foto",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: fotoUrl.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    FullImageScreen(imageUrl: fotoUrl),
                              ),
                            );
                          },

                    child: fotoUrl.isEmpty
                        ? const Text("Tidak ada foto")
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),

                            child: Image.network(
                              fotoUrl,

                              width: double.infinity,

                              height: 220,

                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

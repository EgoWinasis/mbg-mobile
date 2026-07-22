import 'package:flutter/material.dart';

import 'detail_penilaian_screen.dart';

import '../models/confirmation_model.dart';
import '../services/confirmation_service.dart';

class RiwayatPenilaianScreen extends StatefulWidget {
  const RiwayatPenilaianScreen({super.key});

  @override
  State<RiwayatPenilaianScreen> createState() => _RiwayatPenilaianScreenState();
}

class _RiwayatPenilaianScreenState extends State<RiwayatPenilaianScreen> {
  DateTime? selectedMonth;

  final ConfirmationService confirmationService = ConfirmationService();

  List<ConfirmationModel> riwayat = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadRiwayat();
  }

  Future<void> loadRiwayat({int? month, int? year}) async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await confirmationService.getHistoryConfirmation(
        month: month,
        year: year,
      );

      setState(() {
        riwayat = result;

        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR RIWAYAT : $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pilihBulan() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: selectedMonth ?? DateTime.now(),

      firstDate: DateTime(2025),

      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });

      loadRiwayat(month: picked.month, year: picked.year);
    }
  }

  String formatTanggal(DateTime? date) {
    if (date == null) {
      return "-";
    }

    return "${date.day} "
        "${_namaBulan(date.month)} "
        "${date.year}";
  }

  String _namaBulan(int bulan) {
    const nama = [
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

    return nama[bulan];
  }

  @override
  Widget build(BuildContext context) {
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

                    icon: const Icon(
                      Icons.arrow_back,

                      color: Colors.blue,

                      size: 30,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      "Riwayat MBG",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 20),

              // FILTER BULAN
              SizedBox(
                width: double.infinity,

                child: OutlinedButton.icon(
                  onPressed: pilihBulan,

                  icon: const Icon(Icons.calendar_month),

                  label: Text(
                    selectedMonth == null
                        ? "Filter Bulan"
                        : "Bulan "
                              "${selectedMonth!.month}/"
                              "${selectedMonth!.year}",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // HEADER TABLE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,

                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: Colors.blue.shade50,

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: Colors.blue.shade200),
                ),

                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,

                      child: Text(
                        "Tanggal",

                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    Expanded(
                      flex: 2,

                      child: Text(
                        "Status",

                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    Expanded(
                      flex: 2,

                      child: Align(
                        alignment: Alignment.centerRight,

                        child: Text(
                          "Aksi",

                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // LIST
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : riwayat.isEmpty
                    ? const Center(child: Text("Data tidak ditemukan"))
                    : ListView.builder(
                        itemCount: riwayat.length,

                        itemBuilder: (context, index) {
                          final item = riwayat[index];

                          final isDiterima = item.status == "diterima";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,

                              vertical: 12,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(14),

                              border: Border.all(color: Colors.grey.shade200),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,

                                  child: Text(
                                    formatTanggal(item.receivedAt),

                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,

                                  child: Row(
                                    children: [
                                      Icon(
                                        isDiterima
                                            ? Icons.check_circle
                                            : Icons.pending,

                                        size: 18,

                                        color: isDiterima
                                            ? Colors.green
                                            : Colors.orange,
                                      ),

                                      const SizedBox(width: 4),

                                      Text(
                                        item.status ?? "-",

                                        style: TextStyle(
                                          color: isDiterima
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 2,

                                  child: Align(
                                    alignment: Alignment.centerRight,

                                    child: SizedBox(
                                      height: 35,

                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,

                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  DetailPenilaianScreen(
                                                    confirmationId: item.id,
                                                  ),
                                            ),
                                          );
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,

                                          foregroundColor: Colors.white,

                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),

                                        child: const Text(
                                          "Detail",

                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


class ArtikelDetailScreen extends StatelessWidget {
  const ArtikelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.white,

            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/balita.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.purple
                              .withValues(alpha: .12),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: const Text(
                          "Stunting",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.schedule,
                        size: 18,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 4),

                      const Text(
                        "5 min baca",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Apa Itu Stunting dan Bagaimana Mencegahnya?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Dipublikasikan 24 Juni 2026",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color:
                          Colors.blue.withValues(alpha: .06),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: const Row(
                      children: [

                        Icon(
                          Icons.lightbulb,
                          color: Colors.blue,
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            "Stunting dapat dicegah sejak masa kehamilan melalui pemenuhan gizi yang baik.",
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    '''
Stunting adalah kondisi gagal tumbuh pada anak akibat kekurangan gizi kronis dalam jangka waktu yang lama. Kondisi ini menyebabkan tinggi badan anak lebih rendah dibandingkan standar usianya.

Pencegahan stunting dimulai sejak masa kehamilan. Ibu hamil perlu mendapatkan asupan gizi yang cukup, rutin memeriksakan kandungan, dan mengonsumsi tablet tambah darah sesuai anjuran tenaga kesehatan.

Setelah bayi lahir, pemberian ASI eksklusif selama 6 bulan sangat penting. Setelah itu, anak perlu mendapatkan MPASI yang bergizi seimbang untuk mendukung tumbuh kembangnya.

Selain faktor gizi, kebersihan lingkungan, sanitasi yang baik, serta imunisasi lengkap juga memiliki peran penting dalam mencegah stunting.

Dengan pemenuhan gizi yang tepat dan pemantauan tumbuh kembang secara rutin, anak dapat tumbuh sehat, cerdas, dan optimal.
                    ''',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.9,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.green
                          .withValues(alpha: .08),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: const Row(
                      children: [

                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            "Pastikan anak mendapatkan gizi seimbang, imunisasi lengkap, dan pemeriksaan rutin ke posyandu.",
                            style: TextStyle(
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
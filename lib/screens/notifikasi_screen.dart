import 'package:flutter/material.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  static const primaryBlue = Color(0xFF2563EB);

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
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Notifikasi',
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
                      Icons.settings,
                      color: Colors.blue,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 16),

              // FILTER
              SizedBox(
                height: 40,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: const [

                    FilterChipItem(
                      title: 'Semua',
                      isSelected: true,
                    ),

                    FilterChipItem(
                      title: 'MBG',
                    ),

                    FilterChipItem(
                      title: 'Posyandu',
                    ),

                    FilterChipItem(
                      title: 'Informasi',
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(

                  children: const [

                    Text(
                      'Hari ini',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 10),

                    NotificationCard(
                      icon: Icons.notifications,
                      iconColor: Colors.green,
                      category: 'Pengingat MBG',
                      title:
                          'Jadwal pembagian MBG besok, 20 Juni 2026',
                      description:
                          'Jangan lupa datang tepat waktu ya, Bu 😊',
                      time: '08.00 WIB',
                      image: 'assets/images/balita.png',
                    ),

                    SizedBox(height: 12),

                    NotificationCard(
                      icon: Icons.calendar_month,
                      iconColor: Colors.blue,
                      category: 'Jadwal Posyandu',
                      title:
                          'Posyandu bulan Juni akan dilaksanakan',
                      description:
                          'Kamis, 22 Juni 2026\n08.00 - 11.00 WIB\nPosyandu Melati',
                      time: 'Kemarin',
                      image: 'assets/images/balita.png',
                    ),

                    SizedBox(height: 20),

                    Text(
                      '18 Juni 2026',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 10),

                    NotificationCard(
                      icon: Icons.campaign,
                      iconColor: Colors.orange,
                      category: 'Informasi',
                      title:
                          'Menu MBG minggu ini sudah tersedia!',
                      description:
                          'Yuk lihat menu dan informasi gizinya di aplikasi.',
                      time: '18/06/2026',
                      image: 'assets/images/balita.png',
                    ),

                    SizedBox(height: 20),

                    Text(
                      '17 Juni 2026',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 10),

                    NotificationCard(
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      category: 'MBG',
                      title:
                          'Terima kasih telah hadir dan menerima MBG hari ini 😊',
                      description:
                          'Sampai jumpa di kegiatan berikutnya.',
                      time: '17/06/2026',
                      image: 'assets/images/balita.png',
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

// =============================
// FILTER CHIP
// =============================

class FilterChipItem extends StatelessWidget {

  final String title;
  final bool isSelected;

  const FilterChipItem({
    super.key,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(right: 10),

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? Colors.blue
              : Colors.grey.shade100,

          borderRadius:
              BorderRadius.circular(20),

        ),

        child: Text(

          title,

          style: TextStyle(

            color: isSelected
                ? Colors.white
                : Colors.black87,

            fontWeight: FontWeight.w500,

            fontSize: 13,

          ),
        ),
      ),
    );
  }
}

// =============================
// NOTIFICATION CARD
// =============================

class NotificationCard extends StatelessWidget {

  final IconData icon;
  final Color iconColor;
  final String category;
  final String title;
  final String description;
  final String time;
  final String image;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.category,
    required this.title,
    required this.description,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color:
              Colors.grey.withValues(alpha: 0.15),
        ),

      ),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(

            width: 50,
            height: 50,

            decoration: BoxDecoration(

              color:
                  iconColor.withValues(alpha: 0.15),

              shape: BoxShape.circle,

            ),

            child: Icon(
              icon,
              color: iconColor,
            ),

          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    Expanded(
                      child: Text(

                        category,

                        style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 6),

                Text(

                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),

                ),

                const SizedBox(height: 6),

                Text(

                  description,

                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                  ),

                ),

              ],
            ),
          ),

          const SizedBox(width: 10),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(10),

            child: Image.asset(

              image,

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
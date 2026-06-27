import 'package:flutter/material.dart';
import 'main_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,

            pinned: false,
            floating: false,

            leading: IconButton(
              onPressed: () async {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.blue),
            ),

            title: const Text(
              "Menu MBG",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Center(
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(20),
    ),
    child: GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );

        if (picked != null) {
         
        }
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min, // ⭐ biar mengecil
        children: [
          Icon(
            Icons.calendar_month,
            color: Colors.blue,
            size: 16, // kecilkan icon
          ),
          SizedBox(width: 6),
          Text(
            "Hari Ini (22 Juni 2026)",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12, // kecilkan text
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.blue,
            size: 16,
          ),
        ],
      ),
    ),
  ),
),

                  const SizedBox(height: 20),

                  const Text(
                    "Menu Hari Ini",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Rabu, 18 Juni 2026",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),

                    child: Image.asset(
                      "assets/images/menu_hari_ini.jpg",
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: const [
                      MenuItem(emoji: "🍚", text: "Nasi\nPutih"),

                      MenuItem(emoji: "🍗", text: "Ayam\nKecap"),

                      MenuItem(emoji: "🥬", text: "Tumis\nSayur"),

                      MenuItem(emoji: "🍊", text: "Jeruk"),

                      MenuItem(emoji: "🥛", text: "Susu"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Card(
                    elevation: 2,

                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Informasi Gizi",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: const [
                              Gizi(
                                icon: "🔥",
                                angka: "550 kkal",
                                nama: "Kalori",
                              ),

                              Gizi(icon: "💪", angka: "25 g", nama: "Protein"),

                              Gizi(
                                icon: "🌾",
                                angka: "75 g",
                                nama: "Karbohidrat",
                              ),

                              Gizi(icon: "🧈", angka: "18 g", nama: "Lemak"),

                              Gizi(
                                icon: "🍊",
                                angka: "30 mg",
                                nama: "Vitamin C",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Manfaat Menu Ini",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          manfaat(
                            "Nasi : Sumber energi untuk aktivitas sehari-hari",
                          ),

                          manfaat("Ayam : Sumber protein untuk pertumbuhan"),

                          manfaat("Sayur : Kaya vitamin dan serat"),

                          manfaat("Jeruk : Sumber vitamin C"),

                          manfaat("Susu : Menguatkan tulang dan gigi"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 20),

                        SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            "Menu ini telah disusun sesuai kebutuhan gizi ibu hamil dan balita.",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget manfaat(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),

    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.blue, size: 18),

        const SizedBox(width: 8),

        Expanded(child: Text(text)),
      ],
    ),
  );
}

class MenuItem extends StatelessWidget {
  final String emoji;
  final String text;

  const MenuItem({super.key, required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),

        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class Gizi extends StatelessWidget {
  final String icon;
  final String angka;
  final String nama;

  const Gizi({
    super.key,
    required this.icon,
    required this.angka,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),

        Text(
          angka,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),

        Text(nama, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

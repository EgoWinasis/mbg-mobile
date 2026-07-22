import 'package:flutter/material.dart';

import '../core/storage/notification_storage.dart';

class PengaturanNotifikasiScreen extends StatefulWidget {
  const PengaturanNotifikasiScreen({super.key});

  @override
  State<PengaturanNotifikasiScreen> createState() =>
      _PengaturanNotifikasiScreenState();
}

class _PengaturanNotifikasiScreenState
    extends State<PengaturanNotifikasiScreen> {
  bool suara = true;

  bool getar = false;

  @override
  void initState() {
    super.initState();

    loadSetting();
  }

  Future<void> loadSetting() async {
    final suaraValue = await NotificationStorage.get(
      NotificationStorage.suara,
      defaultValue: true,
    );

    final getarValue = await NotificationStorage.get(
      NotificationStorage.getar,
      defaultValue: false,
    );

    setState(() {
      suara = suaraValue;

      getar = getarValue;
    });
  }

  Future<void> updateSuara(bool value) async {
    setState(() {
      suara = value;
    });

    await NotificationStorage.save(NotificationStorage.suara, value);
  }

  Future<void> updateGetar(bool value) async {
    setState(() {
      getar = value;
    });

    await NotificationStorage.save(NotificationStorage.getar, value);
  }

  Widget buildSwitchItem({
    required IconData icon,

    required String title,

    required String subtitle,

    required bool value,

    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.blue.shade50,

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          Switch(
            value: value,

            thumbColor: WidgetStateProperty.all(Colors.white),

            trackColor: WidgetStateProperty.resolveWith<Color>((states) {
              return states.contains(WidgetState.selected)
                  ? Colors.blue
                  : Colors.grey.shade400;
            }),

            onChanged: onChanged,
          ),
        ],
      ),
    );
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

                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),

                  const Expanded(
                    child: Text(
                      "Pengaturan Notifikasi",

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

              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Preferensi",

                      style: TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    buildSwitchItem(
                      icon: Icons.volume_up,

                      title: "Suara",

                      subtitle: "Aktifkan suara aplikasi",

                      value: suara,

                      onChanged: updateSuara,
                    ),

                    buildSwitchItem(
                      icon: Icons.vibration,

                      title: "Getar",

                      subtitle: "Aktifkan getaran aplikasi",

                      value: getar,

                      onChanged: updateGetar,
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

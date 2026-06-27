import 'package:flutter/material.dart';

class RiwayatItem extends StatelessWidget {
  final String tanggal;
  final String status;

  const RiwayatItem({
    super.key,
    required this.tanggal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tanggal,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(
                status == 'Diterima'
                    ? Icons.check_circle
                    : Icons.pending,
                color: status == 'Diterima'
                    ? Colors.green
                    : Colors.orange,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Diterima'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;

  final TextEditingController namaController = TextEditingController(
    text: "Siti Rahmawati",
  );

  final TextEditingController teleponController = TextEditingController(
    text: "081234567890",
  );

  final TextEditingController alamatController = TextEditingController(
    text: "Jl. Mawar No.10, Bandung",
  );

  final TextEditingController balitaController = TextEditingController(
    text: "Nama Anak - 24 Bulan",
  );

  @override
  void dispose() {
    namaController.dispose();

    teleponController.dispose();

    alamatController.dispose();

    balitaController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,

      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile berhasil diperbarui")),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // HEADER MANUAL TANPA APPBAR
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,

                      color: Colors.blue,

                      size: 28,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      "Edit Profile",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 25),

              // FOTO PROFILE
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,

                    backgroundColor: Colors.grey.shade200,

                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage("assets/images/balita.png")
                              as ImageProvider,
                  ),

                  Positioned(
                    bottom: 0,

                    right: 0,

                    child: InkWell(
                      onTap: _pickImage,

                      child: Container(
                        width: 40,

                        height: 40,

                        decoration: const BoxDecoration(
                          color: Colors.blue,

                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.camera_alt,

                          color: Colors.white,

                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildInput(
                label: "Nama Lengkap",

                icon: Icons.person,

                controller: namaController,
              ),

              _buildInput(
                label: "Nomor Telepon",

                icon: Icons.phone,

                controller: teleponController,

                keyboard: TextInputType.phone,
              ),

              _buildInput(
                label: "Alamat",

                icon: Icons.location_on,

                controller: alamatController,

                maxLines: 3,
              ),

              _buildInput(
                label: "Data Balita",

                icon: Icons.child_care,

                controller: balitaController,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: _saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    "Simpan Perubahan",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,

    required IconData icon,

    required TextEditingController controller,

    int maxLines = 1,

    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextField(
        controller: controller,

        maxLines: maxLines,

        keyboardType: keyboard,

        decoration: InputDecoration(
          labelText: label,

          prefixIcon: Icon(icon),

          filled: true,

          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

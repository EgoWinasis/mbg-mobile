import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/storage/secure_storage.dart';
import '../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService profileService = ProfileService();

  File? profileImage;

  bool loading = true;

  bool uploadingPhoto = false;

  bool saving = false;

  final namaController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final alamatController = TextEditingController();

  final nikController = TextEditingController();

  final birthDateController = TextEditingController();

  // tambahan data anak

  final childNameController = TextEditingController();

  final childBirthDateController = TextEditingController();

  String gender = "";

  String beneficiaryType = "";

  String photoUrl = "";

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  @override
  void dispose() {
    namaController.dispose();

    phoneController.dispose();

    emailController.dispose();

    alamatController.dispose();

    nikController.dispose();

    birthDateController.dispose();

    childNameController.dispose();

    childBirthDateController.dispose();

    super.dispose();
  }

  Future<void> loadUser() async {
    final user = await SecureStorage.getUser();

    if (user != null) {
      final profile = user['profile'];

      setState(() {
        namaController.text = user['name'] ?? "";

        phoneController.text = user['phone'] ?? "";

        emailController.text = user['email'] ?? "";

        if (profile != null) {
          alamatController.text = profile['address'] ?? "";

          nikController.text = profile['nik'] ?? "";

          birthDateController.text = profile['birth_date'] ?? "";

          gender = profile['gender'] ?? "";

          beneficiaryType = profile['beneficiary_type'] ?? "";

          photoUrl = profile['photo'] ?? "";

          childNameController.text = profile['child_name'] ?? "";

          childBirthDateController.text = profile['child_birth_date'] ?? "";
        }

        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,

      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      profileImage = File(image.path);
    });

    await uploadPhoto();
  }

  Future<void> uploadPhoto() async {
    if (profileImage == null) return;

    setState(() {
      uploadingPhoto = true;
    });

    try {
      await profileService.uploadPhoto(profileImage!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil berhasil diperbarui")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      setState(() {
        uploadingPhoto = false;
      });
    }
  }

  Future<void> saveProfile() async {
    setState(() {
      saving = true;
    });

    try {
      await profileService.updateProfile(
        name: namaController.text,

        phone: phoneController.text,

        email: emailController.text,

        address: alamatController.text,

        nik: nikController.text,

        birthDate: birthDateController.text,

        gender: gender,

        beneficiaryType: beneficiaryType,

        childName: childNameController.text,

        childBirthDate: childBirthDateController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile berhasil diperbarui")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      setState(() {
        saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
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

              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,

                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : const AssetImage("assets/images/balita.png")
                              as ImageProvider,
                  ),

                  Positioned(
                    right: 0,

                    bottom: 0,

                    child: InkWell(
                      onTap: uploadingPhoto ? null : pickPhoto,

                      child: Container(
                        width: 42,

                        height: 42,

                        decoration: const BoxDecoration(
                          color: Colors.blue,

                          shape: BoxShape.circle,
                        ),

                        child: uploadingPhoto
                            ? const Padding(
                                padding: EdgeInsets.all(10),

                                child: CircularProgressIndicator(
                                  color: Colors.white,

                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _input("Nama Lengkap", Icons.person, namaController),

              _input(
                "Nomor Telepon",

                Icons.phone,

                phoneController,

                keyboard: TextInputType.phone,
              ),

              _input(
                "Email",

                Icons.email,

                emailController,

                keyboard: TextInputType.emailAddress,
              ),

              _input(
                "Alamat",

                Icons.location_on,

                alamatController,

                maxLines: 3,
              ),

              _input(
                "NIK",

                Icons.badge,

                nikController,

                keyboard: TextInputType.number,
              ),

              _buildDatePicker(),

              DropdownButtonFormField<String>(
                value: gender.isEmpty ? null : gender,

                decoration: _dropdownDecoration("Jenis Kelamin", Icons.wc),

                items: [
                  

                  const DropdownMenuItem(
                    value: "female",

                    child: Text("Perempuan"),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    gender = value ?? "";
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: beneficiaryType.isEmpty ? null : beneficiaryType,

                decoration: _dropdownDecoration(
                  "Status Penerima",

                  Icons.child_care,
                ),

                items: [
                  const DropdownMenuItem(
                    value: "pregnant",

                    child: Text("Ibu Hamil"),
                  ),

                  const DropdownMenuItem(
                    value: "toddler_parent",

                    child: Text("Orang Tua Balita"),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    beneficiaryType = value ?? "";
                  });
                },
              ),

              const SizedBox(height: 16),

              if (beneficiaryType == "toddler_parent")
                _input("Nama Anak", Icons.child_care, childNameController),

              _buildChildDatePicker(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: saving ? null : saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: saving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Perubahan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextField(
        controller: birthDateController,

        readOnly: true,

        onTap: () async {
          DateTime initialDate = DateTime.now();

          if (birthDateController.text.isNotEmpty) {
            try {
              initialDate = DateTime.parse(birthDateController.text);
            } catch (_) {}
          }

          final DateTime? picked = await showDatePicker(
            context: context,

            initialDate: initialDate,

            firstDate: DateTime(1900),

            lastDate: DateTime.now(),
          );

          if (picked != null) {
            setState(() {
              birthDateController.text =
                  "${picked.year}-"
                  "${picked.month.toString().padLeft(2, '0')}-"
                  "${picked.day.toString().padLeft(2, '0')}";
            });
          }
        },

        decoration: _dropdownDecoration("Tanggal Lahir", Icons.calendar_month),
      ),
    );
  }

  Widget _buildChildDatePicker() {
    if (beneficiaryType != "toddler_parent" && beneficiaryType != "pregnant") {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextField(
        controller: childBirthDateController,

        readOnly: true,

        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,

            initialDate: DateTime.now(),

            firstDate: DateTime(1900),

            lastDate: DateTime.now(),
          );

          if (picked != null) {
            setState(() {
              childBirthDateController.text =
                  "${picked.year}-"
                  "${picked.month.toString().padLeft(2, '0')}-"
                  "${picked.day.toString().padLeft(2, '0')}";
            });
          }
        },

        decoration: _dropdownDecoration(
          beneficiaryType == "pregnant"
              ? "Tanggal Awal Kehamilan (HPHT)"
              : "Tanggal Lahir Anak",

          Icons.calendar_month,
        ),
      ),
    );
  }

  Widget _input(
    String label,

    IconData icon,

    TextEditingController controller, {

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

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(icon),

      filled: true,

      fillColor: Colors.grey.shade100,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),
    );
  }
}

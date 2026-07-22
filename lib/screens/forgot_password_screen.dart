import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController contactController = TextEditingController();

  final AuthService authService = AuthService();

  bool loading = false;

  Future<void> kirimKode() async {
    final contact = contactController.text.trim();

    if (contact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nomor HP atau email wajib diisi"),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await authService.forgotPassword(contact);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kode OTP berhasil dikirim"),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,

        MaterialPageRoute(builder: (_) => OtpScreen(contact: contact)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),

          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Widget inputContact() {
    return TextField(
      controller: contactController,

      keyboardType: TextInputType.text,

      textInputAction: TextInputAction.done,

      decoration: InputDecoration(
        labelText: "Nomor HP / Email",

        hintText: "contoh@email.com atau 08123456789",

        prefixIcon: const Icon(Icons.person_outline),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    contactController.dispose();

    super.dispose();
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
                      "Lupa Password",

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

              const SizedBox(height: 30),

              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Reset Password",

                      style: TextStyle(
                        fontSize: 26,

                        fontWeight: FontWeight.bold,

                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Masukkan nomor HP atau email "
                      "yang terdaftar untuk menerima "
                      "kode verifikasi.",

                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 28),

                    inputContact(),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Informasi",

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "• Pastikan email atau nomor HP sudah terdaftar\n"
                            "• Kode OTP akan dikirim melalui kontak tersebut\n"
                            "• Jangan berikan kode OTP kepada orang lain",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 48,

                      child: ElevatedButton(
                        onPressed: loading ? null : kirimKode,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,

                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: loading
                            ? const SizedBox(
                                height: 22,

                                width: 22,

                                child: CircularProgressIndicator(
                                  color: Colors.white,

                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Kirim Kode Verifikasi"),
                      ),
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

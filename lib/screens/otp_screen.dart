import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String contact;

  const OtpScreen({super.key, required this.contact});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  final AuthService authService = AuthService();

  bool loading = false;

  Future<void> verifikasiOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kode OTP wajib diisi"),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kode OTP harus 6 digit"),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final resetToken = await authService.verifyOtp(
        contact: widget.contact,

        otp: otp,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP berhasil diverifikasi"),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            contact: widget.contact,

            resetToken: resetToken,
          ),
        ),
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

  @override
  void dispose() {
    otpController.dispose();

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
                      "Verifikasi OTP",

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
                      "Masukkan Kode OTP",

                      style: TextStyle(
                        fontSize: 26,

                        fontWeight: FontWeight.bold,

                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Kode OTP dikirim ke ${widget.contact}",

                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: otpController,

                      keyboardType: TextInputType.number,

                      maxLength: 6,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 24,

                        letterSpacing: 8,

                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        counterText: "",

                        labelText: "Kode OTP",

                        prefixIcon: const Icon(Icons.lock_outline),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

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
                            "• Jangan berikan kode OTP kepada orang lain\n"
                            "• OTP hanya berlaku sementara\n"
                            "• Pastikan kode yang dimasukkan benar",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 48,

                      child: ElevatedButton(
                        onPressed: loading ? null : verifikasiOtp,

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
                            : const Text("Verifikasi OTP"),
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

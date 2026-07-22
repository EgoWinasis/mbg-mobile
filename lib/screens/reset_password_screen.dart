import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../core/storage/secure_storage.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String contact;

  final String resetToken;

  const ResetPasswordScreen({
    super.key,

    required this.contact,

    required this.resetToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  bool loading = false;

  Future<void> resetPassword() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua password wajib diisi"),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password minimal 8 karakter"),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Konfirmasi password tidak sama"),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await authService.resetPassword(
        contact: widget.contact,

        resetToken: widget.resetToken,

        password: passwordController.text,

        passwordConfirmation: confirmPasswordController.text,
      );

      await SecureStorage.deleteToken();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password berhasil diubah"),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,

        MaterialPageRoute(builder: (_) => const LoginScreen()),

        (route) => false,
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

  Widget inputPassword(String label, TextEditingController controller) {
    return TextField(
      controller: controller,

      obscureText: true,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: const Icon(Icons.lock_outline),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();

    confirmPasswordController.dispose();

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
                      "Reset Password",

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
                      "Buat Password Baru",

                      style: TextStyle(
                        fontSize: 26,

                        fontWeight: FontWeight.bold,

                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Buat password baru untuk akun ${widget.contact}",

                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 28),

                    inputPassword("Password Baru", passwordController),

                    const SizedBox(height: 16),

                    inputPassword(
                      "Konfirmasi Password Baru",

                      confirmPasswordController,
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
                            "Aturan Keamanan",

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "• Minimal 8 karakter\n"
                            "• Gunakan kombinasi huruf dan angka\n"
                            "• Jangan gunakan password lama",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 48,

                      child: ElevatedButton(
                        onPressed: loading ? null : resetPassword,

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
                            : const Text("Simpan Password"),
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

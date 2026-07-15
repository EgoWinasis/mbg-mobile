import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();

  int currentStep = 0;

  bool isLoading = false;

  final namaController = TextEditingController();

  final hpController = TextEditingController();

  final alamatController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  String selectedStatus = '';

  bool hidePassword = true;

  bool hideConfirmPassword = true;

  void nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await authService.register(
        name: namaController.text,

        phone: hpController.text,

        address: alamatController.text,

        beneficiaryType: selectedStatus == "Ibu Hamil"
            ? "pregnant"
            : "toddler_parent",

        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Registrasi berhasil")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildStepIndicator() {
    final labels = ["Data Diri", "Pilih Status", "Buat Password"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),

      child: Row(
        children: List.generate(
          3,

          (i) => Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: i <= currentStep ? Colors.blue : Colors.grey,

                  child: Text(
                    "${i + 1}",

                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  labels[i],

                  style: TextStyle(
                    fontSize: 11,

                    color: i <= currentStep ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stepDataDiri() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          Image.asset('assets/images/register1.png', height: 200),

          const SizedBox(height: 20),

          const Text(
            "Langkah 1 dari 3",

            style: TextStyle(
              fontSize: 18,

              fontWeight: FontWeight.bold,

              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 25),

          TextField(
            controller: namaController,

            decoration: InputDecoration(
              labelText: "Nama Lengkap",

              prefixIcon: const Icon(Icons.person),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: hpController,

            keyboardType: TextInputType.phone,

            decoration: InputDecoration(
              labelText: "Nomor HP",

              prefixIcon: const Icon(Icons.phone),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: alamatController,

            maxLines: 2,

            decoration: InputDecoration(
              labelText: "Alamat",

              prefixIcon: const Icon(Icons.location_on),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,

            height: 55,

            child: ElevatedButton(
              onPressed: () {
                if (namaController.text.isEmpty ||
                    hpController.text.isEmpty ||
                    alamatController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lengkapi data terlebih dahulu"),
                    ),
                  );

                  return;
                }

                nextStep();
              },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

              child: const Text(
                "Lanjut",

                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusCard({
    required String title,

    required String subtitle,

    required String image,
  }) {
    bool selected = selectedStatus == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedStatus = title;
          });
        },

        child: Container(
          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: selected ? Colors.blue.shade50 : Colors.white,

            borderRadius: BorderRadius.circular(20),

            border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300,

              width: 2,
            ),
          ),

          child: Column(
            children: [
              Image.asset(image, height: 100),

              const SizedBox(height: 10),

              Text(
                title,

                textAlign: TextAlign.center,

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              Text(
                subtitle,

                textAlign: TextAlign.center,

                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),

              Radio<String>(
                value: title,

                groupValue: selectedStatus,

                activeColor: Colors.blue,

                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stepStatus() {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          const Text(
            "Langkah 2 dari 3",

            style: TextStyle(
              fontSize: 18,

              fontWeight: FontWeight.bold,

              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              statusCard(
                title: "Ibu Hamil",

                subtitle: "Saya sedang mengandung",

                image: "assets/images/hamil.png",
              ),

              const SizedBox(width: 12),

              statusCard(
                title: "Orang Tua Balita",

                subtitle: "Saya memiliki anak usia 0-5 tahun",

                image: "assets/images/balita.png",
              ),
            ],
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,

            height: 55,

            child: ElevatedButton(
              onPressed: selectedStatus.isEmpty ? null : nextStep,

              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

              child: const Text(
                "Lanjut",

                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stepPassword() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          Image.asset('assets/images/password.png', height: 180),

          const SizedBox(height: 20),

          const Text(
            "Langkah 3 dari 3",

            style: TextStyle(
              fontSize: 18,

              fontWeight: FontWeight.bold,

              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: passwordController,

            obscureText: hidePassword,

            decoration: InputDecoration(
              labelText: "Password",

              prefixIcon: const Icon(Icons.lock),

              suffixIcon: IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),

                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: confirmPasswordController,

            obscureText: hideConfirmPassword,

            decoration: InputDecoration(
              labelText: "Konfirmasi Password",

              prefixIcon: const Icon(Icons.lock_outline),

              suffixIcon: IconButton(
                icon: Icon(
                  hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),

                onPressed: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,

            height: 55,

            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (passwordController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password minimal 8 karakter"),
                          ),
                        );

                        return;
                      }

                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password tidak sama")),
                        );

                        return;
                      }

                      register();
                    },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

              child: isLoading
                  ? const SizedBox(
                      width: 25,

                      height: 25,

                      child: CircularProgressIndicator(
                        color: Colors.white,

                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      "BUAT AKUN",

                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentStep == 0,

      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && currentStep > 0) {
          previousStep();
        }
      },

      child: Scaffold(
        backgroundColor: const Color(0xffF7FAF5),

        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),

                    onPressed: () {
                      if (currentStep > 0) {
                        previousStep();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Daftar Akun",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 20),

              buildStepIndicator(),

              Expanded(
                child: IndexedStack(
                  index: currentStep,

                  children: [stepDataDiri(), stepStatus(), stepPassword()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

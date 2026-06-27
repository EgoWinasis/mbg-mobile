import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 0;

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
Widget _stepCircle(int index) {
  bool active = index <= currentStep;

  return Center(
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.blue : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          "${index + 1}",
          style: TextStyle(
            color: active ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
Widget _line(int index) {
  bool active = index < currentStep;

  return Container(
    width: 40,
    height: 3,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: active ? Colors.blue : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

Widget _stepLabel(String text, int index) {
  bool active = index <= currentStep;

  return Center(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        fontWeight: active ? FontWeight.bold : FontWeight.w500,
        color: active ? Colors.blue : Colors.black54,
      ),
    ),
  );
}

 Widget buildStepIndicator() {
  final labels = [
    "Data Diri",
    "Pilih Status",
    "Buat Password",
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      children: [

        // ================= CIRCLE + LINE =================
        Row(
          children: [
            Expanded(child: _stepCircle(0)),
            _line(0),
            Expanded(child: _stepCircle(1)),
            _line(1),
            Expanded(child: _stepCircle(2)),
          ],
        ),

        const SizedBox(height: 10),

        // ================= LABEL =================
        Row(
          children: [
            Expanded(child: _stepLabel(labels[0], 0)),
            Expanded(child: _stepLabel(labels[1], 1)),
            Expanded(child: _stepLabel(labels[2], 2)),
          ],
        ),
      ],
    ),
  );
}

  Widget stepDataDiri() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Image.asset(
            'assets/images/register1.png',
            height: 200,
          ),

          const SizedBox(height: 18),

          const Text(
            "Langkah 1 dari 3",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const Text(
            "Lengkapi data diri Anda",
            style: TextStyle(
              fontSize: 12,
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
            decoration: InputDecoration(
              labelText: "Alamat",
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 10),

Container(
  width: double.infinity,
  margin: const EdgeInsets.only(top: 10),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.blue.shade50, // hijau soft
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [

      // ICON
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 102, 168, 255),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock,
          size: 18,
          color: Colors.white,
        ),
      ),

      const SizedBox(width: 10),

      // TEXT
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Data Anda aman bersama kami",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Kami menjaga kerahasiaan data pribadi Anda.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

          const SizedBox(height: 15),

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
                      content: Text(
                        "Lengkapi data terlebih dahulu",
                      ),
                    ),
                  );
                  return;
                }

                nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
  children: [

    const Spacer(),

    const Text(
      "Lanjut",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),

    const Spacer(),

    Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.blue,
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
            color: selected
                ? Colors.blue.shade50
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? Colors.blue
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Image.asset(
                image,
                height: 120,
              ),

              const SizedBox(height: 10),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            SizedBox(
  height: 32,
  child: Text(
    subtitle,
    textAlign: TextAlign.center,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 11,
      color: Colors.grey,
    ),
  ),
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
              )
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

          const Text(
            "Pilih status Anda",
             style: TextStyle(
              fontSize: 12,
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

 const SizedBox(height: 25),

Container(
  width: double.infinity,
  margin: const EdgeInsets.only(top: 10),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.blue.shade50, // hijau soft
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [

      // ICON
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 102, 168, 255),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lightbulb,
          size: 18,
          color: Colors.white,
        ),
      ),

      const SizedBox(width: 10),

      // TEXT
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih sesuai kondisi anda saat ini",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Data ini membantu kami memberikan informasi yang tepat untuk Anda.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),


         const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: selectedStatus.isEmpty
                  ? null
                  : nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Row(
  children: [

    const Spacer(),

    const Text(
      "Lanjut",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),

    const Spacer(),

    Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.blue,
      ),
    ),

  ],
),
            ),
          )
        ],
      ),
    );
  }

  Widget stepPassword() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Image.asset(
            'assets/images/password.png',
            height: 180,
          ),

          const SizedBox(height: 20),

          const Text(
            "Langkah 3 dari 3",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const Text(
            "Buat password akun Anda",
             style: TextStyle(
              fontSize: 12,
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
                  hidePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
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
                  hideConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    hideConfirmPassword =
                        !hideConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Tips Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text("• Minimal 8 karakter"),
                Text("• Kombinasi huruf dan angka"),
                Text("• Jangan gunakan tanggal lahir"),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (passwordController.text.length < 8) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password minimal 8 karakter",
                      ),
                    ),
                  );
                  return;
                }

                if (passwordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password tidak sama",
                      ),
                    ),
                  );
                  return;
                }

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Registrasi berhasil",
                    ),
                  ),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "BUAT AKUN",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
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

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                children: [

                  IconButton(
                    onPressed: () {

                      if (currentStep > 0) {

                        previousStep();

                      } else {

                        Navigator.pop(context);

                      }

                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
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


                  const SizedBox(
                    width: 48,
                  ),

                ],
              ),
            ),


            const SizedBox(height: 15),


            buildStepIndicator(),


            Expanded(

              child: IndexedStack(

                index: currentStep,

                children: [

                  stepDataDiri(),

                  stepStatus(),

                  stepPassword(),

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


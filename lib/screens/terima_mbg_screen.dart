import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';


class RiwayatMBGScreen extends StatefulWidget {
  const RiwayatMBGScreen({
    super.key,
  });

  @override
  State<RiwayatMBGScreen> createState() =>
      _RiwayatMBGScreenState();
}


class _RiwayatMBGScreenState
    extends State<RiwayatMBGScreen> {


  double _rating = 0;


  final TextEditingController _kritikController =
      TextEditingController();


  final String tanggalPenerimaan =
      "22 Juni 2026";


  File? _photo;




  @override
  void dispose() {

    _kritikController.dispose();

    super.dispose();

  }




  Widget _buildStar(int index) {

    return IconButton(

      onPressed: () {

        setState(() {

          _rating =
              index.toDouble();

        });

      },


      icon: Icon(

        Icons.star,

        size: 32,


        color:
            _rating >= index
                ? Colors.orange
                : Colors.grey,

      ),

    );

  }







  Future<void> _pickImage() async {

    try {


      final ImagePicker picker =
          ImagePicker();



      final XFile? image =
          await picker.pickImage(

        source:
            ImageSource.camera,

        imageQuality:
            95,

      );



      if (image == null) return;





      bool gpsAktif =
          await Geolocator
              .isLocationServiceEnabled();



      if (!gpsAktif) {


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
                Text(
              "Aktifkan GPS terlebih dahulu",
            ),

          ),

        );


        return;

      }





      LocationPermission izin =
          await Geolocator
              .checkPermission();




      if (izin ==
          LocationPermission.denied) {


        izin =
            await Geolocator
                .requestPermission();


      }





      if (izin ==
              LocationPermission.denied ||
          izin ==
              LocationPermission.deniedForever) {


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
                Text(
              "Izin lokasi ditolak",
            ),

          ),

        );


        return;

      }






      Position posisi =
          await Geolocator
              .getCurrentPosition(

        desiredAccuracy:
            LocationAccuracy.high,

      );





      String waktu =
          DateTime.now()
              .toString()
              .substring(
                0,
                19,
              );





      String lokasi =

          "Latitude : ${posisi.latitude}\n"
          "Longitude : ${posisi.longitude}";







      final bytes =
          await File(image.path)
              .readAsBytes();




      img.Image? foto =
          img.decodeImage(bytes);




      if (foto == null) return;




      foto =
          img.bakeOrientation(foto);







      // background watermark

      img.fillRect(

        foto,


        x1:
            0,


        y1:
            foto.height - 300,


        x2:
            foto.width,


        y2:
            foto.height,


        color:
            img.ColorRgba8(
              0,
              0,
              0,
              170,
            ),

      );







      img.drawString(
        foto,

        "SPPM MBG\n$waktu\n$lokasi",

        font: img.arial48,

        x: 40,

        y: foto.height - 240,

        color: img.ColorRgb8(255, 255, 0),
      );







      final directory =
          await getTemporaryDirectory();




      final file =
          File(

        "${directory.path}/mbg_${DateTime.now().millisecondsSinceEpoch}.jpg",

      );





      await file.writeAsBytes(

        img.encodeJpg(

          foto,

          quality:
              95,

        ),

      );






      setState(() {

        _photo =
            file;

      });





    } catch(e) {


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
              Text(
                "Error: $e",
              ),

        ),

      );


    }


  }





  void _deletePhoto(){

    setState(() {

      _photo =
          null;

    });

  }

    void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Silakan beri rating")));

      return;
    }

    if (_photo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Silakan ambil foto bukti")));

      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Berhasil disimpan")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),

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
                    "Penilaian MBG",

                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(width: 48),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.blue),

                  const SizedBox(width: 10),

                  Text(
                    "Tanggal Penerimaan: $tanggalPenerimaan",

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Rating Penerimaan",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        5,

                        (index) => _buildStar(index + 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Kritik & Saran",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _kritikController,

                    maxLines: 4,

                    decoration: InputDecoration(
                      hintText: "Tulis kritik dan saran...",

                      filled: true,

                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Bukti Foto",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: _pickImage,

                    child: Container(
                      height: 300,

                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: _photo == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Icon(
                                  Icons.camera_alt,

                                  size: 60,

                                  color: Colors.blue,
                                ),

                                SizedBox(height: 12),

                                Text("Ambil foto bukti"),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,

                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FullImagePreview(image: _photo!),
                                        ),
                                      );
                                    },

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),

                                      child: Image.file(
                                        _photo!,

                                        width: double.infinity,

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _pickImage,

                                      icon: const Icon(Icons.camera_alt),

                                      label: const Text("Retake"),
                                    ),

                                    const SizedBox(width: 10),

                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),

                                      onPressed: _deletePhoto,

                                      icon: const Icon(Icons.delete),

                                      label: const Text("Hapus"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: _submit,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Simpan",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullImagePreview extends StatelessWidget {
  final File image;

  const FullImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,

          maxScale: 5,

          child: Image.file(image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

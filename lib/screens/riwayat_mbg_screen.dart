import 'package:flutter/material.dart';


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

        size:
            32,


        color:
            _rating >= index
                ? Colors.orange
                : Colors.grey,

      ),

    );


  }




  void _submit() {


    if (_rating == 0) {


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
              Text(
            "Silakan beri rating",
          ),

        ),

      );


      return;

    }



    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content:
            Text(
          "Berhasil disimpan",
        ),

      ),

    );


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
          Colors.white,



      body:
          SafeArea(

        child:
            ListView(

          padding:
              const EdgeInsets.all(16),



          children: [



            // ==========================
            // HEADER
            // ==========================

            Row(

              children: [


                IconButton(

                  onPressed: () {

                    Navigator.pop(context);

                  },


                  icon:
                      const Icon(

                    Icons.arrow_back,

                    color:
                        Colors.blue,

                    size:
                        30,

                  ),

                ),



                const Expanded(

                  child:
                      Text(

                    "Riwayat MBG",

                    textAlign:
                        TextAlign.center,


                    style:
                        TextStyle(

                    


                      fontSize:
                          18,


                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                ),



                const SizedBox(

                  width:
                      48,

                ),



              ],

            ),




            const SizedBox(

              height:
                  25,

            ),





            // ==========================
            // TANGGAL
            // ==========================

            Container(

              padding:
                  const EdgeInsets.all(14),


              decoration:
                  BoxDecoration(

                color:
                    Colors.blue.shade50,


                borderRadius:
                    BorderRadius.circular(12),


                border:
                    Border.all(

                  color:
                      Colors.blue.shade200,

                  width:
                      1.2,

                ),

              ),



              child:
                  Row(

                children: [


                  const Icon(

                    Icons.calendar_month,

                    color:
                        Colors.blue,

                  ),



                  const SizedBox(
                    width:
                        10,

                  ),



                  Text(

                    "Tanggal Penerimaan: $tanggalPenerimaan",

                    style:
                        const TextStyle(

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),



                ],

              ),

            ),





            const SizedBox(

              height:
                  20,

            ),





            // ==========================
            // RATING
            // ==========================

            Container(

              padding:
                  const EdgeInsets.all(14),


              decoration:
                  BoxDecoration(

                color:
                    Colors.white,


                borderRadius:
                    BorderRadius.circular(12),


                border:
                    Border.all(

                  color:
                      Colors.blue.shade200,

                  width:
                      1.2,

                ),

              ),



              child:
                  Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,


                children: [


                  const Text(

                    "Rating Penerimaan",

                    style:
                        TextStyle(

                      fontSize:
                          16,


                      fontWeight:
                          FontWeight.bold,

                    ),

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



            const SizedBox(

              height:
                  20,

            ),

                        // ==========================
            // KRITIK & SARAN
            // ==========================
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200, width: 1.2),
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
                      hintText: "Tulis kritik dan saran di sini...",

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

            // ==========================
            // UPLOAD FOTO
            // ==========================
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.blue.shade200, width: 1.2),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Upload Bukti Foto",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Kamera belum aktif")),
                      );
                    },

                    child: Container(
                      height: 180,

                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,

                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                          color: Colors.blue.shade200,

                          width: 1.2,
                        ),
                      ),

                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(Icons.camera_alt, size: 45, color: Colors.blue),

                          SizedBox(height: 10),

                          Text("Tap untuk mengambil foto"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================
            // BUTTON SIMPAN
            // ==========================
            SizedBox(
              width: double.infinity,

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

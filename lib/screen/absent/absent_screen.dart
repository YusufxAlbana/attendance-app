import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_app/ui/home_screen.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({super.key});

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  // Daftar kategori izin (untuk dropdown)
  var categoriesList = <String>[
    "Pilih kategori izin:",
    "Sakit",
    "Izin Pribadi",
    "Cuti Tahunan",
    "Others",
  ];
  String dropValueCategories = "Pilih kategori izin:";
  // -----------------------------------------------------------

  final controllerName = TextEditingController();
  // Controller ini khusus untuk detail alasan/deskripsi manual
  final controllerDescription = TextEditingController(); 

  double dLat = 0.0, dLong = 0.0;
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  int dateHours = 0, dateMinutes = 0;
  final fromController = TextEditingController();
  String strAlamat = '', strDate = '', strTime = '', strDateTime = '';
  final toController = TextEditingController();

  DateTime? _tryParseDate(String s) {
    try {
      return DateFormat('dd/M/yyyy').parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fromController.text = DateFormat('dd/M/yyyy').format(DateTime.now());
  }

  // Menampilkan dialog loading
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text("Loading..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Mengirim data perizinan ke Firebase
  Future<void> submitAbsen(
    String nama,
    String kategori, 
    String deskripsi, // Deskripsi detail
    String from,
    String until,
  ) async {
    final String descriptionValue = deskripsi.trim();

    // Validasi input sebelum mengirim ke Firebase
    if (nama.isEmpty ||
        kategori == "Pilih kategori izin:" || // Cek apakah kategori sudah dipilih
        from.isEmpty ||
        until.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Pastikan Nama, Kategori, dan tanggal sudah diisi!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final fromDate = _tryParseDate(from);
    final untilDate = _tryParseDate(until);
    if (fromDate != null && untilDate != null && untilDate.isBefore(fromDate.add(const Duration(days: 1)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Tanggal selesai minimal besok atau seterusnya!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Menampilkan loader
    showLoaderDialog(context);

    try {
      await dataCollection.add({
        'address': '-',
        'name': nama,
        'category': kategori,
        'description': descriptionValue,
        'datetime': '$from - $until',
        'created_at': FieldValue.serverTimestamp(),
      });

      // Tutup loader sebelum menampilkan pesan sukses
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Izin berhasil dikirim!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Kembali ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      // Jika terjadi error, tutup loader
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "terjadi kesalahan: $e",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // theme colors (same as home)
    const Color primary1 = Color(0xFF2563EB);
    const Color primary2 = Color(0xFF0EA5E9);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primary1, primary2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: primary1.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Permission Request Menu',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                          gradient: LinearGradient(colors: [primary1, primary2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.maps_home_work_outlined, color: Colors.white),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Isi Form Izin!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              // --- Bagian 1: Nama ---
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Nama",
                    hintText: "Masukkan nama",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
              ),
              
              // --- Bagian 2: Kategori (Dropdown) ---
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Kategori Izin", 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF2563EB),
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    value: dropValueCategories,
                    onChanged: (value) {
                      setState(() {
                        dropValueCategories = value.toString();
                      });
                    },
                    items: categoriesList.map((value) {
                      return DropdownMenuItem(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    underline: Container(height: 2, color: Colors.transparent),
                    isExpanded: true,
                  ),
                ),
              ),

              // --- Bagian 3: Deskripsi Detail (Text Field Manual) ---
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Deskripsi (Opsional)", 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: TextField(
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  controller: controllerDescription, 
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "Tuliskan alasan perizinan.", 
                    hintText: "Cth: Demam tinggi, harus ke dokter, atau menghadiri acara keluarga.",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
              ),
              // -------------------------------------

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "dari: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              controller: fromController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Tanggal mulai (hari ini)",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "sampai: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                final fromDate = _tryParseDate(fromController.text);
                                final minUntilDate = (fromDate ?? DateTime.now()).add(const Duration(days: 1));
                                DateTime? pickedDate = await showDatePicker(
                                  builder: (
                                    BuildContext context,
                                    Widget? child,
                                  ) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                          primary: Color(0xFF2563EB),
                                        ),
                                        datePickerTheme:
                                            const DatePickerThemeData(
                                              headerBackgroundColor:
                                                  Color(0xFF2563EB),
                                              backgroundColor: Colors.white,
                                              headerForegroundColor:
                                                  Colors.white,
                                              surfaceTintColor: Colors.white,
                                            ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  context: context,
                                  initialDate: minUntilDate,
                                  firstDate: minUntilDate,
                                  lastDate: DateTime(9999),
                                );
                                if (pickedDate != null) {
                                  toController.text = DateFormat(
                                    'dd/M/yyyy',
                                  ).format(pickedDate);
                                }
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              controller: toController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Masukkan tanggal selesai izin",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF2563EB),
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (controllerName.text.isEmpty ||
                              dropValueCategories == "Pilih kategori izin:" ||
                              fromController.text.isEmpty ||
                              toController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Ups, pastikan Nama, Kategori, dan tanggal sudah diisi!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                backgroundColor: Color(0xFF2563EB),
                                shape: StadiumBorder(),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            final fromDate = _tryParseDate(fromController.text);
                            final untilDate = _tryParseDate(toController.text);
                            final minUntil = fromDate?.add(const Duration(days: 1));
                            if (minUntil != null && untilDate != null && untilDate.isBefore(minUntil)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Tanggal selesai minimal besok atau seterusnya!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            submitAbsen(
                              controllerName.text.toString(),
                              dropValueCategories.toString(), // Mengirim Kategori
                              controllerDescription.text.toString(), // Mengirim Deskripsi Detail
                              fromController.text,
                              toController.text,
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            "buat perizinan!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )])));
  }
}
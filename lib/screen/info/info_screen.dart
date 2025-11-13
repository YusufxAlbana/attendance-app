import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary1 = Color(0xFF667EEA);
    const Color primary2 = Color(0xFF764BA2);
    return Scaffold(
      backgroundColor: const Color.fromARGB(106, 248, 249, 250),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary1, primary2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary1.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
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
                      'App Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Attendance App',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Aplikasi pencatat kehadiran digital yang dirancang untuk memudahkan pengguna dalam memantau absensi secara cepat, akurat, dan efisien. Dilengkapi dengan fitur deteksi wajah serta pencatatan waktu otomatis untuk memastikan kehadiran tercatat secara valid.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '1.0.0 (Stable Release)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Versi awal aplikasi dengan fitur utama: absensi harian, riwayat kehadiran, dan deteksi wajah menggunakan kamera perangkat.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Deskripsi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '''Attendance App membantu instansi, sekolah, dan perusahaan dalam mengelola data kehadiran tanpa perlu proses manual.
Beberapa fitur utama:

📸 Absensi Otomatis dengan Deteksi Wajah

📅 Riwayat Kehadiran Lengkap

🔔 Notifikasi Pengingat Kehadiran

☁️ Sinkronisasi Data ke Cloud

Aplikasi ini dibangun menggunakan Flutter dengan antarmuka yang ringan, modern, dan mudah digunakan.''',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Kontak',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '''Kontak

Jika ada pertanyaan, saran, atau laporan bug, silakan hubungi:
📧 attendance.support@gmail.com

🌐 https://attendance-app.com
 (opsional kalau kamu punya domainnya)''',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Ketentuan Penggunaan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '''Dengan menggunakan Attendance App, pengguna setuju untuk:

Menggunakan aplikasi hanya untuk tujuan yang sah.

Tidak memanipulasi data kehadiran atau menyalahgunakan sistem.

Memberikan izin akses kamera hanya untuk keperluan deteksi wajah.

Data kehadiran pengguna akan disimpan secara aman dan tidak dibagikan kepada pihak ketiga tanpa persetujuan.''',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
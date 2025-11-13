🏢 Attendance App

Attendance App adalah aplikasi berbasis Flutter yang dirancang untuk membantu perusahaan dalam memantau dan mengelola absensi karyawan secara efisien.
Aplikasi ini terintegrasi dengan Firebase untuk memastikan penyimpanan data yang aman, sinkronisasi real-time, serta kemudahan akses bagi pengguna.

🎯 Tujuan

Aplikasi ini dibuat untuk mempermudah proses pencatatan kehadiran karyawan di lingkungan kantor, menggantikan sistem manual menjadi sistem digital yang lebih praktis dan akurat.

⚙️ Fitur Utama

Absen Masuk: Karyawan dapat melakukan pencatatan kehadiran langsung melalui aplikasi.

Izin Tidak Masuk: Fitur untuk mengajukan izin jika karyawan berhalangan hadir.

Riwayat Kehadiran: Menampilkan data lengkap mengenai kehadiran dan izin karyawan.

🧩 Teknologi yang Digunakan

Flutter: Framework utama untuk pengembangan aplikasi lintas platform (Android & iOS).

Firebase: Digunakan untuk autentikasi pengguna, penyimpanan data, serta pengelolaan database secara real-time.

👥 Target Pengguna

Aplikasi ini ditujukan untuk perusahaan dan karyawan, khususnya dalam meningkatkan efisiensi serta transparansi proses absensi di tempat kerja.

🚀 Cara Menjalankan Proyek

Ikuti langkah-langkah berikut untuk menjalankan aplikasi:

Pastikan Flutter sudah terinstal.
Jalankan perintah berikut di terminal untuk memastikan:

flutter --version


Clone repositori ini:

git clone https://github.com/username/attendance_app.git
cd attendance_app


Instal semua dependency yang diperlukan:

flutter pub get


Hubungkan proyek ke Firebase:

Buka Firebase Console

Tambahkan aplikasi baru (Android/iOS)

Unduh file google-services.json (Android) atau GoogleService-Info.plist (iOS)

Letakkan file tersebut di folder yang sesuai (android/app/ atau ios/Runner/)

Jalankan aplikasi:

flutter run

📄 Lisensi

Proyek ini dibuat untuk tujuan pembelajaran dan pengembangan internal perusahaan.
Tidak untuk diperjualbelikan tanpa izin pengembang.

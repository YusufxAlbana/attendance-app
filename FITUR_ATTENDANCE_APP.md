# Fitur Attendance App

## ✅ Fitur yang Sudah Ditambahkan

### 1. Login / Authentication
- **Login Screen** dengan validasi form
  - Email format validation (regex)
  - Password minimal 6 karakter
  - Error handling untuk Firebase Auth
- **Register Screen** untuk membuat akun baru
  - Validasi nama minimal 3 karakter
  - Validasi email format
  - Validasi password minimal 6 karakter
  - Konfirmasi password harus cocok
- **Firebase Authentication** terintegrasi
- **Auto-login** jika user sudah login sebelumnya
- **Logout** dengan konfirmasi dialog

### 2. State Management
- **Provider** untuk state management
- **AuthProvider** untuk mengelola authentication state
  - Login status
  - User data
  - Loading state
  - Error messages
- **AttendanceProvider** untuk mengelola attendance data
  - Local attendance list
  - Check-in validation (tidak bisa check-in 2x sehari)
  - Sync dengan Firebase

### 3. Local Data Storage
- **SharedPreferences** untuk menyimpan data lokal
  - Login status
  - User email
  - Attendance history (JSON format)
- Data tetap ada meskipun aplikasi ditutup
- Auto-sync dengan Firebase saat online

### 4. Input Kehadiran (Check-in / Check-out)
- **Attend Screen** dengan:
  - Tombol untuk attendance
  - Timestamp otomatis
  - Validasi tidak bisa check-in 2x sehari
  - Face detection (sudah ada)
  - Location tracking (sudah ada)

### 5. Riwayat Kehadiran
- **Attendance History Screen** dengan:
  - Daftar kehadiran yang tersimpan
  - Menampilkan tanggal, jam, status
  - Data dari local storage + Firebase

### 6. Form Validation
- **Login Form**:
  - Email format benar (regex validation)
  - Password tidak kosong (min 6 karakter)
- **Register Form**:
  - Nama minimal 3 karakter
  - Email format valid
  - Password minimal 6 karakter
  - Konfirmasi password cocok
- **Attendance Form**:
  - User harus login dulu
  - Tidak bisa check-in 2x sehari
  - Validasi lokasi dan foto

### 7. UI/UX Improvements
- **Splash Screen** dengan animasi keren
  - Floating bubbles
  - Wave effect
  - Rotating shapes
  - Shimmer text
- **Gradient Design** konsisten di semua halaman
- **Loading Indicators** saat proses async
- **Error Messages** yang informatif
- **Responsive Design** untuk berbagai ukuran layar

## 📱 Cara Menggunakan

### Pertama Kali
1. Jalankan aplikasi
2. Splash screen akan muncul
3. Jika belum login, akan diarahkan ke Login Screen
4. Klik "Daftar" untuk membuat akun baru
5. Isi form registrasi dan klik "Daftar"
6. Login dengan akun yang baru dibuat

### Setelah Login
1. Home Screen menampilkan menu utama
2. Klik "Attendance Record" untuk check-in
3. Ambil foto dan lokasi akan terdeteksi otomatis
4. Data tersimpan di local storage dan Firebase
5. Lihat riwayat di "Attendance History"

### Logout
1. Klik icon logout di header Home Screen
2. Konfirmasi logout
3. Akan kembali ke Login Screen

## 🔧 Technical Stack

- **Flutter** - Framework
- **Firebase Auth** - Authentication
- **Cloud Firestore** - Database
- **SharedPreferences** - Local Storage
- **Provider** - State Management
- **Camera** - Face Detection
- **Geolocator** - Location Tracking
- **Intl** - Date/Time Formatting

## 📝 Catatan

- Data attendance disimpan secara lokal dan di-sync ke Firebase
- User tidak bisa check-in 2x dalam sehari yang sama
- Semua form memiliki validasi yang ketat
- Error handling sudah diterapkan di semua fitur

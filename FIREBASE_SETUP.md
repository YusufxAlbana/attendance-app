# Setup Firebase Authentication & Firestore

## ✅ Fitur yang Sudah Diimplementasi

### 1. Firebase Authentication
- **Register** dengan `createUserWithEmailAndPassword`
- **Login** dengan `signInWithEmailAndPassword`
- **Logout** dengan `signOut`
- **Auto-login** jika user sudah login sebelumnya
- **Error handling** lengkap untuk semua kasus

### 2. Firestore Integration
Setelah registrasi berhasil, data user disimpan ke Firestore:
- **Collection**: `users`
- **Document ID**: `{uid}` (dari Firebase Auth)
- **Fields**:
  - `uid`: String (User ID dari Firebase Auth)
  - `name`: String (Nama lengkap user)
  - `email`: String (Email user)
  - `createdAt`: Timestamp (Waktu registrasi)

### 3. Validasi Form
- **Email**: Format email valid (regex)
- **Password**: Minimal 6 karakter
- **Nama**: Minimal 3 karakter
- **Konfirmasi Password**: Harus sama dengan password

### 4. State Management
- **FirebaseAuthProvider** mengelola:
  - Authentication state
  - User data dari Firestore
  - Loading state
  - Error messages
  - Local storage (SharedPreferences)

## 🔧 Cara Setup Firebase

### 1. Aktifkan Firebase Authentication
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda: `attendance-app-afcb3`
3. Klik **Authentication** di menu kiri
4. Klik tab **Sign-in method**
5. Aktifkan **Email/Password**:
   - Klik pada "Email/Password"
   - Toggle "Enable" menjadi ON
   - Klik "Save"

### 2. Aktifkan Cloud Firestore
1. Di Firebase Console, klik **Firestore Database**
2. Klik **Create database**
3. Pilih mode:
   - **Test mode** (untuk development) - data bisa diakses siapa saja
   - **Production mode** (untuk production) - perlu atur rules
4. Pilih lokasi server (pilih yang terdekat, misal: `asia-southeast1`)
5. Klik **Enable**

### 3. Atur Firestore Security Rules (Opsional)
Untuk keamanan yang lebih baik, atur rules di Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - hanya user yang login bisa baca/tulis data sendiri
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Attendance collection - hanya user yang login bisa akses
    match /attendance/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📱 Cara Menggunakan Aplikasi

### Registrasi User Baru
1. Jalankan aplikasi
2. Klik **"Daftar"** di halaman login
3. Isi form:
   - Nama Lengkap (min 3 karakter)
   - Email (format valid)
   - Password (min 6 karakter)
   - Konfirmasi Password
4. Klik **"Daftar"**
5. Jika berhasil, akan muncul notifikasi sukses
6. Data user akan tersimpan di:
   - Firebase Authentication
   - Firestore collection `users/{uid}`
   - Local storage (SharedPreferences)

### Login
1. Di halaman login, masukkan:
   - Email yang sudah terdaftar
   - Password
2. Klik **"Login"**
3. Jika berhasil, akan diarahkan ke Home Screen

### Logout
1. Di Home Screen, klik icon **logout** di header
2. Konfirmasi logout
3. Akan kembali ke Login Screen

## 🔍 Cek Data di Firebase Console

### Melihat User yang Terdaftar
1. Buka Firebase Console
2. Klik **Authentication**
3. Tab **Users** - lihat semua user yang terdaftar

### Melihat Data di Firestore
1. Buka Firebase Console
2. Klik **Firestore Database**
3. Lihat collection **users**
4. Klik document dengan ID = UID user
5. Lihat data: `uid`, `name`, `email`, `createdAt`

## ⚠️ Troubleshooting

### Error: "operation-not-allowed"
**Solusi**: Aktifkan Email/Password di Firebase Authentication

### Error: "permission-denied" di Firestore
**Solusi**: 
- Pastikan Firestore sudah dibuat
- Cek Firestore Rules, pastikan user bisa write ke collection `users`

### Error: "network-request-failed"
**Solusi**: 
- Cek koneksi internet
- Pastikan Firebase sudah terkonfigurasi dengan benar

### User tidak bisa login setelah registrasi
**Solusi**: 
- Cek di Firebase Console > Authentication apakah user sudah terdaftar
- Pastikan password yang dimasukkan benar (min 6 karakter)

## 📊 Struktur Data Firestore

```
users (collection)
  └── {uid} (document)
      ├── uid: "abc123..."
      ├── name: "John Doe"
      ├── email: "john@example.com"
      └── createdAt: Timestamp(2025-01-18 10:30:00)

attendance (collection)
  └── {documentId} (document)
      ├── userId: "abc123..."
      ├── name: "John Doe"
      ├── date: "2025-01-18"
      ├── time: "10:30:00"
      ├── location: "..."
      └── status: "Attend"
```

## 🎯 Fitur Tambahan yang Bisa Ditambahkan

1. **Email Verification** - Verifikasi email setelah registrasi
2. **Reset Password** - Lupa password via email
3. **Update Profile** - Edit nama dan foto profil
4. **Delete Account** - Hapus akun user
5. **Social Login** - Login dengan Google/Facebook

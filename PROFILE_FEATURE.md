# Fitur Profil User

## ✅ Fitur yang Sudah Ditambahkan

### 1. Halaman Profil
- **Akses**: Tombol profil (icon person) di kanan atas Home Screen
- **Tampilan**:
  - Avatar/Foto profil (bisa diubah)
  - Email (read-only)
  - Nama lengkap (editable)
  - Password (editable)
  - Tombol Logout

### 2. Edit Avatar/Foto Profil
- **Pilih dari Kamera**: Ambil foto langsung dari kamera
- **Pilih dari Galeri**: Pilih foto dari galeri
- **Fitur**:
  - Auto resize ke 512x512 px
  - Kompresi gambar (quality 75%)
  - Preview foto sebelum disimpan
  - Icon kamera di pojok kanan bawah avatar

### 3. Edit Nama
- **Cara Edit**:
  1. Klik icon edit di samping nama
  2. Masukkan nama baru (min 3 karakter)
  3. Klik "Simpan" atau "Batal"
- **Validasi**:
  - Nama tidak boleh kosong
  - Minimal 3 karakter
- **Update ke**:
  - Firebase Auth (displayName)
  - Firestore (collection users)
  - Local state

### 4. Edit Password
- **Cara Edit**:
  1. Klik icon edit di samping password
  2. Masukkan password lama
  3. Masukkan password baru (min 6 karakter)
  4. Konfirmasi password baru
  5. Klik "Simpan" atau "Batal"
- **Validasi**:
  - Password lama harus benar
  - Password baru minimal 6 karakter
  - Konfirmasi password harus cocok
- **Security**:
  - Re-authentication sebelum update
  - Password di-hash oleh Firebase

### 5. Logout
- **Cara Logout**:
  1. Klik tombol "Logout" di bawah
  2. Konfirmasi logout
  3. Akan kembali ke Login Screen
- **Proses**:
  - Sign out dari Firebase Auth
  - Clear local storage
  - Clear state

## 🎨 UI/UX Features

### Design
- **Modern Card Design** dengan shadow
- **Icon dengan background** untuk setiap field
- **Inline Editing** - edit langsung di card
- **Responsive Layout** - menyesuaikan ukuran layar
- **Loading Indicators** saat proses update
- **Success/Error Messages** dengan SnackBar

### User Experience
- **Easy Navigation** - back button di header
- **Visual Feedback** - icon edit yang jelas
- **Confirmation Dialogs** - untuk aksi penting (logout)
- **Form Validation** - real-time validation
- **Password Visibility Toggle** - show/hide password

## 📱 Cara Menggunakan

### Akses Halaman Profil
1. Di Home Screen, klik icon **person** di kanan atas
2. Halaman profil akan terbuka

### Ubah Foto Profil
1. Klik pada avatar/foto profil
2. Pilih "Ambil dari Kamera" atau "Pilih dari Galeri"
3. Ambil/pilih foto
4. Foto akan langsung ter-preview
5. (Opsional) Upload ke Firebase Storage untuk persistent storage

### Ubah Nama
1. Klik icon **edit** di samping nama
2. Masukkan nama baru
3. Klik **"Simpan"** untuk menyimpan atau **"Batal"** untuk membatalkan
4. Jika berhasil, akan muncul notifikasi sukses

### Ubah Password
1. Klik icon **edit** di samping password
2. Masukkan password lama
3. Masukkan password baru (min 6 karakter)
4. Konfirmasi password baru
5. Klik **"Simpan"** untuk menyimpan atau **"Batal"** untuk membatalkan
6. Jika berhasil, akan muncul notifikasi sukses

### Logout
1. Scroll ke bawah
2. Klik tombol **"Logout"** (merah)
3. Konfirmasi logout
4. Akan kembali ke Login Screen

## 🔧 Technical Implementation

### FirebaseAuthProvider Methods

#### updateProfile()
```dart
Future<bool> updateProfile({String? name, String? photoUrl})
```
- Update display name di Firebase Auth
- Update photo URL di Firebase Auth
- Update data di Firestore collection `users/{uid}`
- Update local state

#### updatePassword()
```dart
Future<bool> updatePassword({
  required String currentPassword,
  required String newPassword,
})
```
- Re-authenticate user dengan password lama
- Update password di Firebase Auth
- Error handling untuk berbagai kasus

### Data Structure

#### Firestore: users/{uid}
```json
{
  "uid": "abc123...",
  "name": "John Doe",
  "email": "john@example.com",
  "photoUrl": "https://...",
  "createdAt": Timestamp
}
```

#### Local State (SharedPreferences)
```
- isLoggedIn: bool
- userEmail: String
- userId: String
```

## ⚠️ Error Handling

### Update Nama
- **"Nama tidak boleh kosong"** - Nama harus diisi
- **"Nama minimal 3 karakter"** - Nama terlalu pendek
- **"Gagal update nama"** - Error dari Firebase

### Update Password
- **"Password lama salah"** - Password lama tidak cocok
- **"Password baru terlalu lemah"** - Password < 6 karakter
- **"Password tidak cocok"** - Konfirmasi password salah
- **"Silakan login ulang"** - Session expired, perlu re-login

## 🎯 Fitur Tambahan yang Bisa Ditambahkan

1. **Upload Foto ke Firebase Storage**
   - Simpan foto di Firebase Storage
   - Dapatkan URL foto
   - Simpan URL ke Firestore

2. **Email Verification**
   - Kirim email verifikasi
   - Cek status verifikasi
   - Badge "Verified" di profil

3. **Two-Factor Authentication**
   - Setup 2FA dengan phone number
   - Verify dengan OTP

4. **Account Deletion**
   - Hapus akun user
   - Hapus semua data terkait

5. **Profile Completion**
   - Progress bar untuk kelengkapan profil
   - Reminder untuk melengkapi profil

6. **Social Links**
   - Tambah link social media
   - Phone number
   - Address

## 📊 User Flow

```
Home Screen
    ↓ (klik icon person)
Profile Screen
    ├─→ Edit Avatar → Camera/Gallery → Preview → Save
    ├─→ Edit Name → Input → Validate → Save → Update Firebase
    ├─→ Edit Password → Input Old/New → Validate → Re-auth → Save
    └─→ Logout → Confirm → Sign Out → Login Screen
```

## 🔐 Security Features

1. **Re-authentication** sebelum update password
2. **Password validation** (min 6 karakter)
3. **Confirmation dialog** untuk logout
4. **Error messages** yang informatif tapi tidak expose sensitive info
5. **Local storage** di-clear saat logout

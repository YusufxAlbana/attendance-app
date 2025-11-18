import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  FirebaseAuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _loadUserData();
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;
    
    try {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _userData = doc.data();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create user with Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;

      if (_user != null) {
        // Save user data to Firestore
        final userData = {
          'uid': _user!.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(_user!.uid).set(userData);

        // Update display name
        await _user!.updateDisplayName(name);

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userId', _user!.uid);

        _userData = userData;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'weak-password':
          _errorMessage = 'Password terlalu lemah. Minimal 6 karakter.';
          break;
        case 'email-already-in-use':
          _errorMessage = 'Email sudah terdaftar. Silakan login.';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid.';
          break;
        case 'operation-not-allowed':
          _errorMessage = 'Registrasi tidak diizinkan. Hubungi admin.';
          break;
        default:
          _errorMessage = 'Registrasi gagal: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Sign in with Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;

      if (_user != null) {
        // Load user data from Firestore
        await _loadUserData();

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userId', _user!.uid);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Email tidak ditemukan. Silakan registrasi.';
          break;
        case 'wrong-password':
          _errorMessage = 'Password salah. Coba lagi.';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid.';
          break;
        case 'user-disabled':
          _errorMessage = 'Akun dinonaktifkan. Hubungi admin.';
          break;
        case 'too-many-requests':
          _errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti.';
          break;
        default:
          _errorMessage = 'Login gagal: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _userData = null;
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userEmail');
      await prefs.remove('userId');
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout gagal: $e';
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Email tidak ditemukan.';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid.';
          break;
        default:
          _errorMessage = 'Gagal mengirim email reset: ${e.message}';
      }
      
      notifyListeners();
    }
  }

  Future<bool> updateProfile({String? name, String? photoUrl}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_user == null) {
        _isLoading = false;
        _errorMessage = 'User tidak ditemukan';
        notifyListeners();
        return false;
      }

      // Update display name if provided
      if (name != null) {
        await _user!.updateDisplayName(name);
      }

      // Update photo URL if provided
      if (photoUrl != null) {
        await _user!.updatePhotoURL(photoUrl);
      }

      // Update Firestore
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(_user!.uid).update(updates);
        
        // Update local userData
        if (_userData != null) {
          _userData = {..._userData!, ...updates};
        }
      }

      // Reload user
      await _user!.reload();
      _user = _auth.currentUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal update profil: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_user == null || _user!.email == null) {
        _isLoading = false;
        _errorMessage = 'User tidak ditemukan';
        notifyListeners();
        return false;
      }

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: currentPassword,
      );

      await _user!.reauthenticateWithCredential(credential);

      // Update password
      await _user!.updatePassword(newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'wrong-password':
          _errorMessage = 'Password lama salah';
          break;
        case 'weak-password':
          _errorMessage = 'Password baru terlalu lemah';
          break;
        case 'requires-recent-login':
          _errorMessage = 'Silakan login ulang untuk mengubah password';
          break;
        default:
          _errorMessage = 'Gagal update password: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

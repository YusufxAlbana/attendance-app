import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalAuthProvider with ChangeNotifier {
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get user => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  LocalAuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('currentUser');
    if (userJson != null) {
      _currentUser = json.decode(userJson);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '{}';
      final Map<String, dynamic> users = json.decode(usersJson);

      if (!users.containsKey(email)) {
        _isLoading = false;
        _errorMessage = 'Email tidak ditemukan';
        notifyListeners();
        return false;
      }

      final userData = users[email];
      if (userData['password'] != password) {
        _isLoading = false;
        _errorMessage = 'Password salah';
        notifyListeners();
        return false;
      }

      _currentUser = {
        'email': email,
        'name': userData['name'],
      };

      await prefs.setString('currentUser', json.encode(_currentUser));
      await prefs.setBool('isLoggedIn', true);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('users') ?? '{}';
      final Map<String, dynamic> users = json.decode(usersJson);

      if (users.containsKey(email)) {
        _isLoading = false;
        _errorMessage = 'Email sudah terdaftar';
        notifyListeners();
        return false;
      }

      users[email] = {
        'password': password,
        'name': name,
      };

      await prefs.setString('users', json.encode(users));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    await prefs.remove('isLoggedIn');
    
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

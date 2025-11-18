import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class AttendanceProvider with ChangeNotifier {
  List<Map<String, dynamic>> _localAttendances = [];
  bool _hasCheckedInToday = false;

  List<Map<String, dynamic>> get localAttendances => _localAttendances;
  bool get hasCheckedInToday => _hasCheckedInToday;

  AttendanceProvider() {
    loadLocalAttendances();
  }

  Future<void> loadLocalAttendances() async {
    final prefs = await SharedPreferences.getInstance();
    final String? attendancesJson = prefs.getString('attendances');
    
    if (attendancesJson != null) {
      final List<dynamic> decoded = json.decode(attendancesJson);
      _localAttendances = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    _checkTodayAttendance();
    notifyListeners();
  }

  void _checkTodayAttendance() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _hasCheckedInToday = _localAttendances.any((attendance) {
      final attendanceDate = DateTime.parse(attendance['date']);
      final attendanceDay = DateTime(
        attendanceDate.year,
        attendanceDate.month,
        attendanceDate.day,
      );
      return attendanceDay == today;
    });
  }

  Future<bool> saveAttendance(Map<String, dynamic> attendance) async {
    if (_hasCheckedInToday) {
      return false;
    }

    try {
      // Save to local storage
      _localAttendances.insert(0, attendance);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('attendances', json.encode(_localAttendances));

      _hasCheckedInToday = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error saving attendance: $e');
      return false;
    }
  }

  Future<void> syncWithFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      
      for (var attendance in _localAttendances) {
        if (attendance['synced'] != true) {
          await firestore.collection('attendance').add(attendance);
          attendance['synced'] = true;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('attendances', json.encode(_localAttendances));
      notifyListeners();
    } catch (e) {
      print('Error syncing with Firebase: $e');
    }
  }

  Future<void> clearLocalData() async {
    _localAttendances.clear();
    _hasCheckedInToday = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('attendances');
    
    notifyListeners();
  }
}

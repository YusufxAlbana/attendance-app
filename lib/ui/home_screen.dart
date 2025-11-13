import 'package:flutter/material.dart';
import 'package:attendance_app/screen/absent/absent_screen.dart';
import 'package:attendance_app/screen/attend/attend_screen.dart';
import 'package:attendance_app/screen/attendance_history/attendance_history.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive sizes
    final double screenW = MediaQuery.of(context).size.width;
    final double headerFontSize = screenW < 360 ? 20 : (screenW < 420 ? 22 : 24);
    final double subtitleFontSize = screenW < 360 ? 12 : 13;
    final double headerVerticalPadding = screenW < 360 ? 14 : 18;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with Gradient (full width)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: headerVerticalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Attendance System",
                    style: TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Welcome to Admin Panel",
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: const Color(0xFFE0E0FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Content - three main cards expand to fill available space between header and footer
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Attendance Record Card (top)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AttendScreen(),
                                  ),
                                );
                              },
                              child: _buildMenuCard(
                                imageAsset: 'assets/images/ic_absen.png',
                                title: "Attendance Record",
                                subtitle: "Record your attendance",
                                color: const Color(0xFF667EEA),
                                lightColor: const Color(0xFFEFF0FF),
                              ),
                            ),
                          ),
                        ),

                        // Permission Card (middle)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AbsentScreen(),
                                  ),
                                );
                              },
                              child: _buildMenuCard(
                                imageAsset: 'assets/images/ic_leave.png',
                                title: "Permission",
                                subtitle: "Request leave or permission",
                                color: const Color(0xFFF093FB),
                                lightColor: const Color(0xFFFFF5FE),
                              ),
                            ),
                          ),
                        ),

                        // Attendance History Card (bottom)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendanceHistoryScreen(),
                                  ),
                                );
                              },
                              child: _buildMenuCard(
                                imageAsset: 'assets/images/ic_history.png',
                                title: "Attendance History",
                                subtitle: "View attendance records",
                                color: const Color(0xFF4FACFE),
                                lightColor: const Color(0xFFEFF7FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Modern Footer
            // Modern Footer (full width)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "IDN Boarding School Solo",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "© 2025 - All rights reserved",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    String? imageAsset,
    IconData? icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color lightColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              lightColor,
              lightColor.withOpacity(0.5),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset,
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon ?? Icons.circle,
                      size: 28,
                      color: Colors.white,
                    ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
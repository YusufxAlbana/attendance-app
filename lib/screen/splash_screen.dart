import 'dart:async';
import 'package:flutter/material.dart';
import 'package:attendance_app/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _bubbleController;
  late AnimationController _waveController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Scale animation controller
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Shimmer animation controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Bubble animation controller
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _shimmerController.repeat();
    _bubbleController.repeat();
    _waveController.repeat();

    // Navigate to home after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    _bubbleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2563EB),
              Color(0xFF0EA5E9),
              Color(0xFF22D3EE),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated wave background
            ...List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  final double screenHeight =
                      MediaQuery.of(context).size.height;
                  final double screenWidth = MediaQuery.of(context).size.width;
                  return Positioned(
                    bottom: -100 + (index * 80.0),
                    left: -screenWidth +
                        (_waveController.value * screenWidth * 2),
                    child: Opacity(
                      opacity: 0.08 - (index * 0.02),
                      child: Container(
                        width: screenWidth * 2,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Floating bubbles
            ...List.generate(8, (index) {
              return AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, child) {
                  final double screenHeight =
                      MediaQuery.of(context).size.height;
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double size = 40 + (index * 15.0);
                  final double startX = (index * 50.0) % screenWidth;
                  final double progress = (_bubbleController.value +
                          (index * 0.15)) %
                      1.0;

                  return Positioned(
                    left: startX + (progress * 50 - 25),
                    bottom: -size + (progress * (screenHeight + size)),
                    child: Opacity(
                      opacity: (0.15 - (progress * 0.15)).clamp(0.0, 0.15),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Rotating geometric shapes
            ...List.generate(4, (index) {
              return AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  final double screenHeight =
                      MediaQuery.of(context).size.height;
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double angle = _shimmerController.value * 6.28 +
                      (index * 1.57); // 2π rotation

                  return Positioned(
                    top: screenHeight * 0.2 + (index * screenHeight * 0.2),
                    right: -30 +
                        (_shimmerController.value * 60) +
                        (index * 20.0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Opacity(
                        opacity: 0.06,
                        child: Container(
                          width: 60 + (index * 10.0),
                          height: 60 + (index * 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with shadow and glow effect
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: const Color(0xFF0EA5E9).withOpacity(0.5),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App title with shimmer effect
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  _shimmerController.value - 0.3,
                                  _shimmerController.value,
                                  _shimmerController.value + 0.3,
                                ],
                                colors: const [
                                  Colors.white54,
                                  Colors.white,
                                  Colors.white54,
                                ],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'ATTENDANCE APP',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        'Attendance System',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom text
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Powered by Flutter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    letterSpacing: 1,
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

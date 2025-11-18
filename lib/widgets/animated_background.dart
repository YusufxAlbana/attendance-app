import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final bool showBubbles;
  final bool showWaves;
  final bool showShapes;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.gradientColors,
    this.showBubbles = true,
    this.showWaves = true,
    this.showShapes = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late AnimationController _waveController;
  late AnimationController _shapeController;

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _shapeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _waveController.dispose();
    _shapeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [
          const Color(0xFF2563EB).withOpacity(0.05),
          const Color(0xFF0EA5E9).withOpacity(0.03),
        ];

    return Stack(
      children: [
        // Gradient background (optional)
        if (widget.gradientColors != null)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradientColors!,
              ),
            ),
          ),

        // Animated waves
        if (widget.showWaves)
          ...List.generate(2, (index) {
            return AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final double screenHeight = MediaQuery.of(context).size.height;
                final double screenWidth = MediaQuery.of(context).size.width;
                return Positioned(
                  bottom: -80 + (index * 60.0),
                  left: -screenWidth + (_waveController.value * screenWidth * 2),
                  child: Opacity(
                    opacity: 0.04 - (index * 0.01),
                    child: Container(
                      width: screenWidth * 2,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

        // Floating bubbles
        if (widget.showBubbles)
          ...List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                final double screenHeight = MediaQuery.of(context).size.height;
                final double screenWidth = MediaQuery.of(context).size.width;
                final double size = 30 + (index * 12.0);
                final double startX = (index * 80.0) % screenWidth;
                final double progress =
                    (_bubbleController.value + (index * 0.2)) % 1.0;

                return Positioned(
                  left: startX + (progress * 40 - 20),
                  bottom: -size + (progress * (screenHeight + size)),
                  child: Opacity(
                    opacity: (0.08 - (progress * 0.08)).clamp(0.0, 0.08),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0EA5E9),
                        border: Border.all(
                          color: const Color(0xFF0EA5E9).withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

        // Rotating shapes
        if (widget.showShapes)
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _shapeController,
              builder: (context, child) {
                final double screenHeight = MediaQuery.of(context).size.height;
                final double angle =
                    _shapeController.value * 6.28 + (index * 2.09);

                return Positioned(
                  top: screenHeight * 0.15 + (index * screenHeight * 0.25),
                  right: -20 + (_shapeController.value * 40) + (index * 15.0),
                  child: Transform.rotate(
                    angle: angle,
                    child: Opacity(
                      opacity: 0.04,
                      child: Container(
                        width: 50 + (index * 8.0),
                        height: 50 + (index * 8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22D3EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

        // Main content
        widget.child,
      ],
    );
  }
}

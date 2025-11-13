import 'package:flutter/material.dart';

/// Simple animated notification overlay.
///
/// Usage:
///   showAnimatedNotification(context, 'Saved successfully');
///
/// This inserts an [OverlayEntry] and animates a small card by sliding up
/// from the bottom of its area and then sliding down to dismiss.
Future<void> showAnimatedNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
  Color backgroundColor = const Color(0xFF333333),
  Color textColor = Colors.white,
  IconData? icon,
}) async {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _NotificationToast(
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      onDismissed: () {
        // Memastikan OverlayEntry dihapus setelah selesai
        entry.remove();
      },
    ),
  );

  overlay.insert(entry);
}

class _NotificationToast extends StatefulWidget {
  final String message;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback onDismissed;

  const _NotificationToast({
    Key? key,
    required this.message,
    required this.duration,
    required this.backgroundColor,
    required this.textColor,
    required this.onDismissed,
    this.icon,
  }) : super(key: key);

  @override
  State<_NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<_NotificationToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400), // Durasi halus 
  );

  // Animasi Geser (Slide): Mulai 30% di bawah (0, 0.3) ke posisi target (Offset.zero)
  // Curve: easeOutCubic untuk kemunculan yang mulus dan cepat
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, 0.3), 
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic, 
    reverseCurve: Curves.easeInQuad, // Agak cepat saat turun
  ));

  // Animasi Pudar (Fade): Selalu terlihat (1.0) saat muncul, dan memudar (ke 0.0) saat menghilang
  late final Animation<double> _fade = Tween<double>(
    begin: 1.0, // Mulai dari terlihat penuh
    end: 0.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 1.0, curve: Curves.linear), // Selalu 1.0 saat forward, lalu memudar saat reverse
  ));

  @override
  void initState() {
    super.initState();
    _showThenHide();
  }

  // Menampilkan notifikasi, menunggu, lalu menyembunyikannya.
  Future<void> _showThenHide() async {
    try {
      // Phase 1: Muncul (geser ke atas)
      await _controller.forward();
      
      // Phase 2: Tunggu
      await Future.delayed(widget.duration);
      
      // Phase 3: Hilang (geser ke bawah dan memudar)
      await _controller.reverse();
    } on TickerCanceled {
      // Ditangani jika widget dibuang
    } catch (_) {
      // Tangani kesalahan umum
    }
    // Hapus OverlayEntry
    if (mounted) {
        widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Memposisikan notifikasi di bagian atas layar, di bawah status bar.
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      // Menggunakan SlideTransition untuk gerakan naik/turun
      child: SlideTransition(
        position: _offset,
        // Menggunakan FadeTransition untuk efek memudar
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500), 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), 
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: widget.textColor, size: 22),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tombol tutup (opsional)
                        GestureDetector(
                          onTap: () async {
                            await _controller.reverse();
                            widget.onDismissed();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.close,
                              color: widget.textColor.withOpacity(0.7),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
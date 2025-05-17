import 'package:flutter/material.dart';
import 'toast_wrapper.dart';

class AnimatedToast {
  static OverlayEntry? _currentEntry;
  static AnimationController? _currentController;

  static void show(
    BuildContext context,
    String message, {
    required bool isAdded,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    final vsync = ToastWrapper.of(context);
    if (overlay == null || vsync == null) return;

    // Cancel and clean up any existing toast
    try {
      _currentController?.stop();
      _currentEntry?.remove();
      _currentController?.dispose();
    } catch (_) {}
    _currentEntry = null;
    _currentController = null;

    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 20,
        right: 20,
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isAdded ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    controller.forward();

    _currentEntry = entry;
    _currentController = controller;

    Future.delayed(duration, () async {
      try {
        if (controller.status == AnimationStatus.forward ||
            controller.status == AnimationStatus.completed) {
          await controller.reverse();
        }
      } catch (_) {} finally {
        try {
          entry.remove();
          controller.dispose();
        } catch (_) {}
        if (_currentEntry == entry) {
          _currentEntry = null;
          _currentController = null;
        }
      }
    });
  }
}

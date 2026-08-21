import 'dart:async';
import 'package:flutter/material.dart';
import 'debug_screen.dart';

/// A transparent overlay that detects a secret tap sequence to open the debug panel.
///
/// Secret gesture: 4 taps on right third of screen → 3 taps on left third of screen.
/// Must be completed within 3 seconds between taps, or the counter resets.
class DebugOverlay extends StatefulWidget {
  final Widget child;

  const DebugOverlay({
    super.key,
    required this.child,
  });

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  int _rightTaps = 0;
  int _leftTaps = 0;
  bool _rightPhaseComplete = false;
  Timer? _resetTimer;

  static const int _rightRequired = 4;
  static const int _leftRequired = 3;
  static const Duration _timeout = Duration(seconds: 3);

  void _onPointerDown(PointerDownEvent event) {
    final screenWidth = MediaQuery.of(context).size.width;
    final x = event.position.dx;

    final isRight = x > screenWidth * 0.67;
    final isLeft = x < screenWidth * 0.33;

    // Reset the inactivity timer on any tap
    _resetTimer?.cancel();
    _resetTimer = Timer(_timeout, _reset);

    if (!_rightPhaseComplete) {
      // Phase 1: Count right-side taps
      if (isRight) {
        _rightTaps++;
        if (_rightTaps >= _rightRequired) {
          setState(() {
            _rightPhaseComplete = true;
            _leftTaps = 0;
          });
        }
      } else if (isLeft) {
        // Tapping left during right phase resets
        _reset();
      }
    } else {
      // Phase 2: Count left-side taps
      if (isLeft) {
        _leftTaps++;
        if (_leftTaps >= _leftRequired) {
          _reset();
          _openDebugPanel();
        }
      } else if (isRight) {
        // Tapping right during left phase resets completely
        _reset();
      }
    }
  }

  void _reset() {
    _resetTimer?.cancel();
    if (_rightTaps != 0 || _leftTaps != 0 || _rightPhaseComplete) {
      setState(() {
        _rightTaps = 0;
        _leftTaps = 0;
        _rightPhaseComplete = false;
      });
    }
  }

  void _openDebugPanel() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DebugScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Transparent pointer listener — uses Listener not GestureDetector
        // so it never competes in the gesture arena and buttons still work.
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _onPointerDown,
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

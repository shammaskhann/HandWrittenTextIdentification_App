import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

// Torch Light Effect Animated Background
class AnimatedBackground2 extends StatefulWidget {
  const AnimatedBackground2({super.key});

  @override
  State<AnimatedBackground2> createState() => _AnimatedBackground2State();
}

class _AnimatedBackground2State extends State<AnimatedBackground2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pinkBallAnimation;
  late Animation<double> _blueBallAnimation;
  late Animation<double> _yellowBallAnimation;
  late Animation<Alignment> _pinkBallAlignment;
  late Animation<Alignment> _blueBallAlignment;
  late Animation<Alignment> _yellowBallAlignment;

  final Color lightPinkClr = const Color(0xFFEEA0FF);
  final Color lightGreenClr = const Color(0xFFE2F4A6);
  final Color lightYellowClr = const Color(0xFF5A4EFF);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    // Animations for ball movement
    _pinkBallAlignment = Tween<Alignment>(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _blueBallAlignment = Tween<Alignment>(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _yellowBallAlignment = Tween<Alignment>(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animations for ball size/pulse
    _pinkBallAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _blueBallAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _yellowBallAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Pink ball with enhanced glow
            Align(
              alignment: _pinkBallAlignment.value,
              child: Transform.scale(
                scale: _pinkBallAnimation.value,
                child: Container(
                  width: 400, // Increased size
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        lightPinkClr.withOpacity(0.4),
                        lightPinkClr.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 0.3, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Additional pink blur layer
            Align(
              alignment: _pinkBallAlignment.value,
              child: Container(
                width: 500, // Very large diffuse layer
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightPinkClr.withOpacity(0.05),
                ),
              ),
            ),

            // Blue ball with enhanced glow
            Align(
              alignment: _blueBallAlignment.value,
              child: Transform.scale(
                scale: _blueBallAnimation.value,
                child: Container(
                  width: 350, // Increased size
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        lightYellowClr.withOpacity(0.4),
                        lightYellowClr.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 0.3, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Additional blue blur layer
            Align(
              alignment: _blueBallAlignment.value,
              child: Container(
                width: 600, // Very large diffuse layer
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightYellowClr.withOpacity(0.05),
                ),
              ),
            ),

            // Yellow ball with enhanced glow
            Align(
              alignment: _yellowBallAlignment.value,
              child: Transform.scale(
                scale: _yellowBallAnimation.value,
                child: Container(
                  width: 280, // Increased size
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        lightGreenClr.withOpacity(0.4),
                        lightGreenClr.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 0.3, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Additional yellow blur layer
            Align(
              alignment: _yellowBallAlignment.value,
              child: Container(
                width: 450, // Very large diffuse layer
                height: 450,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightGreenClr.withOpacity(0.05),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

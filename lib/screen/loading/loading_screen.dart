import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
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

  bool _isLoading = false;

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
    return Scaffold(
      body: Stack(
        children: [
          // Animated background balls
          _buildAnimatedBackground(),

          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          // Content
          Center(
            child: Image.asset(
              'assets/gifs/loading.gif',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
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

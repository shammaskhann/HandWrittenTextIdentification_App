import 'dart:developer';
import 'dart:ui';

import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:ds_ai_project_ui/screen/components/animated_background.dart';
import 'package:ds_ai_project_ui/screen/components/animated_background2.dart';
import 'package:ds_ai_project_ui/screen/info/info_screen.dart';
import 'package:ds_ai_project_ui/screen/loading/loading_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    log("isLoading $_isLoading");
    return Scaffold(
      body: Stack(
        children: [
          // Animated background balls
          const AnimatedBackground(),

          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          // Content
          if (_isLoading == false)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo3.png',
                          height: 40,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'ScriptSence',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Main text lines
                    const Text(
                      'Decode Writing.',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const Text(
                      'Detect, Train,',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const Text(
                      'Refine & Automate.',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Description
                    const SizedBox(
                      child: Text(
                        'Unlock the power of handwriting.\nSeamlessly recognize, classify, and convert handwritten text with the help of advanced machine learning.\nFast. Accurate. Intelligent.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Custom Get Started button
                    _buildCustomButton(),
                  ],
                ),
              ),
            )
          else
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

  Widget _buildCustomButton() {
    return StatefulBuilder(
      builder: (contexts, setStates) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setStates(() => _isHovering = true),
          onExit: (_) => setStates(() => _isHovering = false),
          child: InkWell(
            onTap: () async {
              log("Get Started button tapped");
              setState(() => _isLoading = true);

              try {
                await Future.delayed(const Duration(seconds: 3));
                if (mounted) {
                  // Navigate to next screen instead of setting loading to false
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoScreen()),
                  );
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuad,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_isHovering ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(_isHovering ? 0.5 : 0.3),
                  width: _isHovering ? 1.5 : 1.0,
                ),
                boxShadow: _isHovering
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: lightPinkClr.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutQuad,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: _isHovering
                          ? [
                              Shadow(
                                color: lightPinkClr.withOpacity(0.8),
                                blurRadius: 10,
                              )
                            ]
                          : null,
                    ),
                    child: const Text('Get Started'),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutQuad,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _isHovering ? lightPinkClr : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: _isHovering
                          ? [
                              BoxShadow(
                                color: lightPinkClr.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutQuad,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: _isHovering ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

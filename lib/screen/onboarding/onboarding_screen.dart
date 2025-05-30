import 'dart:ui';

import 'package:ds_ai_project_ui/screen/components/animated_background.dart';
import 'package:ds_ai_project_ui/screen/info/info_screen.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background balls
          const AnimatedBackground(),

          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          // Content
          if (_isLoading)
            Center(
              child: Image.asset(
                'assets/gifs/loading.gif',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            )
          else
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: isMobile ? 40 : 200,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 700 : 1000,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo3.png',
                            height: isMobile ? 30 : 40,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ScriptSense',
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isMobile ? 20 : 30),

                      // Main text lines - responsive font sizes
                      Text(
                        'Decode Writing.',
                        style: TextStyle(
                          fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Detect, Train,',
                        style: TextStyle(
                          fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Refine & Automate.',
                        style: TextStyle(
                          fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isMobile ? 30 : 40),

                      // Description
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 32,
                        ),
                        child: Text(
                          'Unlock the power of handwriting.\nSeamlessly recognize, classify, and convert handwritten text with the help of advanced machine learning.\nFast. Accurate. Intelligent.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),
                      ),

                      SizedBox(height: isMobile ? 40 : 60),

                      // Custom Get Started button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 32,
                        ),
                        child: _buildCustomButton(isMobile),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(bool isMobile) {
    return StatefulBuilder(
      builder: (contexts, setStateSB) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) =>
              !isMobile ? setStateSB(() => _isHovering = true) : null,
          onExit: (_) =>
              !isMobile ? setStateSB(() => _isHovering = false) : null,
          child: InkWell(
            onTap: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuad,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32,
                vertical: isMobile ? 12 : 16,
              ),
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
                      fontSize: isMobile ? 16 : 18,
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
                  SizedBox(width: isMobile ? 8 : 12),
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
                    child: Icon(
                      Icons.arrow_forward,
                      size: isMobile ? 16 : 18,
                      color: _isHovering ? Colors.white : Colors.black,
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

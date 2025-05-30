import 'dart:ui';

import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:ds_ai_project_ui/screen/components/custom_action_button.dart';
import 'package:flutter/material.dart';

Widget buildQuickGuide(
    bool isMobile, bool isTablet, Size size, Function() onTap) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: isMobile ? 16 : 32,
      vertical: isMobile ? 16 : 32,
    ),
    decoration: BoxDecoration(
        color: cardBackgroundClr.withOpacity(0.9),
        borderRadius:
            isMobile ? BorderRadius.circular(20) : BorderRadius.circular(15)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main heading
        ShaderMask(
          shaderCallback: (bounds) => const RadialGradient(
            colors: [
              Color(0xFFE2F4A6),
              Color(0xFFFFFFFF),
            ],
            center: Alignment.center,
            radius: 1.0,
          ).createShader(bounds),
          child: Text(
            'Welcome to ScriptSense',
            style: TextStyle(
              fontSize: isMobile ? 24 : 51,
              color:
                  Colors.white, // This color will be overridden by the gradient
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const Spacer(),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                height: 1.5,
                fontSize: 16,
              ),
              children: [
                const TextSpan(
                  text: 'Welcome to ScriptSense - ',
                ),
                const TextSpan(
                  text: 'Your gateway to powerful handwriting recognition. ',
                ),
                const TextSpan(
                  text:
                      'With ScriptSense, you can seamlessly recognize, classify, and convert handwritten text using cutting-edge machine learning techniques. ',
                ),
                const TextSpan(
                  text:
                      'Whether you\'re working with individual characters or full words, ScriptSense delivers fast, accurate, and intelligent results.\n\n',
                ),
                const TextSpan(
                  text: 'To get started, click the ',
                ),
                TextSpan(
                  text: '+ New Script',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8)),
                ),
                const TextSpan(
                  text:
                      ' button to begin a fresh recognition session. You can also revisit your work through the ',
                ),
                TextSpan(
                  text: 'Recent Scripts',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8)),
                ),
                const TextSpan(
                  text: ' list, search for specific scripts using the ',
                ),
                TextSpan(
                  text: 'Search bar',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8)),
                ),
                const TextSpan(
                  text:
                      ', or manage your workspace by deleting past entries with the ',
                ),
                TextSpan(
                  text: 'Clear All Scripts',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8)),
                ),
                const TextSpan(
                  text: ' option.\n\n',
                ),
                const TextSpan(
                  text:
                      'Once you\'ve opened a new script, you\'ll be able to choose from three specialized models: ',
                ),
                TextSpan(
                  text: 'Character Recognition using Machine Learning',
                  style: TextStyle(
                      color: lightGreenClr, fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: ', ',
                ),
                TextSpan(
                  text: 'Character Recognition using CNN',
                  style: TextStyle(
                      color: lightPinkClr, fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: ', or ',
                ),
                TextSpan(
                  text: 'Word Recognition using OCR Models',
                  style: TextStyle(
                      color: lightYellowClr, fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text:
                      '. After selecting your preferred method, you can either ',
                ),
                const TextSpan(
                  text: 'Upload an Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text:
                      ' of handwritten text or use the Scribe tool to draw a character directly in the app.\n\n',
                ),
                const TextSpan(
                  text:
                      'ScriptSense is designed to help you explore, test, and unlock the true potential of handwriting with modern AI tools — all in one intuitive platform.',
                ),
              ],
            ),
          ),
        ),
        const Spacer(),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomActionButton(
              icon: Icons.check_sharp,
              label: 'Get Started',
              onTap: onTap,
            ),
          ],
        ),

        const SizedBox(height: 16),
      ],
    ),
  );
}

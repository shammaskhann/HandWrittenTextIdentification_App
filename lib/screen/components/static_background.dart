import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StaticBackground extends StatelessWidget {
  const StaticBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pink ball (bottom right)
        Positioned(
          bottom: -700,
          right: -600,
          child: Container(
            width: 1500,
            height: 1500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  lightPinkClr.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.8],
              ),
            ),
          ),
        ),

        // Yellow ball (top center)
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 550,
            height: 550,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  lightGreenClr.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.8],
              ),
            ),
          ),
        ),

        // Blue ball (bottom left)
        Positioned(
          bottom: -500,
          left: -500,
          child: Container(
            width: 1200,
            height: 1200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  lightYellowClr.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.8],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

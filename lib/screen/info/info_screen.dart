import 'dart:ui';

import 'package:ds_ai_project_ui/core/enums/model_type.dart';
import 'package:ds_ai_project_ui/screen/components/static_background.dart';
import 'package:ds_ai_project_ui/screen/info/widgets/model_card.dart';
import 'package:ds_ai_project_ui/screen/scripts/scripts_screen.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  ModelType? selectedModel;
  bool _isHoveringML = false;
  bool _isHoveringCNN = false;
  bool _isHoveringTransformer = false;

  final Color lightPinkClr = const Color(0xFFEEA0FF);
  final Color lightGreenClr = const Color(0xFFE2F4A6);
  final Color lightYellowClr = const Color(0xFF5A4EFF);
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Scaffold(
      body: Stack(
        children: [
          // Static background balls (reduced opacity)
          const StaticBackground(),

          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          // Content
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isMobile ? 20 : 40),

                  // Main heading
                  Text(
                    'Explore Handwritten Text Classification Options',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 64,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: isMobile ? 30 : 60),

                  // Model selection cards - Responsive layout
                  if (isMobile)
                    _buildMobileCards()
                  else if (isTablet)
                    _buildTabletCards()
                  else
                    _buildDesktopCards(),

                  SizedBox(height: isMobile ? 20 : 40),

                  // Continue button
                  if (selectedModel != null) _buildCustomButton(),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     bottom: isMobile ? 20.0 : 40.0,
                  //     left: isMobile ? 16 : 0,
                  //     right: isMobile ? 16 : 0,
                  //   ),
                  //   child: SizedBox(
                  //     width: isMobile ? double.infinity : null,
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //     builder: (context) =>
                  //         //         NextScreen(modelType: selectedModel!),
                  //         //   ),
                  //         // );
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: isMobile ? 24 : 40,
                  //           vertical: 16,
                  //         ),
                  //         backgroundColor: Colors.white.withOpacity(0.2),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(30),
                  //           side: BorderSide(
                  //               color: Colors.white.withOpacity(0.5)),
                  //         ),
                  //         elevation: 8,
                  //         shadowColor: Colors.white.withOpacity(0.3),
                  //       ),
                  //       child: Text(
                  //         'Continue',
                  //         style: TextStyle(
                  //           fontSize: isMobile ? 16 : 18,
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScriptsScreen(
                          modelType: selectedModel!,
                        )),
              );
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
                    child: const Text('Continue'),
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

  Widget _buildMobileCards() {
    return Column(
      children: [
        ModelCard(
          title: 'Character Recognition Using ML',
          description: 'Use traditional machine learning models '
              'to identify individual handwritten characters '
              'with customizable training options.',
          primaryColor: lightGreenClr,
          isSelected: selectedModel == ModelType.ML,
          isHovering: _isHoveringML,
          onTap: () => setState(() => selectedModel = ModelType.ML),
          onHover: (hovering) => setState(() => _isHoveringML = hovering),
          isMobile: true,
        ),
        const SizedBox(height: 16),
        ModelCard(
          title: 'Character Recognition Using CNN',
          description: 'Leverage convolutional neural networks '
              'for high-accuracy recognition of handwritten characters '
              'with deep learning power.',
          primaryColor: lightPinkClr,
          isSelected: selectedModel == ModelType.CNN,
          isHovering: _isHoveringCNN,
          onTap: () => setState(() => selectedModel = ModelType.CNN),
          onHover: (hovering) => setState(() => _isHoveringCNN = hovering),
          isMobile: true,
        ),
        const SizedBox(height: 16),
        ModelCard(
          title: 'Word Recognition Using OCR Model',
          description: 'Go beyond character-level recognition. '
              'Detect and classify complete handwritten words '
              'for smarter, context-aware text interpretation.',
          primaryColor: lightYellowClr,
          isSelected: selectedModel == ModelType.Transformer,
          isHovering: _isHoveringTransformer,
          onTap: () => setState(() => selectedModel = ModelType.Transformer),
          onHover: (hovering) =>
              setState(() => _isHoveringTransformer = hovering),
          isMobile: true,
        ),
      ],
    );
  }

  Widget _buildTabletCards() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModelCard(
              title: 'Character Recognition Using ML',
              description: 'Use traditional machine learning models '
                  'to identify individual handwritten characters '
                  'with customizable training options.',
              primaryColor: lightGreenClr,
              isSelected: selectedModel == ModelType.ML,
              isHovering: _isHoveringML,
              onTap: () => setState(() => selectedModel = ModelType.ML),
              onHover: (hovering) => setState(() => _isHoveringML = hovering),
              isTablet: true,
            ),
            const SizedBox(width: 16),
            ModelCard(
              title: 'Character Recognition Using CNN',
              description: 'Leverage convolutional neural networks '
                  'for high-accuracy recognition of handwritten characters '
                  'with deep learning power.',
              primaryColor: lightPinkClr,
              isSelected: selectedModel == ModelType.CNN,
              isHovering: _isHoveringCNN,
              onTap: () => setState(() => selectedModel = ModelType.CNN),
              onHover: (hovering) => setState(() => _isHoveringCNN = hovering),
              isTablet: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ModelCard(
          title: 'Word Recognition Using OCR Model',
          description: 'Go beyond character-level recognition. '
              'Detect and classify complete handwritten words '
              'for smarter, context-aware text interpretation.',
          primaryColor: lightYellowClr,
          isSelected: selectedModel == ModelType.Transformer,
          isHovering: _isHoveringTransformer,
          onTap: () => setState(() => selectedModel = ModelType.Transformer),
          onHover: (hovering) =>
              setState(() => _isHoveringTransformer = hovering),
          isTablet: true,
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildDesktopCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ModelCard(
          title: 'Character Recognition Using ML',
          description: 'Use traditional machine learning models '
              'to identify individual handwritten characters '
              'with customizable training options.',
          primaryColor: lightGreenClr,
          isSelected: selectedModel == ModelType.ML,
          isHovering: _isHoveringML,
          onTap: () => setState(() => selectedModel = ModelType.ML),
          onHover: (hovering) => setState(() => _isHoveringML = hovering),
        ),
        const SizedBox(width: 32),
        ModelCard(
          title: 'Character Recognition Using CNN',
          description: 'Leverage convolutional neural networks '
              'for high-accuracy recognition of handwritten characters '
              'with deep learning power.',
          primaryColor: lightPinkClr,
          isSelected: selectedModel == ModelType.CNN,
          isHovering: _isHoveringCNN,
          onTap: () => setState(() => selectedModel = ModelType.CNN),
          onHover: (hovering) => setState(() => _isHoveringCNN = hovering),
        ),
        const SizedBox(width: 32),
        ModelCard(
          title: 'Word Recognition Using OCR Model',
          description: 'Go beyond character-level recognition. '
              'Detect and classify complete handwritten words '
              'for smarter, context-aware text interpretation.',
          primaryColor: lightYellowClr,
          isSelected: selectedModel == ModelType.Transformer,
          isHovering: _isHoveringTransformer,
          onTap: () => setState(() => selectedModel = ModelType.Transformer),
          onHover: (hovering) =>
              setState(() => _isHoveringTransformer = hovering),
        ),
      ],
    );
  }
}

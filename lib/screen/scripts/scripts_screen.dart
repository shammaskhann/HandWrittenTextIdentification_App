import 'package:ds_ai_project_ui/components/drawing_point.dart';
import 'package:ds_ai_project_ui/components/logo_component.dart';
import 'package:ds_ai_project_ui/screen/components/custom_action_button.dart';
import 'package:ds_ai_project_ui/screen/components/static_background.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class ScriptsScreen extends StatefulWidget {
  const ScriptsScreen({super.key});

  @override
  State<ScriptsScreen> createState() => _ScriptsScreenState();
}

class _ScriptsScreenState extends State<ScriptsScreen> {
  final Color cardBackgroundClr = const Color(0xFF1C1C20);
  final Color buttonBackgroundClr = const Color(0xFF26262A);
  final Color buttonTextClr = Colors.white.withOpacity(0.4);
  bool _showSidebar = true;
  int? _selectedScriptIndex;
  PlatformFile? _selectedFile;
  bool _hasImage = false;
  Uint8List? pickedFileBytes;

  //WhiteBoard data
  List<DrawingPoint?> _drawingPoints = [];
  double _strokeWidth = 4.0;
  Color _selectedColor = Colors.white;
  bool _showWhiteboard = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1200;

    Widget _buildSidebar(bool isMobile, bool isTablet) {
      return Container(
        width: isMobile
            ? size.width * 0.8
            : isTablet
                ? 250
                : 350,
        decoration: BoxDecoration(
            color: cardBackgroundClr.withOpacity(0.9),
            borderRadius: isMobile
                ? const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))
                : BorderRadius.circular(15)),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getLogo(),
                  if (isMobile)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _showSidebar = false),
                    ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search scripts...',
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // Clear all button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Clear all',
                      style: TextStyle(color: Colors.blueAccent)),
                ),
              ),
            ),
            // Recent scripts list
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    selected: _selectedScriptIndex == index,
                    leading: Image.asset(
                      'assets/images/logo3.png',
                      height: 20,
                      width: 20,
                    ),
                    selectedTileColor: Colors.white.withOpacity(0.1),
                    title: Text(
                      'Script ${index + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    subtitle: Text(
                      'Character recognition by ML',
                      style: const TextStyle(color: Colors.white54),
                    ),
                    onTap: () => setState(() => _selectedScriptIndex = index),
                  );
                },
              ),
            ),

            // New Script button
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                          color: buttonBackgroundClr,
                          borderRadius: BorderRadius.circular(10),
                          //Shadow like the button is in graved
                          boxShadow: [
                            BoxShadow(
                              color: buttonBackgroundClr.withOpacity(0.2),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: buttonTextClr),
                          const SizedBox(width: 8),
                          Text(
                            'New Script',
                            style: TextStyle(color: buttonTextClr),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const StaticBackground(),

          // Main content layout
          Row(
            children: [
              // Sidebar (hidden on mobile in default state)
              if ((isTablet || !isMobile) && _showSidebar) ...[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40.0, bottom: 40, left: 32, right: 0),
                  child: _buildSidebar(isMobile, isTablet),
                ),
              ],

              // Main content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 32),
                  child: _buildMainContent(isMobile, isTablet, size),
                ),
              ),
            ],
          ),

          // Mobile sidebar toggle button
          if (isMobile && !_showSidebar)
            Positioned(
              top: 0,
              left: 0,
              child: FloatingActionButton.small(
                onPressed: () => setState(() => _showSidebar = true),
                backgroundColor: cardBackgroundClr,
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet, Size size) {
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
              'Character Recognition using ML',
              style: TextStyle(
                fontSize: isMobile ? 24 : 51,
                color: Colors
                    .white, // This color will be overridden by the gradient
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // Description
          // Image preview or description

          if (_hasImage && _selectedFile != null && pickedFileBytes != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: isMobile ? size.width * 0.8 : 400,
                  height: isMobile ? size.width * 0.8 : 400,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.memory(pickedFileBytes!, fit: BoxFit.scaleDown),
                ),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                  onPressed: _removeImage,
                ),
              ],
            )
          else
            Text(
              'Try out character recognition with machine learning.\n'
              'Upload a handwritten character image or draw one yourself — '
              'our Random Forest model will do the rest.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

          const Spacer(),

          // Action buttons
          // Action buttons - conditionally shown
          if (!_hasImage) ...[
            if (isMobile) ...[
              CustomActionButton(
                icon: Icons.upload_file,
                label: 'Upload a File',
                onTap: _pickImage,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.draw,
                label: 'Scribe',
                onTap: () {},
              ),
            ] else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomActionButton(
                    icon: Icons.upload_file,
                    label: 'Upload a File',
                    onTap: _pickImage,
                  ),
                  const SizedBox(width: 32),
                  CustomActionButton(
                    icon: Icons.draw,
                    label: 'Scribe',
                    onTap: () {},
                  ),
                ],
              ),
          ] else
            CustomActionButton(
              icon: Icons.search,
              label: 'Identify Text',
              onTap: () {
                // Handle text identification logic
              },
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isWide = false,
  }) {
    return SizedBox(
      width: isWide ? 200 : double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.first;
        if (file.extension?.toLowerCase() == 'jpg' ||
            file.extension?.toLowerCase() == 'jpeg' ||
            file.extension?.toLowerCase() == 'png') {
          setState(() {
            _selectedFile = file;
            _hasImage = true;
            pickedFileBytes = file.bytes;
          });
        } else {
          _showErrorDialog('Please select a valid image file (JPG/JPEG/PNG)');
        }
      }
    } catch (e) {
      _showErrorDialog('Error selecting file: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackgroundClr,
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedFile = null;
      _hasImage = false;
    });
  }
}

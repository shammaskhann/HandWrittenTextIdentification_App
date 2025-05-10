// import 'dart:ui';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Professional Whiteboard',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.grey[100],
//       ),
//       home: const DrawingBoard(),
//     );
//   }
// }

// class DrawingBoard extends StatefulWidget {
//   const DrawingBoard({super.key});

//   @override
//   State<DrawingBoard> createState() => _DrawingBoardState();
// }

// class _DrawingBoardState extends State<DrawingBoard> {
//   Color selectedColor = Colors.black;
//   double strokeWidth = 5;
//   List<DrawingPoint?> drawingPoints = [];
//   List<Color> colors = [
//     Colors.black,
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.yellow,
//     Colors.purple,
//     Colors.orange,
//     Colors.pink,
//     Colors.brown,
//     Colors.grey,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Professional Whiteboard',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save_alt),
//             onPressed: () => _showSaveDialog(context),
//             tooltip: 'Save Drawing',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: GestureDetector(
//                 onPanStart: (details) {
//                   setState(() {
//                     drawingPoints.add(
//                       DrawingPoint(
//                         details.localPosition,
//                         Paint()
//                           ..color = selectedColor
//                           ..isAntiAlias = true
//                           ..strokeWidth = strokeWidth
//                           ..strokeCap = StrokeCap.round,
//                       ),
//                     );
//                   });
//                 },
//                 onPanUpdate: (details) {
//                   setState(() {
//                     drawingPoints.add(
//                       DrawingPoint(
//                         details.localPosition,
//                         Paint()
//                           ..color = selectedColor
//                           ..isAntiAlias = true
//                           ..strokeWidth = strokeWidth
//                           ..strokeCap = StrokeCap.round,
//                       ),
//                     );
//                   });
//                 },
//                 onPanEnd: (details) {
//                   setState(() {
//                     drawingPoints.add(null);
//                   });
//                 },
//                 child: CustomPaint(
//                   painter: _DrawingPainter(drawingPoints),
//                   child: Container(
//                     height: double.infinity,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           _buildToolbar(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildToolbar(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Slider(
//                   min: 1,
//                   max: 40,
//                   value: strokeWidth,
//                   onChanged: (val) => setState(() => strokeWidth = val),
//                   activeColor: selectedColor,
//                   inactiveColor: Colors.grey[300],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   '${strokeWidth.toStringAsFixed(0)}px',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.7,
//                 ),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: colors
//                         .map((color) => Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4),
//                               child: _buildColorChoice(color),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () => setState(() => drawingPoints = []),
//                 icon: const Icon(Icons.delete, size: 20),
//                 label: const Text("Clear All"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red[50],
//                   foregroundColor: Colors.red,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     side: BorderSide(color: Colors.red.withOpacity(0.3)),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorChoice(Color color) {
//     bool isSelected = selectedColor == color;
//     return GestureDetector(
//       onTap: () => setState(() => selectedColor = color),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         height: isSelected ? 40 : 36,
//         width: isSelected ? 40 : 36,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: isSelected
//               ? Border.all(
//                   color: Colors.white,
//                   width: 3,
//                 )
//               : Border.all(
//                   color: Colors.grey[300]!,
//                   width: 1,
//                 ),
//           boxShadow: [
//             if (isSelected)
//               BoxShadow(
//                 color: color.withOpacity(0.5),
//                 spreadRadius: 2,
//                 blurRadius: 4,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSaveDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Save Drawing'),
//         content: const Text(
//             'This feature would save your drawing to gallery in a real implementation.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DrawingPainter extends CustomPainter {
//   final List<DrawingPoint?> drawingPoints;

//   _DrawingPainter(this.drawingPoints);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final List<Offset> offsetsList = [];

//     for (int i = 0; i < drawingPoints.length - 1; i++) {
//       final currentPoint = drawingPoints[i];
//       final nextPoint = drawingPoints[i + 1];

//       if (currentPoint != null && nextPoint != null) {
//         canvas.drawLine(
//           currentPoint.offset,
//           nextPoint.offset,
//           currentPoint.paint,
//         );
//       } else if (currentPoint != null && nextPoint == null) {
//         offsetsList.clear();
//         offsetsList.add(currentPoint.offset);
//         canvas.drawPoints(
//           PointMode.points,
//           offsetsList,
//           currentPoint.paint,
//         );
//       }
//     }

//     if (drawingPoints.isNotEmpty && drawingPoints.last != null) {
//       offsetsList.clear();
//       offsetsList.add(drawingPoints.last!.offset);
//       canvas.drawPoints(
//         PointMode.points,
//         offsetsList,
//         drawingPoints.last!.paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class DrawingPoint {
//   final Offset offset;
//   final Paint paint;

//   DrawingPoint(this.offset, this.paint);
// }

/// Version 2.0
///
/// This version includes the following features:
/// - Improved UI with a toolbar for color selection and stroke width adjustment.
/// - Clear button to reset the drawing.
/// - Save button to save the drawing.
/// - Text recognition button to identify text from the drawing.
/// - Enhanced error handling and user feedback.
// - Code refactoring for better readability and maintainability.
// i

//Version 3.0
// This version includes the following features:
// - Added a color palette for color selection.
// - Improved the UI with a more modern design.
// - Added a dark mode toggle.
// - Added a save button to save the drawing as an image.
// - Added a text recognition button to identify text from the drawing.
// - Improved error handling and user feedback.
// - Code refactoring for better readability and maintainability.
// - Added comments for better understanding of the code.
// - Improved the drawing experience with smoother lines and better performance.
// - Added a toolbar for easy access to drawing tools.
// - Added a clear button to reset the drawing.
import 'dart:developer';
import 'dart:ui';
import 'package:ds_ai_project_ui/screen/info/info_screen.dart';
import 'package:ds_ai_project_ui/screen/onboarding/onboarding_screen.dart';
import 'package:ds_ai_project_ui/screen/scripts/scripts_screen.dart';
import 'package:ds_ai_project_ui/services/api_service.dart';
import 'package:ds_ai_project_ui/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiteboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      themeMode: ThemeMode.dark,
      home: const ScriptsScreen(),
      //home: const DrawingBoard(),
    );
  }
}

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];
  final GlobalKey _whiteboardKey = GlobalKey();
  bool _isDarkMode = false;

  final ApiService _apiService = ApiService();
  String? _recognitionResult;
  String? _modelUsed;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Whiteboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Toggle Dark Mode',
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () => _showSaveDialog(context),
            tooltip: 'Save Drawing',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _whiteboardKey,
              child: Container(
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey[850] : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      drawingPoints.add(
                        DrawingPoint(
                          details.localPosition,
                          Paint()
                            ..color = selectedColor
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth
                            ..strokeCap = StrokeCap.round,
                        ),
                      );
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      drawingPoints.add(
                        DrawingPoint(
                          details.localPosition,
                          Paint()
                            ..color = selectedColor
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth
                            ..strokeCap = StrokeCap.round,
                        ),
                      );
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      drawingPoints.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: _DrawingPainter(drawingPoints),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildToolbar(context),
        ],
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<void> _recognizeText() async {
    final imageBytes = await _captureWhiteboard();
    if (imageBytes == null) return;
    log('Image captured: ${imageBytes.length} bytes');
    setState(() {
      _isProcessing = true;
      _recognitionResult = null;
      _modelUsed = null;
    });

    try {
      // You can make this selectable between 'cnn' and 'ml' as in the HTML example
      const modelType = 'cnn';

      final result = await _apiService.recognizeHandwriting(
        imageBytes: imageBytes,
        modelType: modelType,
      );
      log('Recognition Result: ${result.prediction}');
      log('Model Used: ${result.modelUsed}');
      setState(() {
        _recognitionResult = result.prediction;
        _modelUsed = result.modelUsed;
      });
    } on ApiException catch (e) {
      log('API Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<Uint8List?> _captureWhiteboard() async {
    try {
      RenderRepaintBoundary boundary = _whiteboardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing whiteboard: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
      return null;
    }
  }

  // Future<void> _identifyText() async {
  //   final imageBytes = await _captureWhiteboard();
  //   if (imageBytes == null) return;
  //   _showImageInfoDialog(imageBytes.length);
  // }

  void _showImageInfoDialog(int byteLength) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Ready for API'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Whiteboard content captured successfully.'),
            const SizedBox(height: 16),
            Text('Image size: ${(byteLength / 1024).toStringAsFixed(2)} KB'),
            const SizedBox(height: 16),
            const Text('In a real implementation, this would:'),
            const Text('- Send image bytes to your API'),
            const Text('- Process the image for text recognition'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Slider(
                  min: 1,
                  max: 40,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val),
                  activeColor: selectedColor,
                  inactiveColor:
                      _isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey[700] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${strokeWidth.toStringAsFixed(0)}px',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: colors
                        .map((color) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: _buildColorChoice(color),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildIdentifyTextButton(),
                  const SizedBox(width: 8),
                  _buildClearButton(),
                ],
              ),
            ],
          ),
          // Add recognition results display
          if (_recognitionResult != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recognition Result:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recognitionResult!,
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (_modelUsed != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Model used: ${_modelUsed!.toUpperCase()}',
                        style: TextStyle(
                          color:
                              _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

// Update your _buildIdentifyTextButton to show loading state:
  Widget _buildIdentifyTextButton() {
    return ElevatedButton.icon(
      onPressed: _isProcessing ? null : _recognizeText,
      icon: _isProcessing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : const Icon(Icons.text_fields, size: 20),
      label: Text(_isProcessing ? 'Processing...' : "Identify Text"),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isDarkMode ? Colors.blue[800] : Colors.blue[50],
        foregroundColor: _isDarkMode ? Colors.white : Colors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:
                _isDarkMode ? Colors.blue[700]! : Colors.blue.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton.icon(
      onPressed: () => setState(() => drawingPoints = []),
      icon: const Icon(Icons.delete, size: 20),
      label: const Text("Clear All"),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isDarkMode ? Colors.red[900] : Colors.red[50],
        foregroundColor: _isDarkMode ? Colors.white : Colors.red,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: _isDarkMode ? Colors.red[800]! : Colors.red.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildColorChoice(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isSelected ? 40 : 36,
        width: isSelected ? 40 : 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: _isDarkMode ? Colors.grey[300]! : Colors.white,
                  width: 3,
                )
              : Border.all(
                  color: _isDarkMode ? Colors.grey[500]! : Colors.grey[300]!,
                  width: 1,
                ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
              ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Drawing'),
        content: const Text(
            'This feature would save your drawing to gallery in a real implementation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> offsetsList = [];

    for (int i = 0; i < drawingPoints.length - 1; i++) {
      final currentPoint = drawingPoints[i];
      final nextPoint = drawingPoints[i + 1];

      if (currentPoint != null && nextPoint != null) {
        canvas.drawLine(
          currentPoint.offset,
          nextPoint.offset,
          currentPoint.paint,
        );
      } else if (currentPoint != null && nextPoint == null) {
        offsetsList.clear();
        offsetsList.add(currentPoint.offset);
        canvas.drawPoints(
          PointMode.points,
          offsetsList,
          currentPoint.paint,
        );
      }
    }

    if (drawingPoints.isNotEmpty && drawingPoints.last != null) {
      offsetsList.clear();
      offsetsList.add(drawingPoints.last!.offset);
      canvas.drawPoints(
        PointMode.points,
        offsetsList,
        drawingPoints.last!.paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}

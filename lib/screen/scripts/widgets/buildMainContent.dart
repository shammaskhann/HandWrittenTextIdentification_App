import 'dart:developer';
import 'dart:ui';

import 'package:ds_ai_project_ui/components/drawing_point.dart';
import 'package:ds_ai_project_ui/components/drawing_pointer.dart';
import 'package:ds_ai_project_ui/core/enums/model_type.dart';
import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:ds_ai_project_ui/screen/components/custom_action_button.dart';
import 'package:ds_ai_project_ui/screen/scripts/scripts_controller.dart';
import 'package:ds_ai_project_ui/utils/get_colorByModelType.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BuildMainContent extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final Size size;
  final ModelType modelType;
  const BuildMainContent(
    this.isMobile,
    this.isTablet,
    this.size,
    this.modelType, {
    super.key,
  });

  @override
  State<BuildMainContent> createState() => _BuildMainContentState();
}

class _BuildMainContentState extends State<BuildMainContent> {
  PlatformFile? _selectedFile;
  // bool _controller.hasImage = false;
  // Uint8List? _controller.pickedFileBytes;
  final Color cardBackgroundClr = const Color(0xFF1C1C20);
  final Color buttonBackgroundClr = const Color(0xFF26262A);
  final Color buttonTextClr = Colors.white.withOpacity(0.4);
  final GlobalKey _whiteboardKey = GlobalKey();

  // bool _controller.showWhiteBoard = false;
  Color selectedColor = Colors.black;
  Uint8List? whiteBoardImageBytes;
  double strokeWidth = 18.0;
  // List<DrawingPoint?> _controller.drawingPoints = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // selectedColor = getColorByModelType(widget.modelType);
  }

  final ScriptsController _controller = Get.isRegistered<ScriptsController>()
      ? Get.find<ScriptsController>()
      : Get.put(ScriptsController(), permanent: true);

  void clearAll() {
    _controller.disposeAll();
    setState(() {
      _controller.hasImage = false;
      _controller.showWhiteBoard = false;
      _controller.drawingPoints.clear();
      _controller.pickedFileBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("Has Image: $_controller.hasImage");
    log("_controller.pickedFileBytes: ${_controller.pickedFileBytes?.length}");
    log("Show WhiteBoard: $_controller.showWhiteBoard");
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 16 : 32,
        vertical: widget.isMobile ? 16 : 32,
      ),
      decoration: BoxDecoration(
          color: cardBackgroundClr.withOpacity(0.9),
          borderRadius: widget.isMobile
              ? BorderRadius.circular(20)
              : BorderRadius.circular(15)),
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
              widget.modelType == ModelType.ML
                  ? 'Character recognition by ML'
                  : widget.modelType == ModelType.CNN
                      ? 'Character recognition by CNN'
                      : 'Word recognition by OCR Model',
              style: TextStyle(
                fontSize: widget.isMobile ? 24 : 51,
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
          if (_controller.showWhiteBoard)
            SizedBox(
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Ensures the Row takes minimum space
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the Column takes minimum space
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            // Gradient border
                            Container(
                              width: widget.isMobile
                                  ? widget.size.width * 0.8
                                  : widget.size.width * 0.4,
                              height: widget.isMobile
                                  ? widget.size.width * 0.8
                                  : widget.size.height * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    widget.modelType == ModelType.ML
                                        ? lightGreenClr
                                        : widget.modelType == ModelType.CNN
                                            ? lightPinkClr
                                            : lightYellowClr,
                                    Colors.white.withOpacity(0.01),
                                    widget.modelType == ModelType.ML
                                        ? lightGreenClr
                                        : widget.modelType == ModelType.CNN
                                            ? lightPinkClr
                                            : lightYellowClr,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            // Inner container
                            Positioned.fill(
                              child: RepaintBoundary(
                                key: _whiteboardKey,
                                child: Container(
                                  width: widget.isMobile
                                      ? widget.size.width * 0.8
                                      : widget.size.width * 0.4,
                                  height: widget.isMobile
                                      ? widget.size.width * 0.8
                                      : widget.size.height * 0.4,
                                  margin: const EdgeInsets.all(
                                      2), // Adjust margin to control border thickness
                                  decoration: BoxDecoration(
                                    // color: const Color(0xFF26252A),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // ...existing code...
                                  child: GestureDetector(
                                    // Only allow drawing if the pointer is inside the whiteboard area
                                    onPanStart: (details) {
                                      final box = _whiteboardKey.currentContext
                                          ?.findRenderObject() as RenderBox?;
                                      if (box != null) {
                                        final local = box.globalToLocal(
                                            details.globalPosition);
                                        final size = box.size;
                                        if (local.dx >= 0 &&
                                            local.dy >= 0 &&
                                            local.dx <= size.width &&
                                            local.dy <= size.height) {
                                          setState(() {
                                            _controller.drawingPoints.add(
                                              DrawingPoint(
                                                local,
                                                Paint()
                                                  ..color = selectedColor
                                                  ..isAntiAlias = true
                                                  ..strokeWidth = strokeWidth
                                                  ..strokeCap = StrokeCap.round,
                                              ),
                                            );
                                          });
                                        }
                                      }
                                    },
                                    onPanUpdate: (details) {
                                      final box = _whiteboardKey.currentContext
                                          ?.findRenderObject() as RenderBox?;
                                      if (box != null) {
                                        final local = box.globalToLocal(
                                            details.globalPosition);
                                        final size = box.size;
                                        if (local.dx >= 0 &&
                                            local.dy >= 0 &&
                                            local.dx <= size.width &&
                                            local.dy <= size.height) {
                                          setState(() {
                                            _controller.drawingPoints.add(
                                              DrawingPoint(
                                                local,
                                                Paint()
                                                  ..color = selectedColor
                                                  ..isAntiAlias = true
                                                  ..strokeWidth = strokeWidth
                                                  ..strokeCap = StrokeCap.round,
                                              ),
                                            );
                                          });
                                        }
                                      }
                                    },
                                    onPanEnd: (details) {
                                      setState(() {
                                        _controller.drawingPoints.add(null);
                                      });
                                    },
                                    child: CustomPaint(
                                      painter: DrawingPainter(
                                          _controller.drawingPoints),
                                      child: Container(
                                        width: widget.isMobile
                                            ? widget.size.width * 0.8
                                            : widget.size.width * 0.4,
                                        height: widget.isMobile
                                            ? widget.size.width * 0.8
                                            : widget.size.height * 0.4,
                                        margin: const EdgeInsets.all(2),
                                      ),
                                    ),
                                  ),
// ...existing code...
                                  // child: GestureDetector(
                                  //   onPanStart: (details) {
                                  //     setState(() {
                                  //       _controller.drawingPoints.add(
                                  //         DrawingPoint(
                                  //           details.localPosition,
                                  //           Paint()
                                  //             ..color = selectedColor
                                  //             ..isAntiAlias = true
                                  //             ..strokeWidth = strokeWidth
                                  //             ..strokeCap = StrokeCap.round,
                                  //         ),
                                  //       );
                                  //     });
                                  //   },
                                  //   onPanUpdate: (details) {
                                  //     setState(() {
                                  //       _controller.drawingPoints.add(
                                  //         DrawingPoint(
                                  //           details.localPosition,
                                  //           Paint()
                                  //             ..color = selectedColor
                                  //             ..isAntiAlias = true
                                  //             ..strokeWidth = strokeWidth
                                  //             ..strokeCap = StrokeCap.round,
                                  //         ),
                                  //       );
                                  //     });
                                  //   },
                                  //   onPanEnd: (details) {
                                  //     setState(() {
                                  //       _controller.drawingPoints.add(null);
                                  //     });
                                  //   },
                                  //   child: CustomPaint(
                                  //     painter: DrawingPainter(
                                  //         _controller.drawingPoints),
                                  //     child: Container(
                                  //       width: widget.isMobile
                                  //           ? widget.size.width * 0.8
                                  //           : widget.size.width * 0.4,
                                  //       height: widget.isMobile
                                  //           ? widget.size.width * 0.8
                                  //           : widget.size.height * 0.4,
                                  //       margin: const EdgeInsets.all(
                                  //           2), // Adjust margin to control border thickness
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomActionButton(
                        label: "Submit",
                        icon: Icons.near_me,
                        iconAtEnd: true,
                        onTap: () async {
                          _controller.pickedFileBytes =
                              await _captureWhiteboard();
                          _controller.hasImage = true;

                          setState(() {
                            _controller.showWhiteBoard = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          else if (_controller.hasImage &&
              // _selectedFile != null &&
              _controller.pickedFileBytes != null &&
              !_controller.showWhiteBoard)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: widget.isMobile ? widget.size.width * 0.8 : 400,
                  height: widget.isMobile ? widget.size.width * 0.8 : 400,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.memory(_controller.pickedFileBytes!,
                      fit: BoxFit.scaleDown),
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
          if (!_controller.hasImage) ...[
            if (widget.isMobile) ...[
              CustomActionButton(
                icon: Icons.upload_file,
                label: 'Upload a File',
                onTap: _pickImage,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.draw,
                label: 'Scribe',
                onTap: () {
                  setState(() {
                    _controller.showWhiteBoard = true;
                  });
                },
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
                    onTap: () async {
                      //_controller.pickedFileBytes = await _captureWhiteboard();
                      _controller.hasImage = true;
                      setState(() {
                        _controller.showWhiteBoard = true;
                      });
                    },
                  ),
                ],
              ),
          ] else
            Obx(
              () => _controller.isProcessing.value
                  ? Image.asset(
                      'assets/gifs/loading.gif',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    )
                  : CustomActionButton(
                      icon: Icons.search,
                      label: 'Identify Text',
                      onTap: () {
                        _controller.recognizeText(_controller.pickedFileBytes!,
                            widget.modelType, context);
                      },
                    ),
            ),
          Obx(() => (_controller.isProcessing.value == false &&
                  _controller.recognitionResult != null)
              ? Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color:
                        getColorByModelType(widget.modelType).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recognition Result:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _controller.recognitionResult?.prediction ??
                            "No result",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      if (_controller.recognitionResult?.modelUsed != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Model used: ${_controller.recognitionResult?.modelUsed!.toUpperCase()}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox()),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    _controller.showWhiteBoard = false;
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
            _controller.hasImage = true;
            _controller.pickedFileBytes = file.bytes;
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
        content: Text(message, style: const TextStyle(color: Colors.white70)),
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
    clearAll();
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
}

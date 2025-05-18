import 'dart:developer';

import 'package:ds_ai_project_ui/components/drawing_point.dart';
import 'package:ds_ai_project_ui/components/logo_component.dart';
import 'package:ds_ai_project_ui/core/enums/model_type.dart';
import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:ds_ai_project_ui/screen/components/custom_action_button.dart';
import 'package:ds_ai_project_ui/screen/components/static_background.dart';
import 'package:ds_ai_project_ui/screen/info/info_screen.dart';
import 'package:ds_ai_project_ui/screen/scripts/scripts_controller.dart';
import 'package:ds_ai_project_ui/screen/scripts/widgets/NewScriptButton.dart';
import 'package:ds_ai_project_ui/screen/scripts/widgets/buildMainContent.dart';
import 'package:ds_ai_project_ui/screen/scripts/widgets/buildQuickGuide.dart';
import 'package:ds_ai_project_ui/screen/scripts/widgets/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScriptsScreen extends StatefulWidget {
  ModelType modelType;
  ScriptsScreen({required this.modelType, super.key});

  @override
  State<ScriptsScreen> createState() => _ScriptsScreenState();
}

class _ScriptsScreenState extends State<ScriptsScreen> {
  final Color cardBackgroundClr = const Color(0xFF1C1C20);
  final Color buttonBackgroundClr = const Color(0xFF26262A);
  final Color buttonTextClr = Colors.white.withOpacity(0.4);
  bool _showSidebar = true;
  int? _selectedScriptIndex;
  RxBool openModelSelection = false.obs;

  //WhiteBoard data
  List<DrawingPoint?> _drawingPoints = [];
  bool _showQuickGuide = true;
  // double _strokeWidth = 4.0;
  // Color _selectedColor = Colors.white;
  // bool _showWhiteboard = false;
  final _controller = Get.put(ScriptsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.setScript(widget.modelType);
  }

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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: 'Search scripts...',
            //       prefixIcon: const Icon(Icons.search, color: Colors.white54),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide.none,
            //       ),
            //       filled: true,
            //       fillColor: Colors.white.withOpacity(0.1),
            //       contentPadding: const EdgeInsets.symmetric(vertical: 12),
            //     ),
            //     style: const TextStyle(color: Colors.white),
            //   ),
            // ),
            AnimatedSearchBar(
              controller: _controller.searchController,
              onChanged: (value) {
                setState(() {});
              },
              width: 300,
              height: 50,
              hintText: 'Search scripts...',
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: _controller.scripts.length,
                  itemBuilder: (context, index) {
                    log("Building script $index ${_controller.scripts[index].content} ${_controller.scripts[index].modelType.toString()}");
                    return ListTile(
                      selected: _selectedScriptIndex == index,
                      leading: Image.asset(
                        'assets/images/logo3.png',
                        height: 20,
                        width: 20,
                      ),
                      selectedTileColor: Colors.white.withOpacity(0.1),
                      title: Text(
                        _controller.scripts[index].content,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        _controller.scripts[index].modelType == ModelType.ML
                            ? 'Character recognition by ML'
                            : _controller.scripts[index].modelType ==
                                    ModelType.CNN
                                ? 'Character recognition by CNN'
                                : 'Word recognition by Transformer',
                        style: const TextStyle(color: Colors.white54),
                      ),
                      onTap: () => setState(() => _selectedScriptIndex = index),
                    );
                  },
                ),
              ),
            ),
            NewScriptButton(
              openModelSelection: openModelSelection,
              buttonBackgroundClr: buttonBackgroundClr,
              buttonTextClr: buttonTextClr,
              lightGreenClr: lightGreenClr,
              lightPinkClr: lightPinkClr,
              lightYellowClr: lightYellowClr,
              onMyTap: () {
                openModelSelection.value = false;
                _controller.addNewScript(ModelType.ML);
                setState(() {
                  widget.modelType = ModelType.ML;
                });
                _controller.disposeAll();
              },
              onCnnTap: () {
                openModelSelection.value = false;
                _controller.addNewScript(ModelType.CNN);
                setState(() {
                  widget.modelType = ModelType.CNN;
                });
                _controller.disposeAll();
              },
              onTransformerTap: () {
                openModelSelection.value = false;
                _controller.addNewScript(ModelType.Transformer);
                setState(() {
                  widget.modelType = ModelType.Transformer;
                });
                _controller.disposeAll();
              },
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
                  child: _showQuickGuide
                      ? buildQuickGuide(
                          isMobile,
                          isTablet,
                          size,
                          () {
                            setState(() {
                              _showQuickGuide = false;
                            });
                          },
                        )
                      : BuildMainContent(
                          isMobile, isTablet, size, widget.modelType),
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
}

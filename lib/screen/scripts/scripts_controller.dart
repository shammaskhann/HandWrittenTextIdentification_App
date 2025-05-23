import 'dart:developer';
import 'dart:typed_data';

import 'package:ds_ai_project_ui/components/drawing_point.dart';
import 'package:ds_ai_project_ui/components/recognition_result.dart';
import 'package:ds_ai_project_ui/core/enums/model_type.dart';
import 'package:ds_ai_project_ui/screen/models/scripts.model.dart';
import 'package:ds_ai_project_ui/services/api_service.dart';
import 'package:ds_ai_project_ui/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ScriptsController extends GetxController {
  RxBool isProcessing = false.obs;
  RecognitionResult? recognitionResult;
  ApiService _apiService = ApiService();
  RxList<ScriptModel> scripts = <ScriptModel>[].obs;
  int activeIndex = 0;

  //main screen essentials
  bool hasImage = false;
  bool showWhiteBoard = false;
  List<DrawingPoint?> drawingPoints = [];
  Uint8List? pickedFileBytes;
  final TextEditingController searchController = TextEditingController();

  void setScript(ModelType modelType) {
    scripts.add(ScriptModel(
      id: activeIndex,
      content: '',
      modelType: modelType,
    ));
    activeIndex = scripts.length - 1;

    // scripts[activeIndex] = ScriptModel(
    //   id: activeIndex,
    //   content: recognitionResult?.prediction ?? '',
    //   modelType: modelType,
    // );
  }

  void disposeAll() {
    isProcessing.value = false;
    recognitionResult = null;
    hasImage = false;
    pickedFileBytes = null;
    drawingPoints.clear();
    showWhiteBoard = false;
  }

  void addNewScript(ModelType modelTypee) {
    if (scripts.isNotEmpty && scripts[activeIndex].content == '') {
      log("Updating existing script");
      scripts[activeIndex] = ScriptModel(
        id: activeIndex,
        content: recognitionResult?.prediction ?? '',
        modelType: modelTypee,
      );
      printScripts();
    } else {
      log("adding new script");
      scripts.add(ScriptModel(
        id: scripts.length,
        content: '',
        modelType: modelTypee,
      ));
      activeIndex = scripts.length - 1;
      printScripts();
    }
  }

  void printScripts() {
    for (var script in scripts) {
      log('Script ID: ${script.id}, Content: ${script.content} modelType: ${script.modelType}');
    }
  }

  Future<void> recognizeText(
      Uint8List imageBytes, ModelType modelTypee, BuildContext context) async {
    if (imageBytes == null) return;
    log('Image captured: ${imageBytes.length} bytes');
    try {
      isProcessing.value = true;
      // You can make this selectable between 'cnn' and 'ml' as in the HTML example
      final modelType = modelTypee == ModelType.ML
          ? 'ml'
          : modelTypee == ModelType.CNN
              ? 'cnn'
              : 'word';

      final result = await _apiService.recognizeHandwriting(
        imageBytes: imageBytes,
        modelType: modelType,
      );
      log('Recognition Result: ${result}');
      log('Model Used: ${result.modelUsed}');
      recognitionResult = result;

      scripts[activeIndex] = ScriptModel(
        id: activeIndex,
        content: recognitionResult!.prediction,
        modelType: modelTypee,
      );

      isProcessing.value = false;
    } on ApiException catch (e) {
      log('API Error: ${e.message}');
      isProcessing.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
}

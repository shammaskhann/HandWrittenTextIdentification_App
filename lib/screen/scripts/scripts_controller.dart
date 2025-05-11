import 'dart:developer';
import 'dart:typed_data';

import 'package:ds_ai_project_ui/components/recognition_result.dart';
import 'package:ds_ai_project_ui/core/enums/model_type.dart';
import 'package:ds_ai_project_ui/services/api_service.dart';
import 'package:ds_ai_project_ui/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ScriptsController extends GetxController {
  RxBool isProcessing = false.obs;
  RecognitionResult? recognitionResult;
  ApiService _apiService = ApiService();

  void disposeAll() {
    isProcessing.value = false;
    recognitionResult = null;
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
              : 'transformer';

      final result = await _apiService.recognizeHandwriting(
        imageBytes: imageBytes,
        modelType: modelType,
      );
      log('Recognition Result: ${result}');
      log('Model Used: ${result.modelUsed}');
      recognitionResult = result;
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

import 'package:ds_ai_project_ui/core/enums/model_type.dart';
import 'package:ds_ai_project_ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Color getColorByModelType(ModelType modelType) {
  switch (modelType) {
    case ModelType.ML:
      return lightGreenClr;
    case ModelType.CNN:
      return lightPinkClr;
    case ModelType.Transformer:
      return lightYellowClr;
    default:
      return Colors.grey; // Fallback color
  }
}

import 'package:ds_ai_project_ui/core/enums/model_type.dart';

class ScriptModel {
  final int id;
  final String content;
  ModelType? modelType;

  ScriptModel({
    required this.id,
    required this.content,
    required this.modelType,
  });
}

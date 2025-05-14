import 'package:ds_ai_project_ui/core/enums/model_type.dart';

class ScriptModel {
  final String content;
  final ModelType modelType;

  const ScriptModel({
    required this.content,
    required this.modelType,
  });
}

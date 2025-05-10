class RecognitionResult {
  final String prediction;
  final String modelUsed;

  RecognitionResult({
    required this.prediction,
    required this.modelUsed,
  });

  factory RecognitionResult.fromJson(Map<String, dynamic> json) {
    return RecognitionResult(
      prediction: json['prediction'] ?? 'No prediction',
      modelUsed: json['model_used'] ?? 'Unknown model',
    );
  }
}

class ClassificationResult {
  final String category;
  final String subcategory;
  final double confidence;
  final List<String> instructions;

  ClassificationResult({
    required this.category,
    required this.subcategory,
    required this.confidence,
    required this.instructions,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    // Defensive casting for confidence as it might come back as String or num
    final rawConfidence = json['confidence'];
    double confidenceValue = 0.0;
    
    if (rawConfidence is num) {
      confidenceValue = rawConfidence.toDouble();
    } else if (rawConfidence is String) {
      confidenceValue = double.tryParse(rawConfidence) ?? 0.0;
    }

    return ClassificationResult(
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      confidence: confidenceValue,
      instructions: List<String>.from(json['instructions'] as List),
    );
  }
}

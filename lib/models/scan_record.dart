import 'classification_result.dart';

class ScanRecord {
  final String id;
  final DateTime timestamp;
  final String imagePath;
  final ClassificationResult result;

  ScanRecord({
    required this.id,
    required this.timestamp,
    required this.imagePath,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
      'category': result.category,
      'subcategory': result.subcategory,
      'confidence': result.confidence,
      'instructions': result.instructions,
    };
  }

  factory ScanRecord.fromJson(Map<String, dynamic> json) {
    return ScanRecord(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePath: json['imagePath'] as String,
      result: ClassificationResult(
        category: json['category'] as String,
        subcategory: json['subcategory'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        instructions: List<String>.from(json['instructions'] as List),
      ),
    );
  }
}

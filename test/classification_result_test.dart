import 'package:flutter_test/flutter_test.dart';
import 'package:workshop/models/classification_result.dart';
import 'package:workshop/models/scan_record.dart';

void main() {
  group('ClassificationResult & ScanRecord', () {
    test('parses valid json into ClassificationResult', () {
      final json = {
        'category': 'organik',
        'subcategory': 'Kulit Pisang',
        'confidence': 0.95,
        'instructions': [
          'Pisahkan dari plastik',
          'Masukkan ke wadah kompos',
        ],
      };

      final result = ClassificationResult.fromJson(json);

      expect(result.category, 'organik');
      expect(result.subcategory, 'Kulit Pisang');
      expect(result.confidence, 0.95);
      expect(result.instructions.length, 2);
    });

    test('serializes and deserializes ScanRecord', () {
      final record = ScanRecord(
        id: 'test_123',
        timestamp: DateTime(2026, 1, 1),
        imagePath: '/tmp/test.jpg',
        result: ClassificationResult(
          category: 'non-organik',
          subcategory: 'Botol Plastik',
          confidence: 0.9,
          instructions: ['Bilas bersih', 'Remas wadah'],
        ),
      );

      final json = record.toJson();
      final parsed = ScanRecord.fromJson(json);

      expect(parsed.id, record.id);
      expect(parsed.result.category, 'non-organik');
      expect(parsed.result.subcategory, 'Botol Plastik');
      expect(parsed.result.instructions.length, 2);
    });
  });
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/classifier.dart';

part 'classifier_provider.g.dart';

@riverpod
ClassifierService classifier(Ref ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  print('GEMINI API KEY: $apiKey');

  if (apiKey == null) {
    throw Exception('GEMINI_API_KEY not found in .env');
  }
  return ClassifierService(apiKey: apiKey);
}

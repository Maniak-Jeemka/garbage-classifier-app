import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../models/classification_result.dart';

class ClassifierService {
  final String _apiKey;

  static const String _modelName = 'qwen/qwen3.8-27b';
  static final Uri _endpoint = Uri.parse(
    'https://api.groq.com/openai/v1/chat/completions',
  );

  static const String _systemPrompt =
      'Anda adalah ahli pengelolaan sampah. '
      'Tugas Anda adalah mengklasifikasikan sampah dalam foto ke dalam sistem tiga tempat sampah : '
      '1. organik (sampah mudah terurai), '
      '2. non-organik (sampah yang bisa didaur ulang), '
      '3. residu (sampah yang tidak bisa didaur ulang dan harus ke TPA). '
      'Jawab hanya dengan satu objek JSON dengan kunci: '
      '"category" (salah satu dari "organik", "non-organik", "residu"), '
      '"subcategory" (nama benda atau jenis sampah yang spesifik), '
      '"confidence" (angka 0.0 sampai 1.0), '
      '"instructions" (array langkah penanganan dalam Bahasa Indonesia).';

  ClassifierService({required String apiKey}) : _apiKey = apiKey;

  Future<ClassificationResult> classify(
    File image, {
    String? userContext,
  }) async {
    final imageBytes = await image.readAsBytes();
    final body = jsonEncode({
      'model': _modelName,
      'response_format': {'type': 'json_object'},
      'messages': [
        {'role': 'system', 'content': _systemPrompt},
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  'Klasifikasikan sampah dalam gambar ini sesuai dengan taksonomi tiga tempat sampah di Bali.'
                  '${userContext != null && userContext.isNotEmpty ? '\nKonteks tambahan dari pengguna: $userContext' : ''}',
            },
            {
              'type': 'image_url',
              'image_url': {
                'url':
                    'data:${_detectMimeType(imageBytes)};base64,${base64Encode(imageBytes)}',
              },
            },
          ],
        },
      ],
    });

    Object? lastError;

    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        final response = await _post(body).timeout(const Duration(seconds: 35));
        final text =
            (jsonDecode(response) as Map<String, dynamic>)['choices'][0]['message']['content']
                as String?;

        if (text == null || text.isEmpty) {
          throw Exception('Model tidak memberikan respon');
        }

        return ClassificationResult.fromJson(
          jsonDecode(text) as Map<String, dynamic>,
        );
      } on TimeoutException catch (e) {
        lastError = e;
      } catch (e) {
        lastError = e;
        final msg = e.toString();
        if (msg.contains('401:') ||
            msg.contains('403:') ||
            msg.contains('invalid_api_key')) {
          rethrow;
        }
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 900));
        }
      }
    }

    throw lastError ?? Exception('Gagal menghubungi server klasifikasi');
  }

  Future<String> _post(String body) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(_endpoint);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_apiKey');
      request.write(body);
      final response = await request.close();
      final text = await utf8.decoder.bind(response).join();
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}: $text');
      }
      return text;
    } finally {
      client.close();
    }
  }

  String _detectMimeType(Uint8List bytes) {
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    return 'image/jpeg';
  }
}

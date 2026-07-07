import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/classification_result.dart';

class ClassifierService {
  final GenerativeModel _model;

  ClassifierService({required String apiKey})
    : _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(
          'Anda adalah ahli pengelolaan sampah di Bali. '
          'Tugas Anda adalah mengklasifikasikan sampah dalam foto ke dalam sistem tiga tempat sampah Bali: '
          '1. organik (sampah mudah terurai), '
          '2. non-organik (sampah yang bisa didaur ulang), '
          '3. residu (sampah yang tidak bisa didaur ulang dan harus ke TPA). '
          'Berikan jawaban dalam format JSON dengan instruksi penanganan dalam Bahasa Indonesia.',
        ),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: Schema.object(
            properties: {
              'category': Schema.enumString(
                description:
                    'Kategori utama: harus salah satu dari [organik, non-organik, residu]',
                enumValues: ['organik', 'non-organik', 'residu'],
              ),
              'subcategory': Schema.string(
                description: 'Nama benda atau jenis sampah yang spesifik',
              ),
              'confidence': Schema.number(
                description: 'Tingkat kepercayaan model (0.0 sampai 1.0)',
              ),
              'instructions': Schema.array(
                items: Schema.string(
                  description:
                      'Langkah-langkah penanganan atau pembuangan dalam Bahasa Indonesia',
                ),
              ),
            },
            requiredProperties: [
              'category',
              'subcategory',
              'confidence',
              'instructions',
            ],
          ),
        ),
      );

  Future<ClassificationResult> classify(
    File image, {
    String? userContext,
  }) async {
    final imageBytes = await image.readAsBytes();

    final prompt = [
      Content.multi([
        TextPart(
          'Klasifikasikan sampah dalam gambar ini sesuai dengan taksonomi tiga tempat sampah di Bali.',
        ),
        if (userContext != null && userContext.isNotEmpty)
          TextPart('Konteks tambahan dari pengguna: $userContext'),
        DataPart('image/jpeg', imageBytes),
      ]),
    ];

    final response = await _model.generateContent(prompt);
    final text = response.text;

    if (text == null) {
      throw Exception('Model tidak memberikan respon');
    }

    final json = jsonDecode(text) as Map<String, dynamic>;
    return ClassificationResult.fromJson(json);
  }
}

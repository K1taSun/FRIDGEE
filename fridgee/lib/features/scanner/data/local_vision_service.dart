// OCR etykiet ze zdjęcia (offline, ML Kit).

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../domain/ocr_date_extractor.dart';

class OcrResult {
  const OcrResult({
    this.extractedDate,
    this.rawText = '',
  });

  final DateTime? extractedDate;
  final String rawText;
}

class LocalVisionService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<OcrResult> recognizeLabel(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognized = await _textRecognizer.processImage(inputImage);
      final rawText = recognized.text;

      debugPrint('[OCR] Raw text:\n$rawText');

      final extractedDate = OcrDateExtractor.extractFromText(rawText);

      return OcrResult(
        extractedDate: extractedDate,
        rawText: rawText,
      );
    } catch (e) {
      debugPrint('[OCR] Błąd ML Kit: $e');
      return OcrResult(rawText: 'Błąd silnika wizyjnego: $e');
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}

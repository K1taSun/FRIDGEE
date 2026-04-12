// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — local_vision_service.dart
// On-device AI: OCR (ML Kit) + object recognition (MobileNetV2/YOLOv11).
// 100% offline — no network calls for vision processing.
// Full implementation in Module 4.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../core/utils/date_utils.dart';

/// Result of on-device label OCR.
class OcrResult {
  const OcrResult({
    this.extractedDate,
    this.rawText = '',
    this.suggestedProductName,
  });

  /// Parsed expiry date (null if not found in text).
  final DateTime? extractedDate;

  /// Full raw OCR text for debugging / fallback.
  final String rawText;

  /// Product name hint extracted from OCR (best-effort).
  final String? suggestedProductName;
}

/// Service for on-device image processing.
/// All processing happens on-device — no internet required.
class LocalVisionService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// Recognizes text from [imagePath] and extracts the expiry date.
  ///
  /// Keywords searched (Polish + generic):
  ///   "Należy spożyć do", "Ważne do", "Najlepiej spożyć przed",
  ///   "Best before", "Use by", "BB:", "EXP:"
  ///
  /// TODO (Module 4): Add MobileNetV2/YOLOv11 for produce recognition.
  Future<OcrResult> recognizeLabel(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognized = await _textRecognizer.processImage(inputImage);
      final rawText = recognized.text;

      debugPrint('[OCR] Raw text: $rawText');

      // ── Date extraction ──────────────────────────────────────────────────
      DateTime? extractedDate;

      // Look for date-like patterns after expiry keywords
      final keywords = [
        'należy spożyć do',
        'ważne do',
        'najlepiej spożyć przed',
        'best before',
        'use by',
        'bb:',
        'exp:',
        'expiry',
      ];

      final lowerText = rawText.toLowerCase();
      for (final keyword in keywords) {
        final idx = lowerText.indexOf(keyword);
        if (idx == -1) continue;

        // Extract text after the keyword and try to parse a date
        final afterKeyword = rawText.substring(idx + keyword.length).trim();
        final dateRegex = RegExp(
            r'(\d{1,2}[./]\d{1,2}[./]\d{2,4}|\d{1,2}/\d{2,4})');
        final match = dateRegex.firstMatch(afterKeyword);
        if (match != null) {
          extractedDate = FridggeDateUtils.parseOcrDate(match.group(0)!);
          if (extractedDate != null) break;
        }
      }

      return OcrResult(
        extractedDate: extractedDate,
        rawText: rawText,
      );
    } catch (e) {
      debugPrint('[OCR] Error: $e');
      return const OcrResult(rawText: '');
    }
  }

  void dispose() => _textRecognizer.close();
}

// Przetwarzanie klatek kamery: kod kreskowy, YOLO, OCR daty.

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../data/yolo_detection_service.dart';
import '../utils/camera_image_utils.dart';
import 'ocr_date_extractor.dart';

class LiveScanFrameProcessor {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  final YoloDetectionService _yolo = YoloDetectionService();

  String? detectedBarcode;
  DateTime? detectedDate;
  String? detectedProductName;

  DateTime _lastOcrAttempt = DateTime.fromMillisecondsSinceEpoch(0);
  static const _ocrIntervalMs = 900;
  Future<void> ensureInitialized() => _yolo.ensureInitialized();

  bool get isComplete =>
      (detectedBarcode != null || detectedProductName != null) &&
      detectedDate != null;

  bool get _hasProduct => detectedBarcode != null || detectedProductName != null;

  Future<bool> processFrame(
    CameraImage image,
    CameraDescription camera, {
    bool barcodeLookupEnabled = true,
  }) async {
    final inputImage = inputImageFromCameraImage(image, camera);
    if (inputImage == null) return false;

    var stateChanged = false;

    if (barcodeLookupEnabled &&
        detectedBarcode == null &&
        detectedProductName == null) {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
        detectedBarcode = barcodes.first.rawValue;
        _yolo.resetStreak();
        stateChanged = true;
        HapticFeedback.lightImpact();
      }
    }

    if (detectedBarcode == null && detectedProductName == null) {
      final productName = await _yolo.detectFromCameraFrame(image, camera);
      if (productName != null) {
        detectedProductName = productName;
        stateChanged = true;
        HapticFeedback.lightImpact();
      }
    }

    // OCR tylko gdy produkt jest rozpoznany — daty są na etykiecie obok kodu/nazwy.
    if (detectedDate == null && _hasProduct) {
      final now = DateTime.now();
      if (now.difference(_lastOcrAttempt).inMilliseconds >= _ocrIntervalMs) {
        _lastOcrAttempt = now;
        final recognizedText = await _textRecognizer.processImage(inputImage);
        final parsed = OcrDateExtractor.extractForLiveScan(recognizedText.text);
        if (parsed != null) {
          detectedDate = parsed;
          stateChanged = true;
          HapticFeedback.lightImpact();
        }
      }
    }

    return stateChanged;
  }

  /// Skan z pojedynczego zdjęcia (takePicture) — YOLO + kod + OCR.
  Future<bool> processPicture(
    String filePath,
    CameraDescription camera, {
    bool barcodeLookupEnabled = true,
  }) async {
    final inputImage = InputImage.fromFilePath(filePath);
    var stateChanged = false;

    if (barcodeLookupEnabled &&
        detectedBarcode == null &&
        detectedProductName == null) {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
        detectedBarcode = barcodes.first.rawValue;
        _yolo.resetStreak();
        stateChanged = true;
        HapticFeedback.lightImpact();
      }
    }

    if (detectedBarcode == null && detectedProductName == null) {
      final productName = await _yolo.detectFromPictureFile(filePath);
      if (productName != null) {
        detectedProductName = productName;
        stateChanged = true;
        HapticFeedback.lightImpact();
      }
    }

    if (detectedDate == null && _hasProduct) {
      final now = DateTime.now();
      if (now.difference(_lastOcrAttempt).inMilliseconds >= _ocrIntervalMs) {
        _lastOcrAttempt = now;
        final recognizedText = await _textRecognizer.processImage(inputImage);
        final parsed = OcrDateExtractor.extractForLiveScan(recognizedText.text);
        if (parsed != null) {
          detectedDate = parsed;
          stateChanged = true;
          HapticFeedback.lightImpact();
        }
      }
    }

    return stateChanged;
  }

  void resetProductDetection() {
    detectedProductName = null;
    _yolo.resetStreak();
  }

  Future<void> dispose() async {
    _barcodeScanner.close();
    _textRecognizer.close();
    _yolo.dispose();
  }
}

// Skaner wyłącznie kodów kreskowych (bez AI i OCR).

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../utils/camera_image_utils.dart';

class BarcodeOnlyScannerPage extends StatefulWidget {
  const BarcodeOnlyScannerPage({super.key});

  @override
  State<BarcodeOnlyScannerPage> createState() => _BarcodeOnlyScannerPageState();
}

class _BarcodeOnlyScannerPageState extends State<BarcodeOnlyScannerPage> {
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  bool _isProcessing = false;
  bool _isTearingDown = false;
  bool _permissionDenied = false;
  String? _cameraError;
  String? _detectedBarcode;

  DateTime _lastFrameProcessed = DateTime.fromMillisecondsSinceEpoch(0);
  static const _frameIntervalMs = 250;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final granted = await _requestCameraPermission();
    if (!granted) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _cameraError = 'Brak kamery w urządzeniu');
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraFrame);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('[BarcodeScanner] Błąd kamery: $e');
      if (mounted) setState(() => _cameraError = 'Nie udało się uruchomić kamery');
    }
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;
    status = await Permission.camera.request();
    return status.isGranted;
  }

  void _processCameraFrame(CameraImage image) async {
    if (_isTearingDown || _isProcessing || _detectedBarcode != null) return;

    final now = DateTime.now();
    if (now.difference(_lastFrameProcessed).inMilliseconds < _frameIntervalMs) return;

    _isProcessing = true;
    _lastFrameProcessed = now;

    try {
      final camera = _cameraController?.description;
      if (camera == null) return;

      final inputImage = inputImageFromCameraImage(image, camera);
      if (inputImage == null) return;

      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
        if (!mounted) return;
        setState(() => _detectedBarcode = barcodes.first.rawValue);
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('[BarcodeScanner] Błąd klatki: $e');
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _isTearingDown = true;
    final controller = _cameraController;
    _cameraController = null;
    unawaited(_tearDown(controller));
    super.dispose();
  }

  Future<void> _tearDown(CameraController? controller) async {
    try {
      if (controller?.value.isStreamingImages ?? false) {
        await controller!.stopImageStream();
      }
    } catch (_) {}

    while (_isProcessing) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    await _barcodeScanner.close();
    await controller?.dispose();
  }

  void _confirmAndReturn() {
    Navigator.of(context).pop({'barcode': _detectedBarcode});
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return _buildErrorScaffold(
        'Brak dostępu do kamery',
        'Włącz uprawnienie kamery w ustawieniach.',
        showSettings: true,
      );
    }

    if (_cameraError != null) {
      return _buildErrorScaffold('Błąd kamery', _cameraError!);
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('Uruchamianie skanera kodów…', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(_cameraController!)),
          Center(
            child: Container(
              width: 280,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _detectedBarcode != null ? AppColors.success : AppColors.primary,
                  width: 2.5,
                ),
                borderRadius: AppTheme.radiusLarge,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: AppTheme.radiusMedium,
                ),
                child: const Text(
                  'Skieruj aparat na kod kreskowy',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: AppTheme.radiusLarge,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Skaner kodów kreskowych',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusRow(
                    'Kod kreskowy',
                    _detectedBarcode != null,
                    _detectedBarcode,
                    () => setState(() => _detectedBarcode = null),
                  ),
                  if (_detectedBarcode != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: _confirmAndReturn,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text('Użyj kodu', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScaffold(String title, String message, {bool showSettings = false}) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography, color: Colors.white54, size: 64),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: Colors.white60), textAlign: TextAlign.center),
              if (showSettings) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Otwórz ustawienia'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isDone, String? value, VoidCallback onReset) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? AppColors.success : Colors.white30,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: isDone ? Colors.white : Colors.white60, fontSize: 13),
            ),
          ),
          if (value != null) ...[
            Flexible(
              child: Text(
                value,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onReset,
              child: const Icon(Icons.restart_alt, color: AppColors.error, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}

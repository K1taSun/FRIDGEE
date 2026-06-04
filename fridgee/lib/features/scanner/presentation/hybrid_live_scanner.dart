// Skanowanie na żywo: kod kreskowy + YOLO + OCR daty.

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/live_scan_frame_processor.dart';
import '../domain/live_scan_result.dart';

class HybridLiveScannerPage extends StatefulWidget {
  const HybridLiveScannerPage({super.key});

  @override
  State<HybridLiveScannerPage> createState() => _HybridLiveScannerPageState();
}

class _HybridLiveScannerPageState extends State<HybridLiveScannerPage> {
  CameraController? _cameraController;
  bool _isProcessing = false;
  bool _isTearingDown = false;
  bool _permissionDenied = false;
  String? _cameraError;

  final LiveScanFrameProcessor _processor = LiveScanFrameProcessor();

  DateTime _lastFrameProcessed = DateTime.fromMillisecondsSinceEpoch(0);
  /// Minimalny odstęp między inferencjami YOLO.
  static const _frameIntervalMs = 220;
  CameraImage? _latestFrame;
  bool _inferenceLoopRunning = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraPipeline();
  }

  Future<void> _initializeCameraPipeline() async {
    final granted = await _requestCameraPermission();
    if (!granted) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }

    await _processor.ensureInitialized();

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _cameraError = 'Brak kamery w urządzeniu');
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraFrame);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('[HybridScanner] Błąd kamery: $e');
      if (mounted) setState(() => _cameraError = 'Nie udało się uruchomić kamery');
    }
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;
    status = await Permission.camera.request();
    return status.isGranted;
  }

  void _processCameraFrame(CameraImage image) {
    if (_isTearingDown || _processor.isComplete) return;
    _latestFrame = image;
    if (!_inferenceLoopRunning) {
      unawaited(_runInferenceLoop());
    }
  }

  Future<void> _runInferenceLoop() async {
    _inferenceLoopRunning = true;
    while (!_isTearingDown && !_processor.isComplete && _latestFrame != null) {
      final elapsed =
          DateTime.now().difference(_lastFrameProcessed).inMilliseconds;
      if (elapsed < _frameIntervalMs) {
        await Future<void>.delayed(
          Duration(milliseconds: _frameIntervalMs - elapsed),
        );
        if (_isTearingDown || _processor.isComplete) break;
      }

      _isProcessing = true;
      final frame = _latestFrame;
      _latestFrame = null;
      _lastFrameProcessed = DateTime.now();

      try {
        final camera = _cameraController?.description;
        if (camera == null || frame == null) continue;

        final stateChanged = await _processor.processFrame(
          frame,
          camera,
          barcodeLookupEnabled: false,
        );
        if (stateChanged && mounted) setState(() {});
      } catch (e) {
        debugPrint('[HybridScanner] Błąd klatki: $e');
      } finally {
        _isProcessing = false;
      }
    }
    _inferenceLoopRunning = false;
    if (_latestFrame != null && !_isTearingDown && !_processor.isComplete) {
      unawaited(_runInferenceLoop());
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

    await _processor.dispose();
    await controller?.dispose();
  }

  Future<void> _confirmAndReturn() async {
    final navigator = Navigator.of(context);
    try {
      if (_cameraController?.value.isStreamingImages ?? false) {
        await _cameraController!.stopImageStream();
      }
    } catch (_) {}
    if (!mounted) return;

    navigator.pop(
      LiveScanResult(
        barcode: _processor.detectedBarcode,
        expiryDate: _processor.detectedDate,
        productName: _processor.detectedProductName,
      ).toMap(),
    );
  }

  void _resetProductDetection() {
    setState(_processor.resetProductDetection);
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return _buildErrorScaffold(
        'Brak dostępu do kamery',
        'Aby rozpoznawać produkty, włącz uprawnienie kamery w ustawieniach.',
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
              Text('Uruchamianie kamery i YOLO…', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    final hasItem =
        _processor.detectedBarcode != null || _processor.detectedProductName != null;
    final hasAnyData = hasItem || _processor.detectedDate != null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(_cameraController!)),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasItem ? AppColors.success : AppColors.primary,
                  width: 2.5,
                ),
                borderRadius: AppTheme.radiusLarge,
              ),
              child: const Center(
                child: Icon(Icons.center_focus_weak, color: Colors.white24, size: 60),
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
                child: Text(
                  hasItem
                      ? 'Teraz zeskanuj datę ważności na opakowaniu'
                      : 'Ustaw produkt na środku ramki i zbliż\n(małe owoce, np. truskawki, wymagają bliżej)',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
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
                    'Główne Skanowanie',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusRow(
                    'Kod kreskowy',
                    _processor.detectedBarcode != null,
                    _processor.detectedBarcode,
                    () => setState(() => _processor.detectedBarcode = null),
                  ),
                  const SizedBox(height: 10),
                  _buildStatusRow(
                    'AI: Świeży produkt',
                    _processor.detectedProductName != null,
                    _processor.detectedProductName,
                    _resetProductDetection,
                  ),
                  const SizedBox(height: 10),
                  _buildStatusRow(
                    'Data ważności',
                    _processor.detectedDate != null,
                    _processor.detectedDate != null
                        ? DateFormat('dd.MM.yyyy').format(_processor.detectedDate!)
                        : null,
                    () => setState(() => _processor.detectedDate = null),
                  ),
                  if (hasAnyData) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: _confirmAndReturn,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text('Zatwierdź odczyt', style: TextStyle(color: Colors.white)),
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

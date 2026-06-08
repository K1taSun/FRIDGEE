// YOLOv8 ONNX — Owoce i Warzywa (Zoptymalizowane + Obrót Matrycy)

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:onnxruntime/onnxruntime.dart';

import '../utils/camera_rgb_utils.dart';
import 'fresh_produce_labels.dart';
import 'yolo_nms.dart';

class YoloDetectionService {
  static const _modelAsset = 'assets/models/yolo_fresh_produce.onnx';
  static const _inputSize = 320; 
  static const _confidenceThreshold = 0.50;
  static const _iouThreshold = 0.45;

  OrtSession? _session;
  String _inputName = 'images';
  final Completer<void> _initCompleter = Completer<void>();

  int _numClasses = FreshProduceLabels.numClasses;

  Float32List? _inputBuffer;

  final List<String> _recentLabels = [];
  static const _fastAcceptScore = 0.80;
  static const _mediumVoteWindow = 4;
  static const _mediumVotesRequired = 2;
  static const _lowVoteWindow = 5;
  static const _lowVotesRequired = 3;

  YoloDetectionService() {
    _initialize();
  }

  Future<void> ensureInitialized() {
    return _initCompleter.future;
  }

  Future<void> _initialize() async {
    try {
      try {
        OrtEnv.instance.init();
      } catch (e) {
        debugPrint('[YOLO] Środowisko już działa, pomijam inicjalizację.');
      }
      
      final options = OrtSessionOptions()..setIntraOpNumThreads(1);
      final bytes = await rootBundle.load(_modelAsset);
      
      final rawList = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      final modelBytes = Uint8List.fromList(rawList); 
      
      _session = OrtSession.fromBuffer(modelBytes, options);

      if (_session != null) {
        final inputs = _session!.inputNames;
        if (inputs.isNotEmpty) _inputName = inputs.first;
        _inputBuffer = Float32List(3 * _inputSize * _inputSize);
      }
    } catch (e) {
      debugPrint('[YOLO] BŁĄD INICJALIZACJI MODELU: $e');
    } finally {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  Future<String?> detectFromCameraFrame(
    CameraImage cameraImage,
    CameraDescription camera,
  ) async {
    await ensureInitialized();
    if (_session == null || _inputBuffer == null) return null;

    try {
      final rgb = cameraImageToRgb(cameraImage);
      if (rgb == null) return null;

      img.Image orientedImage = rgb;
      if (Platform.isAndroid && camera.sensorOrientation != 0) {
        orientedImage = img.copyRotate(rgb, angle: camera.sensorOrientation);
      }

      _fillInputBufferNchw(orientedImage);
      return _runInference();
    } catch (e) {
      return null;
    }
  }

  /// Zdjęcie z takePicture() — bez buforów strumienia kamery (bez gralloc).
  Future<String?> detectFromPictureFile(String filePath) async {
    await ensureInitialized();
    if (_session == null || _inputBuffer == null) return null;

    try {
      final bytes = await File(filePath).readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      _fillInputBufferNchw(decoded);
      return _runInference();
    } catch (e) {
      return null;
    }
  }

  Future<String?> _runInference() async {
    OrtValueTensor? inputTensor;
    OrtRunOptions? runOptions;
    List<OrtValue?>? outputs;

    try {
      inputTensor = OrtValueTensor.createTensorWithDataList(
        _inputBuffer!,
        [1, 3, _inputSize, _inputSize],
      );

      runOptions = OrtRunOptions();
      outputs = await _session!.runAsync(runOptions, {_inputName: inputTensor});

      if (outputs == null || outputs.isEmpty || outputs.first == null) {
        return null;
      }

      final rawOutput = _extractOutput(outputs.first!);
      if (rawOutput == null) return null;

      final detections = yoloNonMaxSuppression(
        rawOutput,
        numClasses: _numClasses,
        confidenceThreshold: _confidenceThreshold,
        iouThreshold: _iouThreshold,
      );

      if (detections.isEmpty) return null;

      detections.sort((a, b) => b.score.compareTo(a.score));
      final best = detections.first;

      final polishName = FreshProduceLabels.toPolish(best.classIndex);
      if (polishName == 'Inne' || polishName == 'Produkt') return null;

      if (kDebugMode) {
        final eng = best.classIndex < FreshProduceLabels.english.length
            ? FreshProduceLabels.english[best.classIndex]
            : '?';
        debugPrint(
          '[YOLO] √ Detekcja: $eng → $polishName (${(best.score * 100).toStringAsFixed(0)}%)',
        );
      }

      return _stabilize(polishName, score: best.score);
    } catch (e) {
      return null;
    } finally {
      inputTensor?.release();
      runOptions?.release();
      if (outputs != null) {
        for (final o in outputs) {
          o?.release();
        }
      }
    }
  }

  void _fillInputBufferNchw(img.Image source) {
    final int minSize = source.width < source.height ? source.width : source.height;
    final int xOffset = (source.width - minSize) ~/ 2;
    final int yOffset = (source.height - minSize) ~/ 2;

    // Center Crop na obróconym, poprawnym obrazie
    final cropped = img.copyCrop(source, x: xOffset, y: yOffset, width: minSize, height: minSize);
    final resized = img.copyResize(cropped, width: _inputSize, height: _inputSize);

    final buffer = _inputBuffer!;
    final planeSize = _inputSize * _inputSize;

    for (var y = 0; y < _inputSize; y++) {
      for (var x = 0; x < _inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        final idx = y * _inputSize + x;
        buffer[idx] = pixel.r / 255.0;
        buffer[planeSize + idx] = pixel.g / 255.0;
        buffer[2 * planeSize + idx] = pixel.b / 255.0;
      }
    }
  }

  List<List<double>>? _extractOutput(OrtValue output) {
    if (output is! OrtValueTensor) return null;
    final value = output.value;
    if (value is! List || value.isEmpty) return null;

    var tensor = value;
    if (tensor.length == 1 && tensor.first is List) {
      tensor = tensor.first as List;
    }
    if (tensor.isEmpty || tensor.first is! List) return null;

    final matrix = tensor
        .map((row) => (row as List).map((v) => (v as num).toDouble()).toList())
        .toList();

    final dim1 = matrix.length;
    final dim2 = matrix.first.length;

    int features;
    int predictions;
    List<List<double>> formattedMatrix;

    // KLUCZOWA POPRAWKA MATEMATYCZNA:
    // Plik NMS oczekuje struktury [Cechy(67)][Predykcje(8400)].
    if (dim1 < dim2) {
      // Skoro dim1 jest małe (67), a dim2 duże (8400), mamy uklad [67][8400].
      // Oddajemy go bezpośrednio. Błąd % polegał na tym, że wcześniej to obracaliśmy!
      features = dim1;
      predictions = dim2;
      _numClasses = features - 4;
      formattedMatrix = matrix;
    } else {
      // Skoro dim1 jest duże (8400), a dim2 małe (67), model zwrócił [8400][67].
      // Musimy go obrócić na [67][8400].
      features = dim2;
      predictions = dim1;
      _numClasses = features - 4;
      
      formattedMatrix = List.generate(
        features,
        (f) => List.generate(predictions, (p) => matrix[p][f]),
      );
    }

    return formattedMatrix;
  }

  String? _stabilize(String name, {required double score}) {
    if (score >= _fastAcceptScore) {
      if (kDebugMode) {
        debugPrint(
          '[YOLO] Akceptacja (1 klatka, ${(score * 100).toStringAsFixed(0)}%): $name',
        );
      }
      _recentLabels.clear();
      return name;
    }

    _recentLabels.add(name);
    while (_recentLabels.length > _lowVoteWindow) {
      _recentLabels.removeAt(0);
    }

    final useMediumBand = score >= 0.65;
    final window = useMediumBand ? _mediumVoteWindow : _lowVoteWindow;
    final required = useMediumBand ? _mediumVotesRequired : _lowVotesRequired;
    final slice = _recentLabels.length > window
        ? _recentLabels.sublist(_recentLabels.length - window)
        : _recentLabels;

    var votes = 0;
    for (final label in slice) {
      if (label == name) votes++;
    }

    if (votes >= required) {
      if (kDebugMode) {
        debugPrint(
          '[YOLO] Akceptacja ($votes/$window, ${(score * 100).toStringAsFixed(0)}%): $name',
        );
      }
      _recentLabels.clear();
      return name;
    }

    if (kDebugMode) {
      debugPrint(
        '[YOLO] Stabilizacja: $name ($votes/$required w $window, ${(score * 100).toStringAsFixed(0)}%)',
      );
    }
    return null;
  }

  void resetStreak() {
    _recentLabels.clear();
  }

  void dispose() {
    _session?.release();
    _session = null;
  }
}
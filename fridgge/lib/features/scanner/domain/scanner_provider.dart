// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — scanner_provider.dart
// Stub — full implementation in Module 4.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanner_provider.g.dart';

/// Tracks the current scanner mode.
enum ScannerMode { barcode, ocr, manual }

@riverpod
class ScannerNotifier extends _$ScannerNotifier {
  @override
  ScannerMode build() => ScannerMode.barcode;

  void setMode(ScannerMode mode) => state = mode;
}

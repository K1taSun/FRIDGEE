// Stan i tryb skanera.

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanner_provider.g.dart';

enum ScannerMode { barcode, ocr, manual }

@riverpod
class ScannerNotifier extends _$ScannerNotifier {
  @override
  ScannerMode build() => ScannerMode.barcode;

  void setMode(ScannerMode mode) => state = mode;
}

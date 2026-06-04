// Wspólna logika wyciągania dat ważności z tekstu OCR (offline).

import '../../../core/utils/date_utils.dart';

abstract final class OcrDateExtractor {
  static final _dateRegex = RegExp(
    r'([0-9OQLlI|]{1,2})[./\-\s]([0-9OQLloI|]{1,2})[./\-\s]([0-9OQLlI|]{2,4})',
  );

  static const _expiryKeywords = [
    'należy spożyć do',
    'ważne do',
    'data ważności',
    'termin ważności',
    'najlepiej spożyć przed',
    'spożyć do',
    'termin',
    'best before',
    'use by',
    'bb:',
    'exp:',
    'expiry',
    'exp',
    'val',
  ];

  /// Normalizuje typowe błędy OCR w fragmencie daty.
  static String normalizeDateToken(String raw) {
    var cleaned = raw.toUpperCase();
    cleaned = cleaned
        .replaceAll('O', '0')
        .replaceAll('Q', '0')
        .replaceAll('I', '1')
        .replaceAll('L', '1')
        .replaceAll('|', '1');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), '');
    return cleaned.replaceAll('/', '.').replaceAll('-', '.');
  }

  /// Szuka daty w tekście OCR. [keywordAware] — najpierw przy słowach kluczowych.
  static DateTime? extractFromText(
    String rawText, {
    bool keywordAware = true,
    Duration maxAge = const Duration(days: 365),
    Duration maxFuture = const Duration(days: 365 * 8),
  }) {
    if (rawText.trim().isEmpty) return null;

    final lowerText = rawText.toLowerCase();
    final now = DateTime.now();
    final minDate = now.subtract(maxAge);
    final maxDate = now.add(maxFuture);

    if (keywordAware) {
      for (final keyword in _expiryKeywords) {
        final idx = lowerText.indexOf(keyword);
        if (idx == -1) continue;

        final endIdx = (idx + keyword.length + 40 < rawText.length)
            ? idx + keyword.length + 40
            : rawText.length;
        final slice = rawText.substring(idx + keyword.length, endIdx);
        final parsed = _firstValidDateIn(slice, minDate, maxDate);
        if (parsed != null) return parsed;
      }
    }

    return _firstValidDateIn(rawText, minDate, maxDate);
  }

  /// Skanowanie na żywo z filtrowaniem słów kluczowych (mniej fałszywych dat).
  static DateTime? extractForLiveScan(String rawText) {
    return extractFromText(
      rawText,
      keywordAware: true,
      maxAge: const Duration(days: 30),
      maxFuture: const Duration(days: 730),
    );
  }

  static DateTime? _firstValidDateIn(String text, DateTime minDate, DateTime maxDate) {
    for (final match in _dateRegex.allMatches(text)) {
      final parsed = _parseMatch(match.group(0)!);
      if (parsed != null && parsed.isAfter(minDate) && parsed.isBefore(maxDate)) {
        return parsed;
      }
    }
    return null;
  }

  static DateTime? _parseMatch(String raw) {
    final cleaned = normalizeDateToken(raw);
    final fromUtils = FridgeeDateUtils.parseOcrDate(cleaned);
    if (fromUtils != null) return fromUtils;
    return _parseDotSeparated(cleaned);
  }

  static DateTime? _parseDotSeparated(String text) {
    try {
      final parts = text.split('.');
      if (parts.length != 3) return null;
      if (parts[0].length == 4) {
        return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
      var year = int.parse(parts[2]);
      if (year < 100) year += 2000;
      return DateTime(year, int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }
}

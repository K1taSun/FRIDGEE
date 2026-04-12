// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — date_utils.dart
// Human-readable date formatting helpers.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:intl/intl.dart';

abstract final class FridggeDateUtils {
  static final _dayMonthYear = DateFormat('d MMM yyyy', 'pl_PL');
  static final _dayMonth = DateFormat('d MMM', 'pl_PL');
  static final _monthYear = DateFormat('MM/yyyy', 'pl_PL');

  /// Formats a date as "14 kwi 2025"
  static String formatFull(DateTime date) => _dayMonthYear.format(date);

  /// Formats a date as "14 kwi"
  static String formatShort(DateTime date) => _dayMonth.format(date);

  /// Formats a date as "04/2025" (for product OCR / MM/YY labels)
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  /// Returns a human-readable expiry label for product cards.
  ///
  /// Examples:
  ///   - "Przeterminowany 3 dni temu"
  ///   - "Ważne do dziś"
  ///   - "Ważne 2 dni"
  ///   - "Ważne do 14 kwi"
  static String expiryLabel(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final diff = expiry.difference(today).inDays;

    return switch (diff) {
      < -1 => 'Przeterminowany ${(-diff)} dni temu',
      -1 => 'Przeterminowany wczoraj',
      0 => 'Ważne do dziś',
      1 => 'Ważne jeszcze 1 dzień',
      2 || 3 => 'Ważne jeszcze $diff dni',
      _ => 'Ważne do ${formatShort(expiryDate)}',
    };
  }

  /// Parses OCR-detected date strings into [DateTime?].
  ///
  /// Supported formats: DD/MM/YYYY, DD.MM.YYYY, MM/YY, MM/YYYY
  static DateTime? parseOcrDate(String raw) {
    final cleaned = raw.trim();

    // DD/MM/YYYY or DD.MM.YYYY
    final dmyRegex = RegExp(r'(\d{1,2})[./](\d{1,2})[./](\d{4})');
    final dmyMatch = dmyRegex.firstMatch(cleaned);
    if (dmyMatch != null) {
      return DateTime.tryParse(
        '${dmyMatch.group(3)}-${dmyMatch.group(2)!.padLeft(2, '0')}-'
        '${dmyMatch.group(1)!.padLeft(2, '0')}',
      );
    }

    // MM/YY (e.g. 04/26)
    final myShortRegex = RegExp(r'^(\d{1,2})/(\d{2})$');
    final myShortMatch = myShortRegex.firstMatch(cleaned);
    if (myShortMatch != null) {
      final month = int.tryParse(myShortMatch.group(1)!);
      final year = int.tryParse('20${myShortMatch.group(2)!}');
      if (month != null && year != null) {
        return DateTime(year, month);
      }
    }

    // MM/YYYY
    final myRegex = RegExp(r'^(\d{1,2})/(\d{4})$');
    final myMatch = myRegex.firstMatch(cleaned);
    if (myMatch != null) {
      final month = int.tryParse(myMatch.group(1)!);
      final year = int.tryParse(myMatch.group(2)!);
      if (month != null && year != null) {
        return DateTime(year, month);
      }
    }

    return null;
  }
}

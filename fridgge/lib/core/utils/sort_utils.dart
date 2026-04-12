// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — sort_utils.dart
// Sorting algorithms for product lists.
// Unit-tested in test/unit/sort_utils_test.dart
// ──────────────────────────────────────────────────────────────────────────────

import '../../../features/inventory/domain/product_item.dart';

enum ExpiryStatus {
  /// Expiry date is in the past
  expired,

  /// Expires today (within the next 24 h)
  expirestoday,

  /// Expires within the next 48 h
  expiresSoon,

  /// More than 48 h until expiry
  fresh,
}

abstract final class SortUtils {
  /// Returns a new sorted list of [ProductItem]s — does NOT mutate the input.
  ///
  /// Sort order (ascending urgency first):
  ///   1. Expired products (red)        — sorted by expiry ASC (oldest first)
  ///   2. Expires today                 — sorted by expiry ASC
  ///   3. Expires within 48 h           — sorted by expiry ASC
  ///   4. Fresh products                — sorted by expiry ASC
  ///
  /// Consumed items are excluded from the list.
  static List<ProductItem> sortByExpiry(List<ProductItem> products) {
    final now = DateTime.now();
    final active = products.where((p) => !p.isConsumed).toList();

    active.sort((a, b) {
      final statusA = _status(a.expiryDate, now);
      final statusB = _status(b.expiryDate, now);

      // Primary sort: urgency group
      final groupCompare = statusA.index.compareTo(statusB.index);
      if (groupCompare != 0) return groupCompare;

      // Secondary sort: expiry date ascending within same group
      return a.expiryDate.compareTo(b.expiryDate);
    });

    return active;
  }

  /// Returns the [ExpiryStatus] of a product given the current moment.
  static ExpiryStatus getStatus(ProductItem product) =>
      _status(product.expiryDate, DateTime.now());

  static ExpiryStatus _status(DateTime expiry, DateTime now) {
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    final in48h = startOfToday.add(const Duration(days: 2));

    if (expiry.isBefore(startOfToday)) return ExpiryStatus.expired;
    if (expiry.isBefore(startOfTomorrow)) return ExpiryStatus.expirestoday;
    if (expiry.isBefore(in48h)) return ExpiryStatus.expiresSoon;
    return ExpiryStatus.fresh;
  }

  /// Returns the number of days until expiry (negative = already expired).
  static int daysUntilExpiry(ProductItem product) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(
      product.expiryDate.year,
      product.expiryDate.month,
      product.expiryDate.day,
    );
    return expiry.difference(today).inDays;
  }
}

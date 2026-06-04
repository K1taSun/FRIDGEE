// Algorytmy sortowania list produktów.

import '../../../features/inventory/domain/product_item.dart';

enum ExpiryStatus {
  expired,      // Po terminie
  expirestoday, // Dzisiaj
  expiresSoon,  // Wkrótce (48h)
  fresh,        // Świeże (>48h)
}

abstract final class SortUtils {
  // Sortowanie po SKRÓCONEJ DYNAMCZNIE dacie ważności (effectiveExpiryDate)
  static List<ProductItem> sortByExpiry(List<ProductItem> products) {
    final now = DateTime.now();
    final active = products.where((p) => !p.isConsumed).toList();

    active.sort((a, b) {
      final statusA = _status(a.effectiveExpiryDate, now);
      final statusB = _status(b.effectiveExpiryDate, now);

      final groupCompare = statusA.index.compareTo(statusB.index);
      if (groupCompare != 0) return groupCompare;

      return a.effectiveExpiryDate.compareTo(b.effectiveExpiryDate);
    });

    return active;
  }

  // Pobiera status ważności korzystając z nowej logiki daty
  static ExpiryStatus getStatus(ProductItem product) =>
      _status(product.effectiveExpiryDate, DateTime.now());

  static ExpiryStatus _status(DateTime expiry, DateTime now) {
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    final in48h = startOfToday.add(const Duration(days: 2));

    if (expiry.isBefore(startOfToday)) return ExpiryStatus.expired;
    if (expiry.isBefore(startOfTomorrow)) return ExpiryStatus.expirestoday;
    if (expiry.isBefore(in48h)) return ExpiryStatus.expiresSoon;
    return ExpiryStatus.fresh;
  }

  static int daysUntilExpiry(ProductItem product) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(
      product.effectiveExpiryDate.year,
      product.effectiveExpiryDate.month,
      product.effectiveExpiryDate.day,
    );
    return expiry.difference(today).inDays;
  }
}
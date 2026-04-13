// Algorytmy sortowania list produktów.

import '../../../features/inventory/domain/product_item.dart';

enum ExpiryStatus {
  expired,      // Po terminie
  expirestoday, // Dzisiaj
  expiresSoon,  // Wkrótce (48h)
  fresh,        // Świeże (>48h)
}

abstract final class SortUtils {
  // Sortowanie po dacie ważności (rosnąco wg pilności).
  // Produkty zużyte są pomijane.
  static List<ProductItem> sortByExpiry(List<ProductItem> products) {
    final now = DateTime.now();
    final active = products.where((p) => !p.isConsumed).toList();

    active.sort((a, b) {
      final statusA = _status(a.expiryDate, now);
      final statusB = _status(b.expiryDate, now);

      // Grupowanie wg statusu (index w enum)
      final groupCompare = statusA.index.compareTo(statusB.index);
      if (groupCompare != 0) return groupCompare;

      // Sortowanie chronologiczne wewnątrz grup
      return a.expiryDate.compareTo(b.expiryDate);
    });

    return active;
  }

  // Pobiera status ważności produktu.
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

  // Liczba dni do końca ważności (ujemne = po terminie).
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

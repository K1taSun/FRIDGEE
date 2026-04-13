// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — sort_utils_test.dart
// Unit tests for the expiry date sorting algorithm.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter_test/flutter_test.dart';
import 'package:fridgge/core/utils/sort_utils.dart';
import 'package:fridgge/features/inventory/domain/product_item.dart';

void main() {
  group('SortUtils.sortByExpiry', () {
    /// Helper: creates a minimal ProductItem with the given expiry offset.
    ProductItem makeProduct({
      required String name,
      required int daysFromNow,
      bool isConsumed = false,
    }) {
      final now = DateTime.now();
      final item = ProductItem.create(
        uuid: name,
        name: name,
        quantity: 1,
        unit: StorageUnit.szt,
        expiryDate: DateTime(
          now.year,
          now.month,
          now.day,
        ).add(Duration(days: daysFromNow)),
        storageLocation: StorageLocation.fridge,
      );
      return item.copyWith(isConsumed: isConsumed);
    }

    test('expired products appear first', () {
      final products = [
        makeProduct(name: 'C - fresh', daysFromNow: 10),
        makeProduct(name: 'A - expired', daysFromNow: -3),
        makeProduct(name: 'B - soon', daysFromNow: 1),
      ];

      final sorted = SortUtils.sortByExpiry(products);

      expect(sorted.first.name, 'A - expired');
    });

    test('expiring today product is before expiring-soon product', () {
      final products = [
        makeProduct(name: 'soon', daysFromNow: 1),
        makeProduct(name: 'today', daysFromNow: 0),
      ];

      final sorted = SortUtils.sortByExpiry(products);

      expect(sorted.first.name, 'today');
    });

    test('sort order is: expired → today → soon → fresh', () {
      final products = [
        makeProduct(name: 'fresh', daysFromNow: 30),
        makeProduct(name: 'soon', daysFromNow: 1),
        makeProduct(name: 'expired', daysFromNow: -5),
        makeProduct(name: 'today', daysFromNow: 0),
      ];

      final sorted = SortUtils.sortByExpiry(products);

      expect(sorted[0].name, 'expired');
      expect(sorted[1].name, 'today');
      expect(sorted[2].name, 'soon');
      expect(sorted[3].name, 'fresh');
    });

    test('consumed products are excluded', () {
      final products = [
        makeProduct(name: 'active', daysFromNow: 5),
        makeProduct(name: 'consumed', daysFromNow: 1, isConsumed: true),
      ];

      final sorted = SortUtils.sortByExpiry(products);

      expect(sorted.length, 1);
      expect(sorted.first.name, 'active');
    });

    test('within same status group — sorted by expiry date ascending', () {
      final products = [
        makeProduct(name: 'expires in 20 days', daysFromNow: 20),
        makeProduct(name: 'expires in 5 days', daysFromNow: 5),
        makeProduct(name: 'expires in 10 days', daysFromNow: 10),
      ];

      final sorted = SortUtils.sortByExpiry(products);

      expect(sorted[0].name, 'expires in 5 days');
      expect(sorted[1].name, 'expires in 10 days');
      expect(sorted[2].name, 'expires in 20 days');
    });

    test('empty list returns empty list', () {
      expect(SortUtils.sortByExpiry([]), isEmpty);
    });

    test('does not mutate the original list', () {
      final original = [
        makeProduct(name: 'fresh', daysFromNow: 30),
        makeProduct(name: 'expired', daysFromNow: -1),
      ];
      final originalOrder = original.map((p) => p.name).toList();

      SortUtils.sortByExpiry(original);

      expect(original.map((p) => p.name).toList(), originalOrder);
    });
  });

  group('SortUtils.getStatus', () {
    ProductItem item(int days) => ProductItem.create(
          uuid: 'test',
          name: 'Test',
          quantity: 1,
          unit: StorageUnit.szt,
          expiryDate: DateTime.now().add(Duration(days: days)),
          storageLocation: StorageLocation.fridge,
        );

    test('returns expired for past dates', () {
      expect(SortUtils.getStatus(item(-1)), ExpiryStatus.expired);
      expect(SortUtils.getStatus(item(-10)), ExpiryStatus.expired);
    });

    test('returns expirestoday for today', () {
      expect(SortUtils.getStatus(item(0)), ExpiryStatus.expirestoday);
    });

    test('returns expiresSoon for tomorrow', () {
      expect(SortUtils.getStatus(item(1)), ExpiryStatus.expiresSoon);
    });

    test('returns fresh for dates beyond 48 h', () {
      expect(SortUtils.getStatus(item(3)), ExpiryStatus.fresh);
      expect(SortUtils.getStatus(item(100)), ExpiryStatus.fresh);
    });
  });

  group('SortUtils.daysUntilExpiry', () {
    ProductItem item(int days) => ProductItem.create(
          uuid: 'test',
          name: 'Test',
          quantity: 1,
          unit: StorageUnit.szt,
          expiryDate: DateTime.now().add(Duration(days: days)),
          storageLocation: StorageLocation.fridge,
        );

    test('returns 0 for today', () {
      expect(SortUtils.daysUntilExpiry(item(0)), 0);
    });

    test('returns positive days for future dates', () {
      expect(SortUtils.daysUntilExpiry(item(7)), 7);
    });

    test('returns negative days for expired items', () {
      expect(SortUtils.daysUntilExpiry(item(-3)), -3);
    });
  });
}

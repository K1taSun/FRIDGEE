// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — product_provider.dart
// Riverpod providers for the Inventory feature.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/sort_utils.dart';
import '../data/product_repository.dart';
import '../domain/product_item.dart';

part 'product_provider.g.dart';

// ── Repository provider ───────────────────────────────────────────────────────

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}

// ── Sorted product stream ────────────────────────────────────────────────────

/// Streams all active (non-consumed) products sorted by expiry urgency.
/// Updates automatically when the Isar DB changes.
@riverpod
Stream<List<ProductItem>> sortedProducts(SortedProductsRef ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchActiveProducts().map(SortUtils.sortByExpiry);
}

// ── Inventory counts ──────────────────────────────────────────────────────────

/// Returns the count of products expiring within 48 h (badge on nav tab).
@riverpod
int expiringSoonCount(ExpiringSoonCountRef ref) {
  final productsAsync = ref.watch(sortedProductsProvider);
  return productsAsync.valueOrNull?.where((p) {
    final status = SortUtils.getStatus(p);
    return status == ExpiryStatus.expiresSoon ||
        status == ExpiryStatus.expirestoday ||
        status == ExpiryStatus.expired;
  }).length ?? 0;
}

// ── Notifier (CRUD actions) ──────────────────────────────────────────────────

/// Manages inventory mutations: add, consume, delete.
@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  Future<void> build() async {}

  ProductRepository get _repo => ref.read(productRepositoryProvider);

  Future<void> addProduct(ProductItem product) =>
      _repo.save(product);

  Future<void> addFromPreset(QuickStartPreset preset) =>
      _repo.addFromPreset(preset);

  Future<void> markConsumed(int id) =>
      _repo.markConsumed(id);

  Future<void> deleteProduct(int id) =>
      _repo.delete(id);
}

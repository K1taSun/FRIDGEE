import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'product_item.dart';
import '../data/product_repository.dart';

part 'product_provider.g.dart';

final _productRepo = ProductRepository();

@riverpod
Stream<List<ProductItem>> sortedProducts(SortedProductsRef ref) {
  return _productRepo.watchActiveProducts();
}

@riverpod
int expiringSoonCount(ExpiringSoonCountRef ref) {
  final products = ref.watch(sortedProductsProvider).valueOrNull ?? [];
  return products.where((p) {
    final diff = p.expiryDate.difference(DateTime.now()).inDays;
    return diff >= 0 && diff <= 3;
  }).length;
}

@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addProduct(ProductItem item) => _productRepo.save(item);

  Future<void> addFromPreset(dynamic preset) => _productRepo.addFromPreset(preset);

  Future<void> markConsumed(int id) => _productRepo.markConsumed(id);
}

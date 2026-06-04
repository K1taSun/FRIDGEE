// Stan widoku ekranu magazynu (siatka stref vs lista produktów).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_category_codec.dart';
import 'product_item.dart';

enum InventoryViewMode { allProducts, storageObjects }

enum InventorySortMode {
  expiryAsc,
  expiryDesc,
  nameAsc,
  nameDesc,
}

final inventoryViewModeProvider =
    StateProvider<InventoryViewMode>((ref) => InventoryViewMode.storageObjects);

final selectedFilterStorageIdProvider = StateProvider<String>((ref) => 'all');

final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

final inventorySortModeProvider =
    StateProvider<InventorySortMode>((ref) => InventorySortMode.expiryAsc);

List<ProductItem> filterAndSortProducts({
  required List<ProductItem> products,
  required String searchQuery,
  required InventorySortMode sortMode,
  String? storageZoneId,
}) {
  var result = products;

  if (storageZoneId != null && storageZoneId != 'all') {
    result = result
        .where((p) => ProductCategoryCodec.belongsToStorage(p.category, storageZoneId))
        .toList();
  }

  final query = searchQuery.trim().toLowerCase();
  if (query.isNotEmpty) {
    result = result.where((p) {
      final nameMatch = p.name.toLowerCase().contains(query);
      final barcodeMatch = p.barcode?.toLowerCase().contains(query) ?? false;
      final typeMatch = (ProductCategoryCodec.type(p.category) ?? '')
          .toLowerCase()
          .contains(query);
      return nameMatch || barcodeMatch || typeMatch;
    }).toList();
  }

  result = List<ProductItem>.from(result);

  switch (sortMode) {
    case InventorySortMode.expiryAsc:
      result.sort((a, b) => a.effectiveExpiryDate.compareTo(b.effectiveExpiryDate));
    case InventorySortMode.expiryDesc:
      result.sort((a, b) => b.effectiveExpiryDate.compareTo(a.effectiveExpiryDate));
    case InventorySortMode.nameAsc:
      result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    case InventorySortMode.nameDesc:
      result.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
  }

  return result;
}

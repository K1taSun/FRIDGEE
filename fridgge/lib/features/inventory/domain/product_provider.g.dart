// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productRepositoryHash() => r'1143e6a957468f07814b030b8e53d8ea1ddb037b';

/// See also [productRepository].
@ProviderFor(productRepository)
final productRepositoryProvider =
    AutoDisposeProvider<ProductRepository>.internal(
  productRepository,
  name: r'productRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductRepositoryRef = AutoDisposeProviderRef<ProductRepository>;
String _$sortedProductsHash() => r'fe50f7c11b6d0cbc4474c4ef9bb6edb3fbfa52ea';

/// Streams all active (non-consumed) products sorted by expiry urgency.
/// Updates automatically when the Isar DB changes.
///
/// Copied from [sortedProducts].
@ProviderFor(sortedProducts)
final sortedProductsProvider =
    AutoDisposeStreamProvider<List<ProductItem>>.internal(
  sortedProducts,
  name: r'sortedProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortedProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SortedProductsRef = AutoDisposeStreamProviderRef<List<ProductItem>>;
String _$expiringSoonCountHash() => r'b934865cbc7b8f4ba41e039a72649b912af9c5e5';

/// Returns the count of products expiring within 48 h (badge on nav tab).
///
/// Copied from [expiringSoonCount].
@ProviderFor(expiringSoonCount)
final expiringSoonCountProvider = AutoDisposeProvider<int>.internal(
  expiringSoonCount,
  name: r'expiringSoonCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expiringSoonCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpiringSoonCountRef = AutoDisposeProviderRef<int>;
String _$inventoryNotifierHash() => r'6fb8c4daccf4d9b2067790932ac1a6d0a91aa3ac';

/// Manages inventory mutations: add, consume, delete.
///
/// Copied from [InventoryNotifier].
@ProviderFor(InventoryNotifier)
final inventoryNotifierProvider =
    AutoDisposeAsyncNotifierProvider<InventoryNotifier, void>.internal(
  InventoryNotifier.new,
  name: r'inventoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

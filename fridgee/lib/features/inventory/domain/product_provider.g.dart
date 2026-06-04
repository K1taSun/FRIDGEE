// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sortedProductsHash() => r'3ddb0811a02a39af8157e3755ff18825979a3c5b';

/// See also [sortedProducts].
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
String _$expiringSoonCountHash() => r'f484326bc7dd3e58a7a48df36ebef0a76a97f8ad';

/// See also [expiringSoonCount].
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
String _$inventoryNotifierHash() => r'2d4931525bf166e76e85b47c91f3bf113f055122';

/// See also [InventoryNotifier].
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shoppingItemsHash() => r'5f5b18d00512ca37ab71f1b26954d7ac88fe6c59';

/// See also [shoppingItems].
@ProviderFor(shoppingItems)
final shoppingItemsProvider =
    AutoDisposeStreamProvider<List<ShoppingItem>>.internal(
  shoppingItems,
  name: r'shoppingItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shoppingItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShoppingItemsRef = AutoDisposeStreamProviderRef<List<ShoppingItem>>;
String _$shoppingNotifierHash() => r'205968b0e3385267b04b0eeaf0ee0fd80c6c4d2b';

/// See also [ShoppingNotifier].
@ProviderFor(ShoppingNotifier)
final shoppingNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ShoppingNotifier, void>.internal(
  ShoppingNotifier.new,
  name: r'shoppingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shoppingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShoppingNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// Providery Riverpod dla listy zakupów.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/shopping_repository.dart';
import 'shopping_item.dart';

part 'shopping_provider.g.dart';

const _uuid = Uuid();
final _repo = ShoppingRepository();

@riverpod
Stream<List<ShoppingItem>> shoppingItems(ShoppingItemsRef ref) {
  ref.onDispose(_repo.dispose);
  return _repo.watchUnchecked();
}

@riverpod
class ShoppingNotifier extends _$ShoppingNotifier {
  @override
  Future<void> build() async {}

  Future<void> addItem({
    required String name,
    required double quantity,
    required String unit,
    ShoppingItemSource source = ShoppingItemSource.manual,
    String? note,
    String? recipeId,
  }) {
    return _repo.add(ShoppingItem.create(
      uuid: _uuid.v4(),
      name: name,
      quantity: quantity,
      unit: unit,
      source: source,
      note: note,
      recipeId: recipeId,
    ));
  }

  Future<void> addMissingIngredient({
    required String name,
    required double requiredAmount,
    required String unit,
    required String recipeId,
  }) {
    return addItem(
      name: name,
      quantity: requiredAmount,
      unit: unit,
      source: ShoppingItemSource.recipeMatch,
      recipeId: recipeId,
    );
  }

  Future<void> checkItem(int id) => _repo.checkItem(id);
  Future<void> deleteItem(int id) => _repo.delete(id);
}

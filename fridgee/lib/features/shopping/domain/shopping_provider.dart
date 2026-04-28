// Providery Riverpod dla listy zakupów (SQLite).

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/isar_service.dart';
import '../domain/shopping_item.dart';

part 'shopping_provider.g.dart';

const _uuid = Uuid();

// Repozytorium (wersja uproszczona pod Moduł 1).
class _ShoppingRepository {
  Database get _db => IsarService.instance;
  final _controller = StreamController<List<ShoppingItem>>.broadcast();

  Stream<List<ShoppingItem>> watchUnchecked() {
    _fetchUnchecked().then(_controller.add);
    return _controller.stream;
  }

  Future<List<ShoppingItem>> _fetchUnchecked() async {
    final maps = await _db.query(
      'shopping_items',
      where: 'is_checked = ?',
      whereArgs: [0],
      orderBy: 'added_date DESC',
    );
    return maps.map(ShoppingItem.fromMap).toList();
  }

  void _notify() => _fetchUnchecked().then(_controller.add);

  Future<void> add(ShoppingItem item) async {
    await _db.insert('shopping_items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _notify();
  }

  Future<void> checkItem(int id) async {
    await _db.update('shopping_items', {'is_checked': 1},
        where: 'id = ?', whereArgs: [id]);
    _notify();
  }

  Future<void> delete(int id) async {
    await _db
        .delete('shopping_items', where: 'id = ?', whereArgs: [id]);
    _notify();
  }

  void dispose() => _controller.close();
}

final _repo = _ShoppingRepository();

@riverpod
Stream<List<ShoppingItem>> shoppingItems(ShoppingItemsRef ref) {
  ref.onDispose(_repo.dispose);
  return _repo.watchUnchecked();
}

// Notifier do zarządzania listą zakupów.
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

  // Dodaje brakujące składniki z przepisów
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

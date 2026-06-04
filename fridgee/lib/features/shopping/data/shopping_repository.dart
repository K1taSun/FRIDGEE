// Dostęp do listy zakupów w SQLite.

import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../../core/database/isar_service.dart';
import '../domain/shopping_item.dart';

class ShoppingRepository {
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
    await _db.insert(
      'shopping_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notify();
  }

  Future<void> checkItem(int id) async {
    await _db.update(
      'shopping_items',
      {'is_checked': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    _notify();
  }

  Future<void> delete(int id) async {
    await _db.delete('shopping_items', where: 'id = ?', whereArgs: [id]);
    _notify();
  }

  void dispose() => _controller.close();
}

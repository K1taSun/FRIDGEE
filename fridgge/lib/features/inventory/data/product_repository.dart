// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — product_repository.dart
// CRUD operations for the products table (sqflite).
// ──────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/isar_service.dart';
import '../domain/product_item.dart';

const _uuid = Uuid();

class ProductRepository {
  Database get _db => IsarService.instance;

  // ── Streams ───────────────────────────────────────────────────────────────────
  // SQLite doesn't natively support change streams. We use a StreamController
  // that we broadcast after every write. Riverpod watches this stream.

  final _controller = StreamController<List<ProductItem>>.broadcast();

  Stream<List<ProductItem>> watchActiveProducts() {
    // Emit immediately and on every write
    _fetchActive().then(_controller.add);
    return _controller.stream;
  }

  void _notifyListeners() {
    _fetchActive().then(_controller.add);
  }

  // ── Read ──────────────────────────────────────────────────────────────────────

  Future<List<ProductItem>> _fetchActive() async {
    final maps = await _db.query(
      'products',
      where: 'is_consumed = ?',
      whereArgs: [0],
      orderBy: 'expiry_date ASC',
    );
    return maps.map(ProductItem.fromMap).toList();
  }

  Future<List<ProductItem>> getActiveProducts() => _fetchActive();

  Future<ProductItem?> getById(int id) async {
    final maps =
        await _db.query('products', where: 'id = ?', whereArgs: [id]);
    return maps.isEmpty ? null : ProductItem.fromMap(maps.first);
  }

  // ── Create / Update ───────────────────────────────────────────────────────────

  Future<int> save(ProductItem product) async {
    final uuid = product.uuid.isEmpty ? _uuid.v4() : product.uuid;
    final map = product.copyWith().toMap();
    map['uuid'] = uuid;

    final id = await _db.insert(
      'products',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyListeners();
    return id;
  }

  Future<void> saveAll(List<ProductItem> products) async {
    final batch = _db.batch();
    for (final p in products) {
      batch.insert(
        'products',
        (p.uuid.isEmpty ? p.copyWith() : p).toMap()
          ..['uuid'] = p.uuid.isEmpty ? _uuid.v4() : p.uuid,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    _notifyListeners();
  }

  Future<int> addFromPreset(QuickStartPreset preset) {
    final item = ProductItem.create(
      uuid: _uuid.v4(),
      name: preset.name,
      quantity: preset.defaultQuantity,
      unit: preset.unit,
      expiryDate:
          DateTime.now().add(Duration(days: preset.expiryOffsetDays)),
      storageLocation: preset.storageLocation,
      category: preset.category,
    );
    return save(item);
  }

  // ── Mark consumed (soft delete) ───────────────────────────────────────────────

  Future<void> markConsumed(int id) async {
    await _db.update(
      'products',
      {'is_consumed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    _notifyListeners();
  }

  // ── Hard delete ───────────────────────────────────────────────────────────────

  Future<int> delete(int id) async {
    final count = await _db.delete('products', where: 'id = ?', whereArgs: [id]);
    _notifyListeners();
    return count;
  }

  void dispose() => _controller.close();
}

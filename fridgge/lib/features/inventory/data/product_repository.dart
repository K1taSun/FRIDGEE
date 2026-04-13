// Klasa Repository — odpowiada za bezpośredni dostęp do danych w SQLite.
// Izoluje logikę bazodanową od reszty aplikacji.

import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/isar_service.dart';
import '../domain/product_item.dart';

const _uuid = Uuid();

class ProductRepository {
  // Pobieramy instancję bazy danych z serwisu globalnego.
  Database get _db => IsarService.instance;

  // StreamController pozwala "nadawać" (broadcast) informację o zmianach w bazie.
  // sqflite nie oferuje natywnych strumieni, więc implementujemy je manualnie,
  // aby UI mogło automatycznie odświeżać się po każdej operacji CRUD.
  final _controller = StreamController<List<ProductItem>>.broadcast();

  // Zwraca strumień aktywnych produktów. Od razu po zasubskrybowaniu wysyła aktualne dane.
  Stream<List<ProductItem>> watchActiveProducts() {
    _fetchActive().then(_controller.add);
    return _controller.stream;
  }

  // Pomocnicza funkcja do wywoływania odświeżenia we wszystkich subskrybentach strumienia.
  void _notifyListeners() {
    _fetchActive().then(_controller.add);
  }

  // Pobiera aktywne produkty (niezużyte) posortowane chronologicznie wg daty ważności.
  Future<List<ProductItem>> _fetchActive() async {
    final maps = await _db.query(
      'products',
      where: 'is_consumed = ?',
      whereArgs: [0],
      orderBy: 'expiry_date ASC',
    );
    // Konwertujemy mapy z SQLite na obiekty Dartowe (ProductItem).
    return maps.map(ProductItem.fromMap).toList();
  }

  Future<List<ProductItem>> getActiveProducts() => _fetchActive();

  Future<ProductItem?> getById(int id) async {
    final maps =
        await _db.query('products', where: 'id = ?', whereArgs: [id]);
    return maps.isEmpty ? null : ProductItem.fromMap(maps.first);
  }

  // Zapisuje lub aktualizuje produkt. 
  // conflictAlgorithm: replace — jeśli produkt o takim samym ID już istnieje, zostanie zastąpiony.
  Future<int> save(ProductItem product) async {
    final uuid = product.uuid.isEmpty ? _uuid.v4() : product.uuid;
    final map = product.copyWith().toMap();
    map['uuid'] = uuid;

    final id = await _db.insert(
      'products',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyListeners(); // Powiadom strumień o zmianie
    return id;
  }

  // Wstawianie wielu produktów jednocześnie (Batch) — znacznie wydajniejsze przy imporcie.
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

  // Logika dodawania produktu z "Szybkiego Startu".
  // Oblicza datę ważności na podstawie dzisiejszej daty + offsetu zdefiniowanego w presecie.
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

  // 'Miękkie' usunięcie produktu (oznaczenie flagi is_consumed).
  Future<void> markConsumed(int id) async {
    await _db.update(
      'products',
      {'is_consumed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    _notifyListeners();
  }

  // Fizyczne usunięcie rekordu z bazy danych.
  Future<int> delete(int id) async {
    final count = await _db.delete('products', where: 'id = ?', whereArgs: [id]);
    _notifyListeners();
    return count;
  }

  // Zamknięcie kontrolera strumienia, aby uniknąć wycieków pamięci.
  void dispose() => _controller.close();
}

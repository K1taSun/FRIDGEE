// Serwis zarządzający bazą danych SQLite (przy użyciu pakietu sqflite).

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IsarService {
  IsarService._();

  static Database? _db;

  static Database get instance {
    assert(_db != null, 'Błąd: IsarService.initialize() musi być wywołane w main.dart.');
    return _db!;
  }

  static Future<void> initialize() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fridgee.db');

    _db = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    debugPrint('✅ Baza SQLite zainicjalizowana pomyślnie: $path');
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid            TEXT    NOT NULL UNIQUE,
        name            TEXT    NOT NULL,
        quantity        REAL    NOT NULL,
        unit            TEXT    NOT NULL,
        expiry_date     INTEGER NOT NULL,
        added_date      INTEGER NOT NULL,
        storage_location TEXT   NOT NULL,
        barcode         TEXT,
        image_url       TEXT,
        category        TEXT,
        calories_per_100g REAL,
        is_consumed     INTEGER NOT NULL DEFAULT 0,
        is_opened       INTEGER NOT NULL DEFAULT 0,  -- Nowa flaga
        opened_at       INTEGER                      -- Nowy czas otwarcia
      )
    ''');

    await db.execute('''
      CREATE TABLE shopping_items (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid        TEXT    NOT NULL UNIQUE,
        name        TEXT    NOT NULL,
        quantity    REAL    NOT NULL,
        unit        TEXT    NOT NULL,
        added_date  INTEGER NOT NULL,
        source      TEXT    NOT NULL,
        is_checked  INTEGER NOT NULL DEFAULT 0,
        note        TEXT,
        recipe_id   TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE storage_zones (
        id   TEXT PRIMARY KEY,
        name TEXT,
        emoji TEXT,
        type TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_products_expiry ON products(expiry_date)');
    await db.execute('CREATE INDEX idx_products_consumed ON products(is_consumed)');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE products ADD COLUMN is_opened INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE products ADD COLUMN opened_at INTEGER');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS storage_zones (
          id   TEXT PRIMARY KEY,
          name TEXT,
          emoji TEXT,
          type TEXT
        )
      ''');
    }
  }

  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
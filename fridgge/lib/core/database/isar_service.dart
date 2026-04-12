// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — isar_service.dart  (renamed concept — now uses sqflite)
// SQLite database service via sqflite. Offline-first, no code-gen required.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IsarService {
  IsarService._();

  static Database? _db;

  /// Returns the open database instance.
  static Database get instance {
    assert(_db != null, 'IsarService.initialize() must be called in main().');
    return _db!;
  }

  /// Opens (or creates) the SQLite database and runs migrations.
  static Future<void> initialize() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fridgge.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    debugPrint('✅ SQLite database opened at: $path');
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
        is_consumed     INTEGER NOT NULL DEFAULT 0
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

    // Index for fast expiry sorting
    await db.execute(
        'CREATE INDEX idx_products_expiry ON products(expiry_date)');
    await db.execute(
        'CREATE INDEX idx_products_consumed ON products(is_consumed)');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Future schema migrations will be handled here
  }

  /// Closes the database. Use only in tests.
  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}

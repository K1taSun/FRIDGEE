// Serwis zarządzający bazą danych SQLite (przy użyciu pakietu sqflite).
// Stosujemy podejście offline-first — aplikacja działa bez internetu, korzystając z lokalnej bazy.

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IsarService {
  // Prywatny konstruktor — uniemożliwia tworzenie instancji klasy (wzorzec Singleton).
  IsarService._();

  static Database? _db;

  // Globalny dostęp do bazy danych. Metoda get rzuci błąd, jeśli zapomnimy o IsarService.initialize().
  static Database get instance {
    assert(_db != null, 'Błąd: IsarService.initialize() musi być wywołane w main.dart.');
    return _db!;
  }

  // Funkcja otwierająca połączenie z bazą. Wywoływana raz przy starcie aplikacji.
  static Future<void> initialize() async {
    if (_db != null) return;

    // Pobieramy systemową ścieżkę do bazy danych
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fridgge.db');

    // openDatabase tworzy plik, jeśli nie istnieje, i wywołuje _onCreate.
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    debugPrint('✅ Baza SQLite zainicjalizowana pomyślnie: $path');
  }

  // Definicja tabel i struktury bazy danych.
  static Future<void> _onCreate(Database db, int version) async {
    // Tabela 'products': przechowuje to, co użytkownik ma w lodówce/spiżarni.
    await db.execute('''
      CREATE TABLE products (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid            TEXT    NOT NULL UNIQUE, -- ID do synchronizacji z chmurą
        name            TEXT    NOT NULL,
        quantity        REAL    NOT NULL,
        unit            TEXT    NOT NULL,
        expiry_date     INTEGER NOT NULL, -- Przechowujemy jako timestamp (milisekundy)
        added_date      INTEGER NOT NULL,
        storage_location TEXT   NOT NULL,
        barcode         TEXT,
        image_url       TEXT,
        category        TEXT,
        calories_per_100g REAL,
        is_consumed     INTEGER NOT NULL DEFAULT 0 -- Flaga 'miękkiego usunięcia'
      )
    ''');

    // Tabela 'shopping_items': elementy listy zakupów.
    await db.execute('''
      CREATE TABLE shopping_items (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid        TEXT    NOT NULL UNIQUE,
        name        TEXT    NOT NULL,
        quantity    REAL    NOT NULL,
        unit        TEXT    NOT NULL,
        added_date  INTEGER NOT NULL,
        source      TEXT    NOT NULL, -- Informacja skąd pochodzi (np. manual, przepis)
        is_checked  INTEGER NOT NULL DEFAULT 0,
        note        TEXT,
        recipe_id   TEXT
      )
    ''');

    // Indeksy przyspieszają wyszukiwanie i sortowanie danych.
    // Są kluczowe, gdy baza urosnie do setek produktów.
    await db.execute(
        'CREATE INDEX idx_products_expiry ON products(expiry_date)');
    await db.execute(
        'CREATE INDEX idx_products_consumed ON products(is_consumed)');
  }

  // Miejsce na przyszłe aktualizacje struktury bazy danych (Migracje).
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Implementacja migracji przy zmianie wersji bazy (np. dodanie nowej kolumny).
  }

  // Zamyka połączenie z bazą danych — przydatne głównie w testach jednostkowych.
  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}

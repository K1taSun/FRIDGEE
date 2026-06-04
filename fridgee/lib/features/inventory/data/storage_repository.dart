// CRUD stref przechowywania w SQLite.

import 'package:sqflite/sqflite.dart';

import '../../../core/database/isar_service.dart';

class StorageRepository {
  Database get _db => IsarService.instance;

  Future<List<Map<String, dynamic>>> getAll() async {
    return _db.query('storage_zones');
  }

  Future<void> save(Map<String, dynamic> zone) async {
    await _db.insert(
      'storage_zones',
      zone,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    await _db.delete('storage_zones', where: 'id = ?', whereArgs: [id]);
  }
}

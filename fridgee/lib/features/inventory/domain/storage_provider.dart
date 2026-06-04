// Niestandardowe strefy przechowywania (lodówka, zamrażarka, …).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/storage_repository.dart';

class CustomStorageNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CustomStorageNotifier() : super([]) {
    _loadFromDb();
  }

  final _repo = StorageRepository();

  Future<void> _loadFromDb() async {
    final data = await _repo.getAll();
    if (data.isNotEmpty) {
      state = data;
    } else {
      final defaultFridge = {
        'id': const Uuid().v4(),
        'name': 'Główna Lodówka',
        'emoji': '❄️',
        'type': 'lodówka',
      };
      await _repo.save(defaultFridge);
      state = [defaultFridge];
    }
  }

  Future<void> addZone(String name, String emoji, String type) async {
    final newZone = {'id': const Uuid().v4(), 'name': name, 'emoji': emoji, 'type': type};
    await _repo.save(newZone);
    state = [...state, newZone];
  }

  Future<void> removeZone(String id) async {
    await _repo.delete(id);
    state = state.where((zone) => zone['id'] != id).toList();
  }
}

final customStorageObjectsProvider =
    StateNotifierProvider<CustomStorageNotifier, List<Map<String, dynamic>>>(
  (ref) => CustomStorageNotifier(),
);

// Produkty oznaczone jako otwarte (pamięć sesji UI).

import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenedProductsNotifier extends StateNotifier<Set<String>> {
  OpenedProductsNotifier() : super({});

  void toggle(String uuid) {
    if (state.contains(uuid)) {
      state = {...state}..remove(uuid);
    } else {
      state = {...state, uuid};
    }
  }
}

final openedProductsProvider =
    StateNotifierProvider<OpenedProductsNotifier, Set<String>>(
  (ref) => OpenedProductsNotifier(),
);

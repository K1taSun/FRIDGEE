// ──────────────────────────────────────────────────────────────────────────────
// Fridgee — expiry_date_calculator.dart
// Zaawansowana estymacja daty na bazie strefy (Lodówka/Szafka/Zamrażarka) i kategorii.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inventory/domain/storage_provider.dart';

class ExpiryDateCalculator {
  /// Zwraca przewidywaną datę ważności bazując na wybranej strefie i typie produktu
  static DateTime calculate({
    required WidgetRef ref,
    required String? storageObjectId,
    required String productType,
  }) {
    int days = 7; // Domyślna wartość awaryjna
    
    final currentStorageObjects = ref.read(customStorageObjectsProvider);
    String storageType = 'lodówka';
    
    // Rozpoznanie, do jakiej strefy trafi produkt
    if (storageObjectId != null && currentStorageObjects.isNotEmpty) {
      final targetStorage = currentStorageObjects.firstWhere(
        (o) => o['id'] == storageObjectId,
        orElse: () => {'type': 'lodówka'},
      );
      // Ujednolicenie do małych liter, by nie pominąć żadnego dopasowania
      storageType = (targetStorage['type'] as String? ?? 'lodówka').toLowerCase();
    }

    // ────────────────────────────────────────────────────────
    // GŁÓWNA LOGIKA ESTYMACJI DATY
    // ────────────────────────────────────────────────────────
    
    if (storageType.contains('zamrażarka') || storageType.contains('freezer')) {
      // ❄️ ZAMRAŻARKA (Ekstremalnie długi czas życia)
      switch (productType) {
        case 'mięso': days = 180; break;   // Mięso i ryby - 6 miesięcy
        case 'warzywa': days = 240; break; // Mrożonki warzywne - 8 miesięcy
        case 'owoce': days = 240; break;   // Mrożone owoce - 8 miesięcy
        case 'pieczywo': days = 90; break; // Zamrożony chleb - 3 miesiące
        case 'nabiał': days = 60; break;   // Zamrożone masło/sery - 2 miesiące
        case 'napoje': days = 30; break;   // Płyny (np. lód/bulion) - 1 miesiąc
        default: days = 180; break;        // Inne - domyślnie pół roku
      }
    } 
    else if (storageType.contains('szafka') || storageType.contains('spiżarnia') || storageType.contains('pantry')) {
      // 🥫 SZAFKA / SPIŻARNIA (Temp. pokojowa, środowisko suche)
      switch (productType) {
        case 'pieczywo': days = 3; break;  // Chleb w chlebaku (krótki czas)
        case 'warzywa': days = 14; break;  // Ziemniaki, cebula, czosnek
        case 'owoce': days = 7; break;     // Banany, jabłka, awokado
        case 'mięso': days = 1; break;     // AWARYJNIE: Surowe mięso psuje się od razu!
        case 'nabiał': days = 1; break;    // AWARYJNIE: Mleko/Sery poza lodówką
        case 'napoje': days = 365; break;  // Woda, zgrzewki soków - rok
        default: days = 365; break;        // Inne (konserwy, makarony, ryż, mąka) - rok
      }
    } 
    else {
      // 🧊 LODÓWKA (Domyślne środowisko dla świeżej żywności)
      switch (productType) {
        case 'mięso': days = 2; break;     // Świeże mięso / ryby żyją bardzo krótko
        case 'nabiał': days = 7; break;    // Sery, jogurty, mleko otwarte
        case 'warzywa': days = 10; break;  // Warzywa w dolnej szufladzie
        case 'owoce': days = 10; break;    // Owoce w dolnej szufladzie
        case 'pieczywo': days = 5; break;  // Czasem trzymane w lodówce na pleśń
        case 'napoje': days = 14; break;   // Soki, mleko w butelce
        default: days = 30; break;         // Słoiki (dżemy, ketchupy, musztardy) - miesiąc
      }
    }

    return DateTime.now().add(Duration(days: days));
  }
}
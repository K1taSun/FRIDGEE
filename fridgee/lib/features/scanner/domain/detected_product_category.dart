// Mapowanie nazwy z detekcji AI / OCR na typ produktu w formularzu.

abstract final class DetectedProductCategory {
  static const _owoce = {
    'Truskawka', 'Banan', 'Jabłko', 'Pomarańcza', 'Cytryna', 'Limonka',
    'Brzoskwinia', 'Gruszka', 'Winogrono', 'Arbuz', 'Śliwka', 'Czereśnia / Wiśnia',
    'Borówka', 'Malina', 'Jeżyna', 'Ananas', 'Mango', 'Kiwi', 'Awokado',
    'Granat', 'Kokos', 'Owoc (Inny)',
  };

  static const _warzywa = {
    'Pomidor', 'Ziemniak', 'Cebula', 'Marchew', 'Ogórek', 'Papryka', 'Czosnek',
    'Brokuł', 'Kapusta', 'Sałata', 'Szpinak', 'Pieczarka / Grzyb', 'Rzodkiewka',
    'Kukurydza', 'Cukinia', 'Bakłażan', 'Kalafior', 'Szparagi', 'Burak', 'Seler',
    'Warzywo (Inne)',
  };

  static const _pieczywo = {
    'Chleb', 'Bułka', 'Croissant', 'Bagietka', 'Bajgiel', 'Precel',
    'Chleb tostowy', 'Pieczywo',
  };

  /// Zwraca wartość `type:` dla serializacji kategorii lub `null` jeśli nie rozpoznano.
  static String? typeForName(String aiName) {
    if (_owoce.contains(aiName)) return 'owoce';
    if (_warzywa.contains(aiName)) return 'warzywa';
    if (_pieczywo.contains(aiName)) return 'pieczywo';
    if (aiName == 'Mięso' || aiName == 'Ryba') return 'mięso';
    if (aiName == 'Nabiał' || aiName == 'Ser') return 'nabiał';
    return null;
  }
}

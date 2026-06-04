// Etykiety YOLO (63 klasy LVIS) + mapowanie na polskie nazwy.

class FreshProduceLabels {
  FreshProduceLabels._();

  static const int numClasses = 63;

  /// Indeks klasy → surowa etykieta angielska (kolejność z data.yaml henningheyen).
  static const List<String> english = [
    'almond', 'apple', 'apricot', 'artichoke', 'asparagus', 'avocado', 'banana',
    'bean curd/tofu', 'bell pepper/capsicum', 'blackberry', 'blueberry', 'broccoli',
    'brussels sprouts', 'cantaloup/cantaloupe', 'carrot', 'cauliflower',
    'cayenne/cayenne spice/cayenne pepper/cayenne pepper spice/red pepper/red pepper',
    'celery', 'cherry', 'chickpea/garbanzo',
    'chili/chili vegetable/chili pepper/chili pepper vegetable/chilli/chilli vegetable/chilly/chilly',
    'clementine', 'coconut/cocoanut', 'edible corn/corn/maize', 'cucumber/cuke',
    'date/date fruit', 'eggplant/aubergine', 'fig/fig fruit', 'garlic/ail',
    'ginger/gingerroot', 'strawberry', 'gourd', 'grape', 'green bean',
    'green onion/spring onion/scallion', 'tomato', 'kiwi fruit', 'lemon', 'lettuce',
    'lime', 'mandarin orange', 'melon', 'mushroom', 'onion', 'orange/orange fruit',
    'papaya', 'pea/pea food', 'peach', 'pear', 'persimmon', 'pickle', 'pineapple',
    'potato', 'prune', 'pumpkin', 'radish/daikon', 'raspberry', 'strawberry',
    'sweet potato', 'tomato', 'turnip', 'watermelon', 'zucchini/courgette',
  ];

  /// Główne słowo kluczowe z etykiety (przed /).
  static String primaryKeyword(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('/')) return lower.split('/').first.trim();
    return lower.trim();
  }

  static const Map<String, String> _polish = {
    'almond': 'Migdał',
    'apple': 'Jabłko',
    'apricot': 'Morela',
    'artichoke': 'Karczoch',
    'asparagus': 'Szparagi',
    'avocado': 'Awokado',
    'banana': 'Banan',
    'bean curd': 'Tofu',
    'tofu': 'Tofu',
    'bell pepper': 'Papryka',
    'capsicum': 'Papryka',
    'blackberry': 'Jeżyna',
    'blueberry': 'Borówka',
    'broccoli': 'Brokuł',
    'brussels sprouts': 'Brukselka',
    'cantaloup': 'Kantalup',
    'cantaloupe': 'Melon kantalup',
    'carrot': 'Marchew',
    'cauliflower': 'Kalafior',
    'cayenne': 'Pieprz cayenne',
    'celery': 'Seler',
    'cherry': 'Wiśnia',
    'chickpea': 'Ciecierzyca',
    'garbanzo': 'Ciecierzyca',
    'chili': 'Papryczka chili',
    'chilli': 'Papryczka chili',
    'chilly': 'Papryczka chili',
    'clementine': 'Klementynka',
    'coconut': 'Kokos',
    'cocoanut': 'Kokos',
    'edible corn': 'Kukurydza',
    'corn': 'Kukurydza',
    'maize': 'Kukurydza',
    'cucumber': 'Ogórek',
    'cuke': 'Ogórek',
    'date': 'Daktyle',
    'eggplant': 'Bakłażan',
    'aubergine': 'Bakłażan',
    'fig': 'Figa',
    'garlic': 'Czosnek',
    'ail': 'Czosnek',
    'ginger': 'Imbir',
    'gingerroot': 'Imbir',
    'strawberry': 'Truskawka',
    'gourd': 'Tykwa',
    'grape': 'Winogrono',
    'green bean': 'Fasolka szparagowa',
    'green onion': 'Szczypiorek',
    'spring onion': 'Szczypiorek',
    'scallion': 'Szczypiorek',
    'tomato': 'Pomidor',
    'kiwi fruit': 'Kiwi',
    'kiwi': 'Kiwi',
    'lemon': 'Cytryna',
    'lettuce': 'Sałata',
    'lime': 'Limonka',
    'mandarin orange': 'Mandarynka',
    'mandarin': 'Mandarynka',
    'melon': 'Melon',
    'mushroom': 'Pieczarka / Grzyb',
    'onion': 'Cebula',
    'orange': 'Pomarańcza',
    'papaya': 'Papaja',
    'pea': 'Groch',
    'peach': 'Brzoskwinia',
    'pear': 'Gruszka',
    'persimmon': 'Persymona',
    'pickle': 'Ogórek kiszony',
    'pineapple': 'Ananas',
    'potato': 'Ziemniak',
    'prune': 'Śliwka suszona',
    'pumpkin': 'Dynia',
    'radish': 'Rzodkiewka',
    'daikon': 'Rzodkiewka',
    'raspberry': 'Malina',
    'sweet potato': 'Batat',
    'turnip': 'Rzepa',
    'watermelon': 'Arbuz',
    'zucchini': 'Cukinia',
    'courgette': 'Cukinia',
    // Pieczywo — klasy pomocnicze (model COCO / rozszerzenie)
    'bread': 'Chleb',
    'baguette': 'Bagietka',
    'croissant': 'Croissant',
    'bun': 'Bułka',
    'roll': 'Bułka',
    'bagel': 'Bajgiel',
    'pretzel': 'Precel',
    'loaf': 'Chleb',
    'sandwich': 'Kanapka',
    'donut': 'Pączek',
    'doughnut': 'Pączek',
    'cake': 'Ciasto',
  };

  static String toPolish(int classIndex) {
    if (classIndex < 0 || classIndex >= english.length) return 'Produkt';
    final label = english[classIndex];
    final key = primaryKeyword(label);
    if (_polish.containsKey(key)) return _polish[key]!;
    for (final entry in _polish.entries) {
      if (key.contains(entry.key) || entry.key.contains(key)) {
        return entry.value;
      }
    }
    return _capitalize(key);
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

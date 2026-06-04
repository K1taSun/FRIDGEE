// Emoji ikon produktów wg typu (nie miejsca przechowywania).

abstract final class ProductTypeIcons {
  static String emojiForType(String? type) => switch (type) {
        'warzywa' => '🥦',
        'owoce' => '🍎',
        'pieczywo' => '🥖',
        'nabiał' => '🥛',
        'mięso' => '🥩',
        'napoje' => '🧃',
        'inne' => '🥫',
        _ => '📦',
      };

  static String labelForType(String? type) => switch (type) {
        'warzywa' => 'Warzywa',
        'owoce' => 'Owoce',
        'pieczywo' => 'Pieczywo',
        'nabiał' => 'Nabiał',
        'mięso' => 'Mięso',
        'napoje' => 'Napoje',
        'inne' => 'Inne',
        _ => 'Produkt',
      };
}

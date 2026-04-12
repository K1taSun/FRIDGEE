// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — shopping_item.dart
// Domain model and sqflite DAO for the Shopping List.
// ──────────────────────────────────────────────────────────────────────────────

/// Source: how the item was added to the shopping list.
enum ShoppingItemSource {
  manual,
  recipeMatch,
  inventoryReorder,
}

/// An item on the shopping list.
class ShoppingItem {
  ShoppingItem({
    this.dbId,
    required this.uuid,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.addedDate,
    this.source = ShoppingItemSource.manual,
    this.isChecked = false,
    this.note,
    this.recipeId,
  });

  final int? dbId;
  final String uuid;
  final String name;
  final double quantity;
  final String unit;
  final DateTime addedDate;
  final ShoppingItemSource source;
  final bool isChecked;
  final String? note;
  final String? recipeId;

  factory ShoppingItem.create({
    required String uuid,
    required String name,
    required double quantity,
    required String unit,
    ShoppingItemSource source = ShoppingItemSource.manual,
    String? note,
    String? recipeId,
  }) {
    return ShoppingItem(
      uuid: uuid,
      name: name,
      quantity: quantity,
      unit: unit,
      addedDate: DateTime.now(),
      source: source,
      note: note,
      recipeId: recipeId,
    );
  }

  ShoppingItem copyWith({bool? isChecked}) => ShoppingItem(
        dbId: dbId,
        uuid: uuid,
        name: name,
        quantity: quantity,
        unit: unit,
        addedDate: addedDate,
        source: source,
        isChecked: isChecked ?? this.isChecked,
        note: note,
        recipeId: recipeId,
      );

  Map<String, dynamic> toMap() => {
        if (dbId != null) 'id': dbId,
        'uuid': uuid,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'added_date': addedDate.millisecondsSinceEpoch,
        'source': source.name,
        'is_checked': isChecked ? 1 : 0,
        'note': note,
        'recipe_id': recipeId,
      };

  factory ShoppingItem.fromMap(Map<String, dynamic> map) => ShoppingItem(
        dbId: map['id'] as int?,
        uuid: map['uuid'] as String,
        name: map['name'] as String,
        quantity: (map['quantity'] as num).toDouble(),
        unit: map['unit'] as String,
        addedDate: DateTime.fromMillisecondsSinceEpoch(map['added_date'] as int),
        source: ShoppingItemSource.values.byName(map['source'] as String),
        isChecked: (map['is_checked'] as int) == 1,
        note: map['note'] as String?,
        recipeId: map['recipe_id'] as String?,
      );
}

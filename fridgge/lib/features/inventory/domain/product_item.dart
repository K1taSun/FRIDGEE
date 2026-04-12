// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — product_item.dart
// Domain model for pantry/fridge/freezer items.
// Stored locally via sqflite. Synced to Firebase Firestore in Module 2.
// ──────────────────────────────────────────────────────────────────────────────

// ── Enumerations ──────────────────────────────────────────────────────────────

/// Unit of measurement for a product's quantity.
enum StorageUnit {
  szt,   // pieces / sztuki
  g,     // grams / gramy
  ml,    // millilitres / mililitry
  kg,    // kilograms / kilogramy
  l,     // litres / litry
}

/// Physical location where the product is stored.
enum StorageLocation {
  fridge,   // Lodówka
  freezer,  // Zamrażarka
  pantry,   // Spiżarnia
}

// ── Domain Entity ─────────────────────────────────────────────────────────────

/// A product stored in the user's inventory.
class ProductItem {
  ProductItem({
    this.dbId,
    required this.uuid,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.addedDate,
    required this.storageLocation,
    this.barcode,
    this.imageUrl,
    this.category,
    this.caloriesPer100g,
    this.isConsumed = false,
  });

  /// SQLite auto-increment primary key (null before first insert).
  final int? dbId;

  /// UUID v4 — stable identifier used for Firebase Firestore sync.
  final String uuid;

  /// Display name of the product.
  final String name;

  /// Numeric quantity (e.g. 1.5 kg, 200 g).
  final double quantity;

  /// Unit of measurement.
  final StorageUnit unit;

  /// Expiry / best-before date (core sorting field).
  final DateTime expiryDate;

  /// Date when the item was added to the inventory.
  final DateTime addedDate;

  /// Physical storage location.
  final StorageLocation storageLocation;

  /// EAN barcode string (nullable — manual entries have none).
  final String? barcode;

  /// URL of the product image.
  final String? imageUrl;

  /// Optional category tag (e.g. "Nabiał", "Warzywa").
  final String? category;

  /// Calories per 100 g/ml (from Open Food Facts or USDA).
  final double? caloriesPer100g;

  /// Whether the product has been consumed (soft-delete).
  final bool isConsumed;

  // ── Factory constructor ──────────────────────────────────────────────────────

  factory ProductItem.create({
    required String uuid,
    required String name,
    required double quantity,
    required StorageUnit unit,
    required DateTime expiryDate,
    required StorageLocation storageLocation,
    String? barcode,
    String? imageUrl,
    String? category,
    double? caloriesPer100g,
  }) {
    return ProductItem(
      uuid: uuid,
      name: name,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      addedDate: DateTime.now(),
      storageLocation: storageLocation,
      barcode: barcode,
      imageUrl: imageUrl,
      category: category,
      caloriesPer100g: caloriesPer100g,
    );
  }

  // ── Immutable copy ────────────────────────────────────────────────────────────

  ProductItem copyWith({
    int? dbId,
    String? uuid,
    String? name,
    double? quantity,
    StorageUnit? unit,
    DateTime? expiryDate,
    DateTime? addedDate,
    StorageLocation? storageLocation,
    String? barcode,
    String? imageUrl,
    String? category,
    double? caloriesPer100g,
    bool? isConsumed,
  }) {
    return ProductItem(
      dbId: dbId ?? this.dbId,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      addedDate: addedDate ?? this.addedDate,
      storageLocation: storageLocation ?? this.storageLocation,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      isConsumed: isConsumed ?? this.isConsumed,
    );
  }

  // ── SQLite serialization ──────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        if (dbId != null) 'id': dbId,
        'uuid': uuid,
        'name': name,
        'quantity': quantity,
        'unit': unit.name,
        'expiry_date': expiryDate.millisecondsSinceEpoch,
        'added_date': addedDate.millisecondsSinceEpoch,
        'storage_location': storageLocation.name,
        'barcode': barcode,
        'image_url': imageUrl,
        'category': category,
        'calories_per_100g': caloriesPer100g,
        'is_consumed': isConsumed ? 1 : 0,
      };

  factory ProductItem.fromMap(Map<String, dynamic> map) => ProductItem(
        dbId: map['id'] as int?,
        uuid: map['uuid'] as String,
        name: map['name'] as String,
        quantity: (map['quantity'] as num).toDouble(),
        unit: StorageUnit.values.byName(map['unit'] as String),
        expiryDate: DateTime.fromMillisecondsSinceEpoch(
            map['expiry_date'] as int),
        addedDate: DateTime.fromMillisecondsSinceEpoch(
            map['added_date'] as int),
        storageLocation: StorageLocation.values
            .byName(map['storage_location'] as String),
        barcode: map['barcode'] as String?,
        imageUrl: map['image_url'] as String?,
        category: map['category'] as String?,
        caloriesPer100g: (map['calories_per_100g'] as num?)?.toDouble(),
        isConsumed: (map['is_consumed'] as int) == 1,
      );

  @override
  String toString() =>
      'ProductItem($uuid, $name, exp: $expiryDate, loc: $storageLocation)';
}

// ── Quick Start presets ───────────────────────────────────────────────────────

/// Predefined products for the Quick Start onboarding grid.
class QuickStartPreset {
  const QuickStartPreset({
    required this.name,
    required this.unit,
    required this.storageLocation,
    required this.defaultQuantity,
    required this.expiryOffsetDays,
    required this.emoji,
    this.category,
  });

  final String name;
  final StorageUnit unit;
  final StorageLocation storageLocation;
  final double defaultQuantity;
  final int expiryOffsetDays;
  final String emoji;
  final String? category;

  static const List<QuickStartPreset> all = [
    QuickStartPreset(
      name: 'Jajka', unit: StorageUnit.szt,
      storageLocation: StorageLocation.fridge,
      defaultQuantity: 10, expiryOffsetDays: 21,
      emoji: '🥚', category: 'Nabiał',
    ),
    QuickStartPreset(
      name: 'Masło', unit: StorageUnit.g,
      storageLocation: StorageLocation.fridge,
      defaultQuantity: 200, expiryOffsetDays: 30,
      emoji: '🧈', category: 'Nabiał',
    ),
    QuickStartPreset(
      name: 'Mleko', unit: StorageUnit.ml,
      storageLocation: StorageLocation.fridge,
      defaultQuantity: 1000, expiryOffsetDays: 7,
      emoji: '🥛', category: 'Nabiał',
    ),
    QuickStartPreset(
      name: 'Makaron', unit: StorageUnit.g,
      storageLocation: StorageLocation.pantry,
      defaultQuantity: 500, expiryOffsetDays: 365,
      emoji: '🍝', category: 'Suche',
    ),
    QuickStartPreset(
      name: 'Ketchup', unit: StorageUnit.g,
      storageLocation: StorageLocation.fridge,
      defaultQuantity: 400, expiryOffsetDays: 90,
      emoji: '🍅', category: 'Sosy',
    ),
    QuickStartPreset(
      name: 'Chleb', unit: StorageUnit.szt,
      storageLocation: StorageLocation.pantry,
      defaultQuantity: 1, expiryOffsetDays: 5,
      emoji: '🍞', category: 'Pieczywo',
    ),
    QuickStartPreset(
      name: 'Ser żółty', unit: StorageUnit.g,
      storageLocation: StorageLocation.fridge,
      defaultQuantity: 300, expiryOffsetDays: 14,
      emoji: '🧀', category: 'Nabiał',
    ),
    QuickStartPreset(
      name: 'Ryż', unit: StorageUnit.g,
      storageLocation: StorageLocation.pantry,
      defaultQuantity: 1000, expiryOffsetDays: 730,
      emoji: '🍚', category: 'Suche',
    ),
  ];
}

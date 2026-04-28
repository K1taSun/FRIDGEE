// ──────────────────────────────────────────────────────────────────────────────
// Fridgee — recipe.dart
// Klasy danych dla generowanych przepisów.
// Mapowanie odpowiedzi JSON z serwera.
//
// Generowanie kodu: dart run build_runner build --delete-conflicting-outputs
// ──────────────────────────────────────────────────────────────────────────────

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

// ── RecipeIngredient ──────────────────────────────────────────────────────────

@freezed
class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    /// Name of the ingredient (e.g. "Jajko", "Mąka").
    required String name,

    /// Amount required by the recipe.
    required double requiredAmount,

    /// Unit string (e.g. "szt", "g", "ml").
    required String unit,

    /// True if this ingredient is currently in the user's Isar inventory.
    @Default(false) bool isMatchedInInventory,

    /// Amount available in inventory (null if not matched).
    double? availableAmount,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}

// ── Recipe ────────────────────────────────────────────────────────────────────

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    /// Stable identifier (UUID or LLM-generated slug).
    required String id,

    /// Display title of the recipe.
    required String title,

    /// Estimated preparation time in minutes.
    required int preparationTime,

    /// URL obrazka (placeholder lub wygenerowany).
    @Default('') String imageUrl,

    /// List of required ingredients with inventory match status.
    @Default([]) List<RecipeIngredient> ingredients,

    /// Step-by-step cooking instructions.
    @Default([]) List<String> instructions,

    /// Meal tags (e.g. ["Kolacja", "Wegetariańskie", "Szybkie"]).
    @Default([]) List<String> tags,

    /// Whether the user has saved this recipe as a favourite.
    @Default(false) bool isFavorite,

    /// Difficulty level: "Łatwe", "Średnie", "Trudne".
    @Default('Łatwe') String difficulty,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

// ── Computed helpers (private extension) ─────────────────────────────────────

extension RecipeHelpers on Recipe {
  /// Number of ingredients present in the user's inventory.
  int get matchedIngredientCount =>
      ingredients.where((i) => i.isMatchedInInventory).length;

  /// True if all ingredients are available in inventory.
  bool get isFullyMatched => matchedIngredientCount == ingredients.length;

  /// Availability label shown in the recipe card (e.g. "3 z 5 w magazynie").
  String get availabilityLabel =>
      '$matchedIngredientCount z ${ingredients.length} w magazynie';
}

// ── LLM Response wrapper ──────────────────────────────────────────────────────

/// Struktura JSON odpowiedzi z serwera.
///
/// System prompt instructs the model to return:
/// ```json
/// { "recipes": [ { ... }, { ... }, { ... } ] }
/// ```
@freezed
class RecipeGenerationResponse with _$RecipeGenerationResponse {
  const factory RecipeGenerationResponse({
    @Default([]) List<Recipe> recipes,
  }) = _RecipeGenerationResponse;

  factory RecipeGenerationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecipeGenerationResponseFromJson(json);
}

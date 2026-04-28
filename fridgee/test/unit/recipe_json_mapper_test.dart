// ──────────────────────────────────────────────────────────────────────────────
// Fridgee — recipe_json_mapper_test.dart
// Unit tests for JSON → Recipe mapping (LLM response parsing).
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter_test/flutter_test.dart';
import 'package:fridgee/features/recipes/domain/recipe.dart';

void main() {
  // ── Sample JSON payload mimicking a Gemini/OpenAI response ────────────────
  const validJson = {
    'recipes': [
      {
        'id': 'recipe-001',
        'title': 'Jajecznica z warzywami',
        'preparationTime': 15,
        'imageUrl': '',
        'ingredients': [
          {
            'name': 'Jajko',
            'requiredAmount': 3.0,
            'unit': 'szt',
            'isMatchedInInventory': true,
            'availableAmount': 10.0,
          },
          {
            'name': 'Masło',
            'requiredAmount': 20.0,
            'unit': 'g',
            'isMatchedInInventory': false,
          },
        ],
        'instructions': [
          'Rozbij jajka do miski.',
          'Roztop masło na patelni.',
          'Wlej jajka i smaż mieszając.',
        ],
        'tags': ['Śniadanie', 'Szybkie'],
        'isFavorite': false,
        'difficulty': 'Łatwe',
      },
    ],
  };

  group('RecipeGenerationResponse.fromJson', () {
    test('parses a valid LLM JSON response', () {
      final response = RecipeGenerationResponse.fromJson(validJson);

      expect(response.recipes.length, 1);
    });

    test('maps recipe fields correctly', () {
      final recipe = RecipeGenerationResponse.fromJson(validJson).recipes.first;

      expect(recipe.id, 'recipe-001');
      expect(recipe.title, 'Jajecznica z warzywami');
      expect(recipe.preparationTime, 15);
      expect(recipe.tags, contains('Śniadanie'));
      expect(recipe.difficulty, 'Łatwe');
      expect(recipe.isFavorite, false);
    });

    test('parses ingredients with inventory match status', () {
      final recipe = RecipeGenerationResponse.fromJson(validJson).recipes.first;

      final egg = recipe.ingredients.first;
      expect(egg.name, 'Jajko');
      expect(egg.requiredAmount, 3.0);
      expect(egg.unit, 'szt');
      expect(egg.isMatchedInInventory, true);
      expect(egg.availableAmount, 10.0);

      final butter = recipe.ingredients[1];
      expect(butter.isMatchedInInventory, false);
      expect(butter.availableAmount, isNull);
    });

    test('parses instructions as ordered list', () {
      final recipe = RecipeGenerationResponse.fromJson(validJson).recipes.first;

      expect(recipe.instructions.length, 3);
      expect(recipe.instructions.first, 'Rozbij jajka do miski.');
    });

    test('returns empty recipes list for missing key', () {
      final response = RecipeGenerationResponse.fromJson({});
      expect(response.recipes, isEmpty);
    });
  });

  group('Recipe.fromJson (single recipe)', () {
    test('has correct defaults for missing optional fields', () {
      final recipe = Recipe.fromJson({
        'id': 'minimal',
        'title': 'Test',
        'preparationTime': 10,
      });

      expect(recipe.imageUrl, '');
      expect(recipe.ingredients, isEmpty);
      expect(recipe.instructions, isEmpty);
      expect(recipe.tags, isEmpty);
      expect(recipe.isFavorite, false);
      expect(recipe.difficulty, 'Łatwe');
    });
  });

  group('RecipeHelpers extension', () {
    test('matchedIngredientCount counts matched ingredients', () {
      final recipe = Recipe(
        id: 'r1',
        title: 'Test',
        preparationTime: 20,
        ingredients: [
          const RecipeIngredient(
            name: 'A', requiredAmount: 1, unit: 'szt',
            isMatchedInInventory: true,
          ),
          const RecipeIngredient(
            name: 'B', requiredAmount: 1, unit: 'g',
            isMatchedInInventory: false,
          ),
          const RecipeIngredient(
            name: 'C', requiredAmount: 1, unit: 'ml',
            isMatchedInInventory: true,
          ),
        ],
      );

      expect(recipe.matchedIngredientCount, 2);
      expect(recipe.isFullyMatched, false);
      expect(recipe.availabilityLabel, '2 z 3 w magazynie');
    });

    test('isFullyMatched is true when all ingredients available', () {
      final recipe = Recipe(
        id: 'r2',
        title: 'Test',
        preparationTime: 5,
        ingredients: [
          const RecipeIngredient(
            name: 'A', requiredAmount: 1, unit: 'szt',
            isMatchedInInventory: true,
          ),
        ],
      );

      expect(recipe.isFullyMatched, true);
    });

    test('availabilityLabel with empty ingredients', () {
      const recipe = Recipe(id: 'r3', title: 'Empty', preparationTime: 0);
      expect(recipe.availabilityLabel, '0 z 0 w magazynie');
    });
  });
}

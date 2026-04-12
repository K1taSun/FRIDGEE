// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — usda_fooddata_client.dart
// Fallback barcode lookup — USDA FoodData Central API.
// Used ONLY when Open Food Facts returns no results.
// API key loaded from USDA_API_KEY (--dart-define or .env).
// Full implementation in Module 4.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/network/dio_client.dart';
import 'openfoodfacts_client.dart';

class UsdaFoodDataClient {
  /// API key from environment — never hardcoded.
  String get _apiKey =>
      dotenv.env['USDA_API_KEY'] ??
      const String.fromEnvironment('USDA_API_KEY', defaultValue: 'DEMO_KEY');

  /// Searches USDA FoodData Central for a product by [query] (product name).
  /// Used as fallback when OFF returns [OffProductResult(found: false)].
  ///
  /// TODO (Module 4): Map USDA response to [OffProductResult].
  Future<OffProductResult> search(String query) async {
    try {
      final response = await DioClient.usda.get(
        '/foods/search',
        queryParameters: {
          'query': query,
          'api_key': _apiKey,
          'pageSize': 5,
          'dataType': 'Branded,Foundation',
        },
      );

      final foods =
          (response.data['foods'] as List<dynamic>?)?.firstOrNull;
      if (foods == null) return const OffProductResult(found: false);

      return OffProductResult(
        found: true,
        name: foods['description'] as String?,
        caloriesPer100g: (foods['foodNutrients'] as List<dynamic>?)
            ?.where((n) => n['nutrientName'] == 'Energy')
            .map((n) => (n['value'] as num).toDouble())
            .firstOrNull,
      );
    } catch (e) {
      debugPrint('USDA fallback error: $e');
      return const OffProductResult(found: false);
    }
  }
}

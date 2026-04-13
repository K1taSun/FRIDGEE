// Klient API USDA FoodData Central (zapasowe źródło danych).

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/network/dio_client.dart';
import 'openfoodfacts_client.dart';

class UsdaFoodDataClient {
  // Klucz API pobierany ze środowiska (.env lub --dart-define).
  String get _apiKey =>
      dotenv.env['USDA_API_KEY'] ??
      const String.fromEnvironment('USDA_API_KEY', defaultValue: 'DEMO_KEY');

  // Wyszukuje produkt w bazie USDA (fallback dla OFF).
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

// Klient API Open Food Facts (wyszukiwanie po kodzie kreskowym).

import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

// Wynik wyszukiwania produktu w bazie OFF.
class OffProductResult {
  const OffProductResult({
    required this.found,
    this.name,
    this.imageUrl,
    this.caloriesPer100g,
    this.brand,
  });

  final bool found;
  final String? name;
  final String? imageUrl;
  final double? caloriesPer100g;
  final String? brand;
}

class OpenFoodFactsClient {
  final Dio _dio = DioClient.openFoodFacts;

  // Pobiera dane produktu na podstawie kodu kreskowego.
  Future<OffProductResult> lookupBarcode(String barcode) async {
    try {
      final response = await _dio.get(
        '/api/v2/product/${Uri.encodeComponent(barcode)}',
        queryParameters: {
          'fields': 'product_name,image_front_url,nutriments,brands',
        },
      );

      if (response.data['status'] != 1) {
        return const OffProductResult(found: false);
      }

      final product = response.data['product'] as Map<String, dynamic>?;
      if (product == null) return const OffProductResult(found: false);

      final nutriments =
          product['nutriments'] as Map<String, dynamic>? ?? {};

      return OffProductResult(
        found: true,
        name: product['product_name'] as String?,
        imageUrl: product['image_front_url'] as String?,
        caloriesPer100g:
            (nutriments['energy-kcal_100g'] as num?)?.toDouble(),
        brand: product['brands'] as String?,
      );
    } on DioException {
      return const OffProductResult(found: false);
    }
  }
}

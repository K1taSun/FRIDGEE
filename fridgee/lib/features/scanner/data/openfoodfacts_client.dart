import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/dio_client.dart';

class OpenFoodFactsResult {
  const OpenFoodFactsResult({
    required this.found,
    this.name,
    this.brand,
    this.caloriesPer100g,
    this.errorMessage,
  });

  final bool found;
  final String? name;
  final String? brand;
  final double? caloriesPer100g;
  final String? errorMessage;

  bool get hasData => name != null || brand != null || caloriesPer100g != null;
}

class OpenFoodFactsClient {
  OpenFoodFactsClient({Dio? dio}) : _dio = dio ?? DioClient.openFoodFacts;

  final Dio _dio;

  Future<OpenFoodFactsResult> lookupBarcode(String barcode) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) {
      return const OpenFoodFactsResult(found: false, errorMessage: 'Pusty kod kreskowy.');
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v0/product/$trimmed.json',
      );

      final json = response.data;
      if (json == null) {
        return const OpenFoodFactsResult(found: false, errorMessage: 'Pusta odpowiedź serwera.');
      }

      if (json['status'] == 0 || json['product'] == null) {
        return const OpenFoodFactsResult(found: false);
      }

      final product = json['product'] as Map<String, dynamic>;
      final name = _extractName(product);
      final brand = _extractBrand(product);
      final kcal = _extractKcal(product);

      if (name == null && brand == null && kcal == null) {
        return const OpenFoodFactsResult(found: false);
      }

      return OpenFoodFactsResult(
        found: true,
        name: name,
        brand: brand,
        caloriesPer100g: kcal,
      );
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is FridgeeApiException) {
        debugPrint('[OFF] ${apiError.message}');
        return OpenFoodFactsResult(found: false, errorMessage: apiError.message);
      }
      debugPrint('[OFF] Błąd sieci: $e');
      return const OpenFoodFactsResult(
        found: false,
        errorMessage: 'Nie udało się połączyć z Open Food Facts.',
      );
    } catch (e) {
      debugPrint('[OFF] Błąd parsowania: $e');
      return const OpenFoodFactsResult(
        found: false,
        errorMessage: 'Błąd odczytu danych produktu.',
      );
    }
  }

  String? _extractName(Map<String, dynamic> product) {
    const preferredKeys = [
      'product_name_pl',
      'product_name',
      'generic_name_pl',
      'generic_name',
      'product_name_en',
      'abbreviated_product_name_pl',
      'abbreviated_product_name',
    ];

    for (final key in preferredKeys) {
      final value = product[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }

    for (final entry in product.entries) {
      if (entry.key.startsWith('product_name_') && entry.value is String) {
        final value = (entry.value as String).trim();
        if (value.isNotEmpty) return value;
      }
    }

    return null;
  }

  String? _extractBrand(Map<String, dynamic> product) {
    final brands = product['brands'];
    if (brands is String && brands.trim().isNotEmpty) return brands.trim();

    final tags = product['brands_tags'];
    if (tags is List && tags.isNotEmpty) {
      return tags.map((e) => e.toString().replaceAll('en:', '').replaceAll('-', ' ')).join(', ');
    }

    return null;
  }

  double? _extractKcal(Map<String, dynamic> product) {
    final nutriments = product['nutriments'];
    if (nutriments is! Map) return null;

    final keys = [
      'energy-kcal_100g',
      'energy-kcal',
      'energy_100g',
    ];

    for (final key in keys) {
      final parsed = _toDouble(nutriments[key]);
      if (parsed != null) {
        if (key == 'energy_100g' && parsed > 5000) {
          return parsed / 4.184;
        }
        return parsed;
      }
    }

    return null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '.'));
    return null;
  }
}

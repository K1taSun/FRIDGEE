/* 
Fridgge — dio_client.dart
Skonfigurow   any klient HTTP Dio z logowaniem, limitami czasowymi i interceptorem błędów.
*/

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract final class DioClient {
  // ── Open Food Facts ──────────────────────────────────────────────────────────
  /// Podstawowe API do wyszukiwania kodów kreskowych — nie wymaga klucza API.
  /// Limit: ~100 zapytań/min na adres IP (wystarczająco dla jednego użytkownika).
  /// Atrybucja: "Powered by Open Food Facts" (licencja ODbL).
  static Dio get openFoodFacts => _build(
        baseUrl: 'https://world.openfoodfacts.org',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 15),
      );

  // ── USDA FoodData Central ────────────────────────────────────────────────────
  /// API wyszukiwania kodów kreskowych — używane tylko wtedy, gdy OFF nie zwraca wyników.
  /// Wymaga USDA_API_KEY (z --dart-define lub .env).
  static Dio get usda => _build(
        baseUrl: 'https://api.nal.usda.gov/fdc/v1',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 15),
      );

  // ── Gemini / LLM (recipe generation) ────────────────────────────────────────
  static Dio get gemini => _build(
        baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(
            seconds: 60), // Rozbudowane zapytania mogą trwać dłużej
      );

  // ── Factory ───────────────────────────────────────────────────────────────────
  static Dio _build({
    required String baseUrl,
    required Duration connectTimeout,
    required Duration receiveTimeout,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Identify the app to Open Food Facts (good practice)
          'User-Agent': 'Fridgge/1.0 (Flutter; contact@fridgge.app)',
        },
      ),
    );

    // ── Interceptors ────────────────────────────────────────────────────────────
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          requestBody: false,
          responseBody: kDebugMode,
          error: true,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
      );
    }

    dio.interceptors.add(_ErrorInterceptor());

    return dio;
  }
}

/// Converts Dio exceptions into readable [FridggeApiException]s.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        FridggeApiException(
          message: 'Przekroczono limit czasu połączenia. Sprawdź internet.',
          statusCode: null,
          original: err,
        ),
      DioExceptionType.connectionError => FridggeApiException(
          message: 'Brak połączenia z internetem.',
          statusCode: null,
          original: err,
        ),
      DioExceptionType.badResponse => FridggeApiException(
          message: 'Błąd serwera (${err.response?.statusCode}).',
          statusCode: err.response?.statusCode,
          original: err,
        ),
      _ => FridggeApiException(
          message: 'Nieznany błąd sieci.',
          statusCode: null,
          original: err,
        ),
    };
    handler.reject(
      DioException(requestOptions: err.requestOptions, error: exception),
    );
  }
}

/// Typed API exception for graceful error handling in the UI layer.
class FridggeApiException implements Exception {
  const FridggeApiException({
    required this.message,
    required this.statusCode,
    required this.original,
  });

  final String message;
  final int? statusCode;
  final DioException original;

  bool get isNotFound => statusCode == 404;
  bool get isTimeout =>
      original.type == DioExceptionType.connectionTimeout ||
      original.type == DioExceptionType.receiveTimeout;

  @override
  String toString() => 'FridggeApiException($statusCode): $message';
}

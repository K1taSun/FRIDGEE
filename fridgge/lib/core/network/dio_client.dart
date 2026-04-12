// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — dio_client.dart
// Configured Dio HTTP client with logging, timeouts, and error interceptor.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract final class DioClient {
  // ── Open Food Facts ──────────────────────────────────────────────────────────
  /// Primary barcode lookup API — no API key required.
  /// Limit: ~100 req/min per IP (plenty for a single user).
  /// Attribution: "Powered by Open Food Facts" (ODbL licence).
  static Dio get openFoodFacts => _build(
        baseUrl: 'https://world.openfoodfacts.org',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 15),
      );

  // ── USDA FoodData Central ────────────────────────────────────────────────────
  /// Fallback barcode lookup API — used only when OFF returns no results.
  /// Requires USDA_API_KEY (from --dart-define or .env).
  static Dio get usda => _build(
        baseUrl: 'https://api.nal.usda.gov/fdc/v1',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 15),
      );

  // ── Gemini / LLM (recipe generation) ────────────────────────────────────────
  static Dio get gemini => _build(
        baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60), // AI can be slow
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
  bool get isTimeout => original.type == DioExceptionType.connectionTimeout ||
      original.type == DioExceptionType.receiveTimeout;

  @override
  String toString() => 'FridggeApiException($statusCode): $message';
}

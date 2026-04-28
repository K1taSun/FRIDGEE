// Fridgee — Punkt wejścia aplikacji.
// Odpowiada za konfigurację środowiska, inicjalizację bazy danych i start UI.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/database/isar_service.dart';
import 'app.dart';

Future<void> main() async {
  // Wymagane, jeśli używamy pluginów przed runApp()
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicjalizacja formatowania dat dla polskiej lokalizacji
  await initializeDateFormatting('pl_PL', null);

  // Konfiguracja wyglądu paska stanu i nawigacji systemowej (Android/iOS)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Blokada orientacji pionowej — ważne dla stabilności layoutu skanera
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Załadowanie zmiennych środowiskowych (np. klucze API do USDA)
  await dotenv.load(fileName: '.env').catchError((_) {
    debugPrint('⚠️ Brak pliku .env — system przejdzie na wartości domyślne.');
  });

  // Start lokalnej bazy danych SQLite (używamy sqflite)
  // Robimy to przed startem UI, aby dane były natychmiast dostępne.
  await IsarService.initialize();

  // Inicjalizacja Firebase (zaplanowana na Moduł 2)
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // ProviderScope jest wymagany przez Riverpod do zarządzania stanem
    const ProviderScope(
      child: FridgeeApp(),
    ),
  );
}

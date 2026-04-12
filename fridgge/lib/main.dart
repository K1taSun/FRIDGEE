// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — main.dart
// Entry point: initializes services and launches the ProviderScope.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/database/isar_service.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── System UI overlay style ─────────────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ── Preferred orientations ───────────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Load environment variables (.env) ────────────────────────────────────────
  // .env file contains USDA_API_KEY and GEMINI_API_KEY.
  // Never commit .env — use .env.example as a template.
  await dotenv.load(fileName: '.env').catchError((_) {
    // .env file may not exist in CI or when --dart-define is used instead.
    debugPrint('⚠️  .env file not found — falling back to --dart-define values.');
  });

  // ── Initialize Isar (local database) ────────────────────────────────────────
  // Isar is initialized before Firebase so the app works fully offline.
  await IsarService.initialize();

  // ── Firebase (requires google-services.json / GoogleService-Info.plist) ──────
  // TODO (Module 2): Uncomment after adding Firebase config files.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ── Launch app ───────────────────────────────────────────────────────────────
  runApp(
    const ProviderScope(
      child: FridggeApp(),
    ),
  );
}

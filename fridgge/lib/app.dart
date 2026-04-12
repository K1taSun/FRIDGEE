// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — app.dart
// Root widget: wires up MaterialApp.router with the GoRouter and dark theme.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class FridggeApp extends ConsumerWidget {
  const FridggeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Fridgge',
      debugShowCheckedModeBanner: false,

      // ── Theme ──────────────────────────────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // Always dark in Module 1; user toggle in Module 7

      // ── Routing ────────────────────────────────────────────────────────────
      routerConfig: router,
    );
  }
}

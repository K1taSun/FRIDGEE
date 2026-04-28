// Root aplikacji: MaterialApp z routerem i motywem.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class FridgeeApp extends ConsumerWidget {
  const FridgeeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Fridgee',
      debugShowCheckedModeBanner: false,

      // Motyw (zawsze dark w Module 1)
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      // Routing
      routerConfig: router,
    );
  }
}

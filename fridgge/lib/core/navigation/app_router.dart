// Konfiguracja nawigacji opartej na GoRouter.
// Wykorzystujemy StatefulShellRoute do obsługi dolnego paska nawigacji (BottomNavBar),
// co pozwala na zachowanie stanu każdej zakładki (np. przeskoczenie do innej i powrót).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/recipes/presentation/recipes_screen.dart';
import '../../features/recipes/presentation/recipe_detail_screen.dart';
import '../../features/shopping/presentation/shopping_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/about_screen.dart';
import 'main_scaffold.dart';

part 'app_router.g.dart';

// Stałe tras aplikacji — zapobiegają błędom literowym w kodzie.
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String inventory = '/inventory';
  static const String scanner = '/scanner';
  static const String recipes = '/recipes';
  static const String recipeDetail = '/recipes/:id';
  static const String shopping = '/shopping';
  static const String profile = '/profile';
  static const String about = '/profile/about';
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Obserwujemy stan autoryzacji. GoRouter odświeży nawigację automatycznie,
  // gdy zmieni się stan authStateProvider.
  final authState = ref.watch(authStateProvider);
  final isGuest = ref.watch(isGuestProvider);

  return GoRouter(
    initialLocation: AppRoutes.inventory,
    debugLogDiagnostics: true,

    // Logika przekierowań (Guard).
    // Jeśli użytkownik nie jest zalogowany i nie jest na stronie auth -> wyrzuć go do logowania.
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null || isGuest;
      final isOnAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;
      if (isAuthenticated && isOnAuthRoute) return AppRoutes.inventory;
      return null;
    },

    routes: [
      // Trasy Autoryzacji (poza głównym rusztowaniem z menu)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // StatefulShellRoute tworzy "kontener" dla zakładek.
      // Każdy branch reprezentuje oddzielny stos nawigacji.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          // Branch 0: Magazyn
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.inventory,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: InventoryScreen(),
                ),
              ),
            ],
          ),

          // Branch 1: Skaner
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scanner,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ScannerScreen(),
                ),
              ),
            ],
          ),

          // Branch 2: Przepisy (z trasą podrzędną dla szczegółów)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recipes,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RecipesScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => RecipeDetailScreen(
                      recipeId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Branch 3: Lista Zakupów
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shopping,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ShoppingScreen(),
                ),
              ),
            ],
          ),

          // Branch 4: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],

    // Obsługa stron, które nie istnieją (404)
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.broken_image_outlined,
                color: Color(0xFF26C6DA), size: 64),
            const SizedBox(height: 16),
            Text(
              'Strona nie znaleziona',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.inventory),
              child: const Text('Wróć do Magazynu'),
            ),
          ],
        ),
      ),
    ),
  );
}

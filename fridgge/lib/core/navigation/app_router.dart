// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — app_router.dart
// Declarative navigation using go_router with StatefulShellRoute for
// tab-based navigation that preserves scroll and state per branch.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../features/auth/domain/auth_provider.dart';
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

// ── Route path constants ──────────────────────────────────────────────────────

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

// ── Router provider ───────────────────────────────────────────────────────────

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Watch auth state for redirect logic (Module 2 will wire real Firebase auth)
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.inventory,
    debugLogDiagnostics: true,

    // ── Auth redirect ────────────────────────────────────────────────────────
    redirect: (context, state) {
      // final isAuthenticated = authState.valueOrNull ?? false;
      // final isOnAuthRoute =
      //     state.matchedLocation == AppRoutes.login ||
      //     state.matchedLocation == AppRoutes.register;

      // TODO (Module 2): Uncomment to enable auth gate
      // if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;
      // if (isAuthenticated && isOnAuthRoute) return AppRoutes.inventory;
      return null;
    },

    routes: [
      // ── Auth routes ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Shell (tab navigation) routes ──────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          // Tab 0 — Magazyn (Inventory)
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

          // Tab 1 — Skaner (Scanner)
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

          // Tab 2 — Przepisy (Recipes)
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

          // Tab 3 — Lista Zakupów (Shopping)
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

          // Tab 4 — Profil (Profile)
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

    // ── Error page ────────────────────────────────────────────────────────────
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

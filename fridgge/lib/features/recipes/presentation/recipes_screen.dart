// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — recipes_screen.dart
// Placeholder — full AI recipe implementation in Module 5.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Przepisy AI',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Zero Waste — zamień resztki w posiłek',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 16),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Przepisy'),
                        Tab(text: 'Ulubione'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _RecipesTabPlaceholder(),
                    _FavoritesTabPlaceholder(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.auto_awesome_outlined),
          label: const Text('Generuj przepisy'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
        ),
      ),
    );
  }
}

class _RecipesTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_menu,
                  color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 20),
            Text('Brak przepisów',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Naciśnij „Generuj przepisy", aby Fridgge AI\nzaproponowało potrawę z Twoich składników.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border,
              color: AppColors.textTertiary, size: 48),
          const SizedBox(height: 16),
          Text('Brak ulubionych',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

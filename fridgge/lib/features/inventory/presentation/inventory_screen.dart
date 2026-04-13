// Ekran magazynu: lista produktów + onboard Quick Start.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_router.dart';
import '../domain/product_item.dart';
import '../domain/product_provider.dart';
import 'product_card.dart';
import 'quick_start_grid.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(sortedProductsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.background,
                expandedHeight: 0,
                toolbarHeight: 64,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fridgge',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                    ),
                    Text(
                      'Twój magazyn żywności',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search_outlined),
                    color: AppColors.textSecondary,
                    onPressed: () {}, // Module 3
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_outlined),
                    color: AppColors.textSecondary,
                    onPressed: () {}, // Module 3
                    padding: const EdgeInsets.only(right: 16),
                  ),
                ],
              ),

              products.when(
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (err, _) => SliverFillRemaining(
                  child: _ErrorView(message: err.toString()),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _EmptyInventoryView(),
                    );
                  }
                  return _ProductList(products: items);
                },
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 104),
          child: FloatingActionButton.extended(
            onPressed: () => context.go(AppRoutes.scanner),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Dodaj'),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
          ),
        ),
      );
    }
  }

// Lista produktów
class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<ProductItem> products;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

// Empty state + Szybki start
class _EmptyInventoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ilustracja hero
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: AppTheme.radiusLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🥗', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 8),
                Text(
                  'Twój magazyn jest pusty',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Dodaj produkty przez skaner lub szybki start',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '⚡ Szybki start',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Kliknij, aby dodać produkt z domyślną datą ważności',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          const QuickStartGrid(),
        ],
      ),
    );
  }
}

// Obsługa błędów
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Wystąpił błąd',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
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

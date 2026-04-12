// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — shopping_screen.dart
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/shopping_item.dart';
import '../domain/shopping_provider.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shoppingItemsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              toolbarHeight: 64,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lista zakupów',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('Wszystko, czego Ci brakuje',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            items.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary)),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text(e.toString())),
              ),
              data: (list) {
                if (list.isEmpty) return const SliverFillRemaining(child: _EmptyShoppingView());
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        _ShoppingItemTile(item: list[index]),
                  ),
                );
              },
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemSheet(context, ref),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Wpisz'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
      ),
    );
  }

  void _showAddItemSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SizedBox(
                  width: 36,
                  height: 4,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius:
                              BorderRadius.all(Radius.circular(2))))),
            ),
            const SizedBox(height: 16),
            Text('Dodaj produkt',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Nazwa produktu...',
                prefixIcon: Icon(Icons.shopping_basket_outlined),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    ref.read(shoppingNotifierProvider.notifier).addItem(
                          name: nameCtrl.text,
                          quantity: 1,
                          unit: 'szt',
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Dodaj do listy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingItemTile extends ConsumerWidget {
  const _ShoppingItemTile({required this.item});

  final ShoppingItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.radiusMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            if (item.dbId != null) {
              ref.read(shoppingNotifierProvider.notifier).checkItem(item.dbId!);
            }
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2),
            ),
          ),
        ),
        title: Text(item.name,
            style: Theme.of(context).textTheme.bodyMedium),
        subtitle: item.source == ShoppingItemSource.recipeMatch
            ? const Text(
                'Z przepisu',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              )
            : null,
        trailing: Text(
          '${item.quantity.toStringAsFixed(0)} ${item.unit}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textTertiary),
        ),
      ),
    );
  }
}

class _EmptyShoppingView extends StatelessWidget {
  const _EmptyShoppingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              color: AppColors.textTertiary, size: 64),
          const SizedBox(height: 16),
          Text('Lista zakupów jest pusta',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Dodaj produkty ręcznie lub\nz brakujących składników przepisów',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

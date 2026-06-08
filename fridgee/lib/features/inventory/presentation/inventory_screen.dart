// Ekran magazynu: kafelki niestandardowych stref zarządzanych przez użytkownika lub lista produktów.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/main_nav_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/sort_utils.dart';
import '../../scanner/presentation/add_product_sheet.dart';
import '../domain/inventory_view_state.dart';
import '../domain/product_category_codec.dart';
import '../domain/product_provider.dart';
import '../domain/storage_provider.dart';
import 'product_card.dart';
import 'widgets/add_storage_zone_dialog.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(sortedProductsProvider);
    final viewMode = ref.watch(inventoryViewModeProvider);
    final storageObjects = ref.watch(customStorageObjectsProvider);
    final selectedFilterId = ref.watch(selectedFilterStorageIdProvider);
    final searchQuery = ref.watch(inventorySearchQueryProvider);
    final sortMode = ref.watch(inventorySortModeProvider);

    final isFilteredView = viewMode == InventoryViewMode.allProducts && selectedFilterId != 'all';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MainNavBody(
        content: SafeArea(
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
              leading: isFilteredView
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                      onPressed: () {
                        ref.read(selectedFilterStorageIdProvider.notifier).state = 'all';
                        ref.read(inventorySearchQueryProvider.notifier).state = '';
                        ref.read(inventoryViewModeProvider.notifier).state = InventoryViewMode.storageObjects;
                      },
                    )
                  : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fridgee',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                  ),
                  Text(
                    viewMode == InventoryViewMode.allProducts
                        ? (selectedFilterId == 'all'
                            ? 'Wszystkie produkty'
                            : storageObjects
                                    .where((o) => o['id'] == selectedFilterId)
                                    .map((o) => o['name'] as String)
                                    .firstOrNull ??
                                'Zawartość strefy')
                        : 'Twoje strefy przechowywania',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined, color: AppColors.primary, size: 26),
                  onPressed: () => AddStorageZoneDialog.show(context, ref),
                ),
                const SizedBox(width: 8),
              ],
            ),

            productsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              ),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('Błąd: $err', style: const TextStyle(color: AppColors.error))),
              ),
              data: (items) {
                if (viewMode == InventoryViewMode.allProducts) {
                  final displayedItems = filterAndSortProducts(
                    products: items,
                    searchQuery: searchQuery,
                    sortMode: sortMode,
                    storageZoneId: selectedFilterId,
                  );

                  return SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (v) =>
                                    ref.read(inventorySearchQueryProvider.notifier).state = v,
                                decoration: InputDecoration(
                                  hintText: 'Szukaj produktu…',
                                  prefixIcon: const Icon(Icons.search, size: 20),
                                  suffixIcon: searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, size: 18),
                                          onPressed: () => ref
                                              .read(inventorySearchQueryProvider.notifier)
                                              .state = '',
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.sort, size: 18, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<InventorySortMode>(
                                        value: sortMode,
                                        isExpanded: true,
                                        dropdownColor: AppColors.surfaceElevated,
                                        items: const [
                                          DropdownMenuItem(
                                            value: InventorySortMode.expiryAsc,
                                            child: Text('Data ważności ↑'),
                                          ),
                                          DropdownMenuItem(
                                            value: InventorySortMode.expiryDesc,
                                            child: Text('Data ważności ↓'),
                                          ),
                                          DropdownMenuItem(
                                            value: InventorySortMode.nameAsc,
                                            child: Text('Nazwa A–Z'),
                                          ),
                                          DropdownMenuItem(
                                            value: InventorySortMode.nameDesc,
                                            child: Text('Nazwa Z–A'),
                                          ),
                                        ],
                                        onChanged: (v) {
                                          if (v != null) {
                                            ref.read(inventorySortModeProvider.notifier).state = v;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (displayedItems.isEmpty)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Text(
                                'Brak produktów spełniających kryteria.',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList.separated(
                            itemCount: displayedItems.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) =>
                                ProductCard(product: displayedItems[index]),
                          ),
                        ),
                    ],
                  );
                } else {
                  if (storageObjects.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Brak zdefiniowanych stref.\nKliknij przycisk "+" u góry, aby dodać np. własną Lodówkę.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: storageObjects.map((obj) {
                        final zoneId = obj['id'] as String;
                        final locProducts = items
                            .where((p) => ProductCategoryCodec.belongsToStorage(p.category, zoneId))
                            .toList();
                        
                        final total = locProducts.length;
                        final expired = locProducts.where((p) => SortUtils.getStatus(p) == ExpiryStatus.expired).length;
                        final warning = locProducts.where((p) => 
                            SortUtils.getStatus(p) == ExpiryStatus.expiresSoon || 
                            SortUtils.getStatus(p) == ExpiryStatus.expirestoday).length;

                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedFilterStorageIdProvider.notifier).state = obj['id'] as String;
                            ref.read(inventoryViewModeProvider.notifier).state = InventoryViewMode.allProducts;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: AppColors.cardGradient,
                              borderRadius: AppTheme.radiusMedium,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(obj['emoji'] as String, style: const TextStyle(fontSize: 28)),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                                      onPressed: () => ref
                                          .read(customStorageObjectsProvider.notifier)
                                          .removeZone(obj['id'] as String),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(obj['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                                  child: Text('$total szt.', style: TextStyle(fontSize: 10, color: AppColors.textPrimary)),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(Icons.circle, color: AppColors.error, size: 8),
                                    const SizedBox(width: 6),
                                    Text('Po terminie: $expired', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.circle, color: AppColors.warning, size: 8),
                                    const SizedBox(width: 6),
                                    Text('Wkrótce: $warning', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: MainNavBody.scrollBottomPadding(context)),
              ),
            ],
          ),
        ),
        actionBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                FloatingActionButton(
                  heroTag: 'view_mode_toggle_fab',
                  onPressed: () {
                    if (selectedFilterId != 'all') {
                      ref.read(selectedFilterStorageIdProvider.notifier).state = 'all';
                    }
                    ref.read(inventorySearchQueryProvider.notifier).state = '';
                    ref.read(inventoryViewModeProvider.notifier).update((state) =>
                        state == InventoryViewMode.allProducts
                            ? InventoryViewMode.storageObjects
                            : InventoryViewMode.allProducts);
                  },
                  backgroundColor: AppColors.surfaceElevated,
                  foregroundColor: AppColors.primary,
                  child: Icon(viewMode == InventoryViewMode.allProducts
                      ? Icons.grid_view_outlined
                      : Icons.format_list_bulleted_outlined),
                ),
                FloatingActionButton.extended(
                  heroTag: 'add_new_product_fab',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => const AddProductPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Dodaj produkt'),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
          ],
        ),
      ),
    );
  }
}
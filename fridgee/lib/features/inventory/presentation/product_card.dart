// Karta produktu: status ważności (kolory) + swipe do zużycia.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/sort_utils.dart';
import '../domain/product_category_codec.dart';
import '../domain/product_item.dart';
import '../domain/product_provider.dart';
import '../domain/product_type_icons.dart';
import '../../scanner/presentation/add_product_sheet.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final ProductItem product;

  Future<bool?> _showConsumeDialog(BuildContext context, WidgetRef ref) async {
    double currentQuantity = product.quantity;
    double consumedQuantity = currentQuantity; 
    final TextEditingController textController = TextEditingController(text: consumedQuantity.toStringAsFixed(1));

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateConsumed(double val) {
              setState(() {
                consumedQuantity = val.clamp(0.1, currentQuantity);
                textController.text = consumedQuantity.toStringAsFixed(1);
              });
            }

            return AlertDialog(
              backgroundColor: AppColors.surfaceElevated,
              shape: const RoundedRectangleBorder(borderRadius: AppTheme.radiusLarge),
              title: const Row(
                children: [
                  Icon(Icons.restaurant, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Zużycie produktu', style: TextStyle(fontSize: 18)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ile ${product.name} wykorzystano?', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      suffixText: '/ ${currentQuantity.toStringAsFixed(1)} ${product.unit.name}',
                      suffixStyle: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val.replaceAll(',', '.'));
                      if (parsed != null) consumedQuantity = parsed.clamp(0.1, currentQuantity);
                    },
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
                    children: [
                      ActionChip(label: const Text('1/4'), backgroundColor: AppColors.surface, side: const BorderSide(color: AppColors.primary), onPressed: () => updateConsumed(currentQuantity * 0.25)),
                      ActionChip(label: const Text('1/3'), backgroundColor: AppColors.surface, side: const BorderSide(color: AppColors.primary), onPressed: () => updateConsumed(currentQuantity * 0.333)),
                      ActionChip(label: const Text('1/2'), backgroundColor: AppColors.surface, side: const BorderSide(color: AppColors.primary), onPressed: () => updateConsumed(currentQuantity * 0.5)),
                      ActionChip(label: const Text('Całość'), backgroundColor: AppColors.surface, side: const BorderSide(color: AppColors.primary), onPressed: () => updateConsumed(currentQuantity)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), 
                  child: Text('Anuluj', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (consumedQuantity >= currentQuantity) {
                      await ref.read(inventoryNotifierProvider.notifier).markConsumed(product.dbId!);
                      if (context.mounted) Navigator.pop(context, true); 
                    } else {
                      final updatedProduct = product.copyWith(
                        quantity: currentQuantity - consumedQuantity,
                        isOpened: true, // Automatycznie oznacza produkt jako otwarty po ujedzeniu fragmentu
                        openedAt: product.openedAt ?? DateTime.now(),
                      );
                      await ref.read(inventoryNotifierProvider.notifier).addProduct(updatedProduct);
                      if (context.mounted) Navigator.pop(context, false); 
                    }
                  },
                  child: const Text('Zatwierdź'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = SortUtils.getStatus(product);
    final accentColor = _colorForStatus(status);
    final isOpened = product.isOpened;

    return Dismissible(
      key: Key('product_${product.dbId}'),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      confirmDismiss: (direction) => _showConsumeDialog(context, ref),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProductPage(productToEdit: product)));
        },
        onLongPress: () {
          // Natychmiastowy update w bazie danych, zamiast błędu "Toggle"!
          final now = DateTime.now();
          final updatedProduct = product.copyWith(
            isOpened: !isOpened,
            openedAt: !isOpened ? now : null, 
          );
          ref.read(inventoryNotifierProvider.notifier).addProduct(updatedProduct);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppTheme.radiusMedium,
            border: Border.all(
              color: isOpened ? AppColors.primary : accentColor.withValues(alpha: 0.3),
              width: isOpened ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _ProductIcon(product: product, accentColor: accentColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _TypeChip(category: product.category),
                          const SizedBox(width: 6),
                          Text('${product.quantity.toStringAsFixed(product.quantity == product.quantity.roundToDouble() ? 0 : 1)} ${product.unit.name}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _ExpiryBadge(status: status, color: accentColor),
                    const SizedBox(height: 4),
                    if (isOpened) ...[
                      const Text('OTWARTY', style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                    ],
                    // UWAGA: Wyświetlamy efektywną datę ważności (np. skróconą na 48h)
                    Text(FridgeeDateUtils.formatShort(product.effectiveExpiryDate), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _colorForStatus(ExpiryStatus status) => switch (status) {
        ExpiryStatus.expired => AppColors.error,
        ExpiryStatus.expirestoday => AppColors.error,
        ExpiryStatus.expiresSoon => AppColors.warning,
        ExpiryStatus.fresh => AppColors.success,
      };
}

class _ProductIcon extends StatelessWidget {
  const _ProductIcon({required this.product, required this.accentColor});
  final ProductItem product;
  final Color accentColor;
  @override
  Widget build(BuildContext context) {
    final type = ProductCategoryCodec.type(product.category);
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), borderRadius: AppTheme.radiusSmall),
      child: Center(
        child: Text(
          ProductTypeIcons.emojiForType(type),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.category});
  final String? category;

  @override
  Widget build(BuildContext context) {
    final type = ProductCategoryCodec.type(category);
    final label = ProductTypeIcons.labelForType(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppColors.primarySubtle, borderRadius: AppTheme.radiusSmall),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  const _ExpiryBadge({required this.status, required this.color});
  final ExpiryStatus status;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      ExpiryStatus.expired => 'Przeterminowany', ExpiryStatus.expirestoday => 'Dziś!', ExpiryStatus.expiresSoon => 'Wkrótce', ExpiryStatus.fresh => 'Świeży',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: AppTheme.radiusSmall),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: AppTheme.radiusMedium),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 28),
          SizedBox(height: 4),
          Text('Zużyj fragment', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
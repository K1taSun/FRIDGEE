// Karta produktu: status ważności (kolory) + swipe do zużycia.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/sort_utils.dart';
import '../domain/product_item.dart';
import '../domain/product_provider.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = SortUtils.getStatus(product);
    final accentColor = _colorForStatus(status);

    return Dismissible(
      key: Key('product_${product.dbId}'),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      onDismissed: (_) {
        if (product.dbId == null) return;
        ref
            .read(inventoryNotifierProvider.notifier)
            .markConsumed(product.dbId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} oznaczony jako zużyty'),
            action: SnackBarAction(label: 'Cofnij', onPressed: () {}),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppTheme.radiusMedium,
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Emoji / ikona
              _ProductIcon(product: product, accentColor: accentColor),
              const SizedBox(width: 12),

              // Nazwa i lokalizacja
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _LocationChip(location: product.storageLocation),
                        const SizedBox(width: 6),
                        Text(
                          '${product.quantity.toStringAsFixed(product.quantity == product.quantity.roundToDouble() ? 0 : 1)} ${product.unit.name}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status ważności
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ExpiryBadge(status: status, color: accentColor),
                  const SizedBox(height: 4),
                  Text(
                    FridggeDateUtils.formatShort(product.expiryDate),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
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

// Ikona produktu dopasowana do lokalizacji
class _ProductIcon extends StatelessWidget {
  const _ProductIcon({required this.product, required this.accentColor});

  final ProductItem product;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusSmall,
      ),
      child: Center(
        child: Text(
          _emojiForLocation(product.storageLocation),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  String _emojiForLocation(StorageLocation loc) => switch (loc) {
        StorageLocation.fridge => '🧊',
        StorageLocation.freezer => '❄️',
        StorageLocation.pantry => '🥫',
      };
}

// Chip miejsca przechowywania
class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.location});

  final StorageLocation location;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (location) {
      StorageLocation.fridge => ('Lodówka', AppColors.fridge),
      StorageLocation.freezer => ('Zamrażarka', AppColors.freezer),
      StorageLocation.pantry => ('Spiżarnia', AppColors.pantry),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppTheme.radiusSmall,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// Etykieta daty ważności
class _ExpiryBadge extends StatelessWidget {
  const _ExpiryBadge({required this.status, required this.color});

  final ExpiryStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      ExpiryStatus.expired => 'Przeterminowany',
      ExpiryStatus.expirestoday => 'Dziś!',
      ExpiryStatus.expiresSoon => 'Wkrótce',
      ExpiryStatus.fresh => 'Świeży',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppTheme.radiusSmall,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// Tło przy swipe (oznaczanie jako zużyte)
class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.2),
        borderRadius: AppTheme.radiusMedium,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 28),
          SizedBox(height: 4),
          Text(
            'Zużyty',
            style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

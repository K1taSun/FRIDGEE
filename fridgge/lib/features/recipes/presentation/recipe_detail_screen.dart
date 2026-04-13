// Ekran szczegółów przepisu (podgląd).

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szczegóły przepisu')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NoMatchIndicator(
                ingredientName: 'Przykładowy składnik',
                onAddToShoppingList: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Marker braku składnika w magazynie (z opcją dodania do listy zakupów).
class NoMatchIndicator extends StatelessWidget {
  const NoMatchIndicator({
    super.key,
    required this.ingredientName,
    required this.onAddToShoppingList,
  });

  final String ingredientName;
  final VoidCallback onAddToShoppingList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.errorSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.close, color: AppColors.error, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Brak dopasowań',
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Dodawanie do listy zakupów
          InkWell(
            key: const Key('add_to_shopping_btn'),
            onTap: onAddToShoppingList,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.add_shopping_cart,
                  color: AppColors.error, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

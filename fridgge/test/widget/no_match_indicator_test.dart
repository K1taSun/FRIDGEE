// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — no_match_indicator_test.dart
// Widget test for the NoMatchIndicator component.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fridgge/core/theme/app_theme.dart';
import 'package:fridgge/features/recipes/presentation/recipe_detail_screen.dart';

Widget _wrapWidget(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('NoMatchIndicator', () {
    testWidgets('displays "Brak dopasowań" label', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(
          NoMatchIndicator(
            ingredientName: 'Masło',
            onAddToShoppingList: () {},
          ),
        ),
      );

      expect(find.text('Brak dopasowań'), findsOneWidget);
    });

    testWidgets('shows add-to-shopping-list button', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(
          NoMatchIndicator(
            ingredientName: 'Jajko',
            onAddToShoppingList: () {},
          ),
        ),
      );

      expect(find.byKey(const Key('add_to_shopping_btn')), findsOneWidget);
    });

    testWidgets('calls onAddToShoppingList when button tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrapWidget(
          NoMatchIndicator(
            ingredientName: 'Ryż',
            onAddToShoppingList: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('add_to_shopping_btn')));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('has error-colored elements', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(
          NoMatchIndicator(
            ingredientName: 'Ser',
            onAddToShoppingList: () {},
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(icon.color, const Color(0xFFCF6679)); // AppColors.error
    });
  });
}

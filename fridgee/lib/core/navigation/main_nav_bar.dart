// Dolne menu (MainScaffold): wymiary, scope i pasek akcji nad nawigacją.

import 'package:flutter/material.dart';

abstract final class MainNavBar {
  static const double barHeight = 64;
  static const double navBottomPadding = 12;
  static const double navTopPadding = 8;

  static const double overlayHeight = barHeight + navTopPadding + navBottomPadding;

  static double scrollBottomInset(BuildContext context, {double extra = 0}) {
    return MainNavBarScope.contentBottomPaddingOf(context) + extra;
  }
}

/// Udostępnia dolny inset obliczony w [MainScaffold] (pewne MediaQuery).
class MainNavBarScope extends InheritedWidget {
  const MainNavBarScope({
    required this.contentBottomPadding,
    required super.child,
    super.key,
  });

  final double contentBottomPadding;

  static double contentBottomPaddingOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MainNavBarScope>();
    if (scope != null) return scope.contentBottomPadding;
    return MainNavBar.overlayHeight + MediaQuery.viewPaddingOf(context).bottom;
  }

  @override
  bool updateShouldNotify(MainNavBarScope oldWidget) =>
      contentBottomPadding != oldWidget.contentBottomPadding;
}

/// Treść + pływające przyciski (przezroczyste, ukrywane przy klawiaturze).
class MainNavBody extends StatelessWidget {
  const MainNavBody({
    required this.content,
    required this.actionBar,
    super.key,
  });

  final Widget content;
  final Widget actionBar;

  static bool isKeyboardVisible(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom > 0;

  static double scrollBottomPadding(BuildContext context, {double actionHeight = 56}) {
    if (isKeyboardVisible(context)) return 16;
    return MainNavBarScope.contentBottomPaddingOf(context) + actionHeight + 14;
  }

  @override
  Widget build(BuildContext context) {
    if (isKeyboardVisible(context)) return content;

    final navReserve = MainNavBarScope.contentBottomPaddingOf(context);
    return Stack(
      children: [
        content,
        Positioned(
          left: 0,
          right: 0,
          bottom: navReserve + 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: actionBar,
          ),
        ),
      ],
    );
  }
}

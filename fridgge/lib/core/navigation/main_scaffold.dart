// Główny szkielet aplikacji (Scaffold) widoczny po zalogowaniu.
// Zawiera system nawigacji (BottomNavBar) zintegrowany ze StatefulNavigationShell.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  // StatefulNavigationShell pozwala na przełączanie się między branchami (zakładkami)
  // przy jednoczesnym zachowaniu ich stanu wewnętrznego.
  final StatefulNavigationShell navigationShell;

  // Definicje zakładek – ikony i etykiety używane w menu.
  static const _tabs = [
    _NavTab(
        label: 'Magazyn',
        icon: Icons.kitchen_outlined,
        activeIcon: Icons.kitchen),
    _NavTab(
        label: 'Skaner',
        icon: Icons.qr_code_scanner_outlined,
        activeIcon: Icons.qr_code_scanner),
    _NavTab(
        label: 'Przepisy',
        icon: Icons.restaurant_menu_outlined,
        activeIcon: Icons.restaurant_menu),
    _NavTab(
        label: 'Zakupy',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart),
    _NavTab(
        label: 'Profil', icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* extendBody: true pozwala na renderowanie zawartości pod przezroczystym paskiem menu,
       co daje efekt "pływającego" interfejsu. */
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: _FloatingBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        tabs: _tabs,
      ),
    );
  }

  // Funkcja zmiany zakładki
  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Jeśli użytkownik kliknie w aktualnie otwartą zakładkę, wróć do jej strony głównej
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

// Widget tworzący autorski, "pływający" pasek nawigacji.
class _FloatingBottomNav extends StatelessWidget {
  const _FloatingBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavTab> tabs;

  @override
  Widget build(BuildContext context) {
    // SafeArea zapobiega ucinaniu paska na urządzeniach z "notchem" (np. iPhone).
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppTheme.radiusLarge,
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppTheme.radiusLarge,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isActive = currentIndex == index;

                return Expanded(
                  child: _NavItem(
                    tab: tab,
                    isActive: isActive,
                    onTap: () => onTap(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// Pojedyncza ikona w dole paska z animacją przejścia.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final _NavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Jeśli jest to Skaner (centralny przycisk), renderujemy specjalne tło.
            if (tab.label == 'Skaner')
              _ScannerIconBackground(isActive: isActive, icon: tab.activeIcon)
            else ...[
              // AnimatedSwitcher zapewnia płynną zmianę ikony z pustej na pełną.
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? tab.activeIcon : tab.icon,
                  key: ValueKey(isActive),
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              // AnimatedDefaultTextStyle animuje kolor i grubość opisu.
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
                ),
                child: Text(tab.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Wyróżnienie ikony skanera
class _ScannerIconBackground extends StatelessWidget {
  const _ScannerIconBackground({required this.isActive, required this.icon});

  final bool isActive;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.primaryGradient : null,
        color: isActive ? null : AppColors.surfaceElevated,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Icon(
        icon,
        color: isActive ? AppColors.background : AppColors.textTertiary,
        size: 22,
      ),
    );
  }
}

// Klasa pomocnicza do definicji zakładki.
class _NavTab {
  const _NavTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

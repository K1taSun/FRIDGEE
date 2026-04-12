// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — scanner_screen.dart
// Placeholder — full implementation in Module 4.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Skaner', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Skanuj kody kreskowe lub etykiety produktów',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Camera viewfinder placeholder
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppTheme.radiusLarge,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner,
                                color: AppColors.primary, size: 80),
                            SizedBox(height: 16),
                            Text(
                              'Moduł 4',
                              style: TextStyle(
                                  color: AppColors.textTertiary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Options row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ScanOption(
                            icon: Icons.qr_code,
                            label: 'Kod kreskowy',
                            color: AppColors.primary,
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _ScanOption(
                            icon: Icons.document_scanner_outlined,
                            label: 'Etykieta OCR',
                            color: AppColors.warning,
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _ScanOption(
                            icon: Icons.edit_outlined,
                            label: 'Ręcznie',
                            color: AppColors.textSecondary,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOption extends StatelessWidget {
  const _ScanOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppTheme.radiusMedium,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

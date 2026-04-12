// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — about_screen.dart
// Legal attributions required by Open Food Facts (ODbL) and USDA terms.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O aplikacji')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── App header ────────────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppTheme.radiusMedium,
                  ),
                  child: const Center(
                    child: Text('🥗', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Fridgge',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        )),
                Text('Wersja 1.0.0',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Data sources ──────────────────────────────────────────────────
          Text(
            'ŹRÓDŁA DANYCH',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 12),

          _AttributionCard(
            emoji: '🌍',
            title: 'Open Food Facts',
            subtitle: 'Powered by Open Food Facts',
            description:
                'Dane o produktach spożywczych (nazwy, składniki, kalorie) '
                'pochodzą z bazy Open Food Facts — wolnej, współtworzonej '
                'przez społeczność bazy danych żywności z całego świata.',
            license: 'Licencja ODbL (Open Database Licence)',
            url: 'https://world.openfoodfacts.org',
            accentColor: AppColors.success,
          ),

          const SizedBox(height: 12),

          _AttributionCard(
            emoji: '🇺🇸',
            title: 'USDA FoodData Central',
            subtitle: 'Fallback API — dane odżywcze',
            description:
                'W przypadku braku produktu w bazie Open Food Facts, '
                'aplikacja używa bazy USDA FoodData Central jako uzupełnienia.',
            license: 'Publiczne źródło rządowe USA (bez ograniczeń)',
            url: 'https://fdc.nal.usda.gov',
            accentColor: AppColors.fridge,
          ),

          const SizedBox(height: 24),
          Text(
            'TECHNOLOGIE AI (ON-DEVICE)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 12),

          _AttributionCard(
            emoji: '🤖',
            title: 'Google ML Kit',
            subtitle: 'Rozpoznawanie tekstu (OCR)',
            description:
                'Rozpoznawanie dat ważności z etykiet produktów działa '
                'całkowicie offline — przetwarzanie odbywa się na urządzeniu '
                '(on-device), żadne zdjęcia nie są wysyłane na zewnętrzne serwery.',
            license: 'Apache 2.0',
            url: 'https://developers.google.com/ml-kit',
            accentColor: AppColors.warning,
          ),

          const SizedBox(height: 24),
          Text(
            'OPEN SOURCE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppTheme.radiusMedium,
            ),
            child: Text(
              'Fridgge korzysta z wielu pakietów Open Source na licencjach MIT, '
              'BSD i Apache 2.0, w tym: Flutter, Riverpod, Isar, GoRouter, '
              'Freezed, Dio, Google Fonts i innych. '
              'Pełna lista zależności dostępna jest w pliku pubspec.yaml.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _AttributionCard extends StatelessWidget {
  const _AttributionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.license,
    required this.url,
    required this.accentColor,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String description;
  final String license;
  final String url;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.radiusMedium,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: accentColor)),
                    Text(subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(
            license,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(url,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}

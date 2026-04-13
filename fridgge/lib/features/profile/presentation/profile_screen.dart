// Ekran profilu użytkownika i ustawienia.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Text('Profil', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),

            // Avatar placeholder
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Center(
                      child: Text('👤',
                          style: TextStyle(fontSize: 36)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Gość', style: Theme.of(context).textTheme.titleMedium),
                  Text('Zaloguj się, aby zsynchronizować dane',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Zaloguj się'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sekcje ustawień
            _SectionHeader('Wygląd'),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              label: 'Tryb ciemny',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),

            const SizedBox(height: 16),
            _SectionHeader('Gospodartstwo domowe'),
            _SettingsTile(
              icon: Icons.group_outlined,
              label: 'Domownicy',
              onTap: () {},
              premium: true,
            ),
            _SettingsTile(
              icon: Icons.qr_code_outlined,
              label: 'Zaproś przez QR kod',
              onTap: () {},
              premium: true,
            ),

            const SizedBox(height: 16),
            _SectionHeader('NoWaste Pro 🔒'),
            _SettingsTile(
              icon: Icons.category_outlined,
              label: 'Niestandardowe kategorie',
              premium: true,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.restore_from_trash_outlined,
              label: 'Kosz (przywracanie)',
              premium: true,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              label: 'Zaawansowane powiadomienia',
              premium: true,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.file_download_outlined,
              label: 'Eksport CSV / PDF',
              premium: true,
              onTap: () {},
            ),

            const SizedBox(height: 16),
            _SectionHeader('Informacje'),
            _SettingsTile(
              icon: Icons.info_outline,
              label: 'O aplikacji i licencje',
              onTap: () => context.go(AppRoutes.about),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.premium = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.radiusMedium,
      ),
      child: ListTile(
        leading: Icon(icon, size: 20),
        title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        trailing: premium
            ? const Icon(Icons.lock_outline, color: AppColors.warning, size: 18)
            : (trailing ?? const Icon(Icons.chevron_right, size: 18)),
        onTap: onTap,
        shape: const RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
      ),
    );
  }
}

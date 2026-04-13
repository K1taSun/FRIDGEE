// Ekran logowania (Firebase Auth w Module 2).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    const Text('🥗', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text('Witaj w Fridgge',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Zarządzaj żywnością, generuj przepisy\ni redukuj marnowanie.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),

                    // Logowanie (Module 2 wepnie Firebase)
                    _AuthButton(
                      icon: Icons.email_outlined,
                      label: 'Kontynuuj z Email',
                      onTap: () => context.go(AppRoutes.register),
                    ),
                    const SizedBox(height: 12),
                    _AuthButton(
                      icon: Icons.g_mobiledata,
                      label: 'Kontynuuj z Google',
                      onTap: () {}, // Module 2
                    ),
                    const SizedBox(height: 12),
                    _AuthButton(
                      icon: Icons.apple,
                      label: 'Kontynuuj z Apple',
                      onTap: () {}, // Module 2
                    ),
                    const SizedBox(height: 24),

                    // Skip auth (tryb gościa / testy)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          ref.read(isGuestProvider.notifier).state = true;
                          context.go(AppRoutes.inventory);
                        },
                        child: const Text('Pomiń na razie'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const RoundedRectangleBorder(
              borderRadius: AppTheme.radiusMedium),
        ),
      ),
    );
  }
}

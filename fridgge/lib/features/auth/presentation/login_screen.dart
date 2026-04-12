// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — login_screen.dart
// Placeholder — full Firebase Auth implementation in Module 2.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // ── Logo ───────────────────────────────────────────────────────
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
              const Spacer(),

              // ── Auth buttons (Module 2 will wire Firebase) ─────────────────
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

              // ── Skip auth (testing / no-account flow) ─────────────────────
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.inventory),
                  child: const Text('Pomiń na razie'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
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

// Palette kolorystyczna aplikacji (tryb ciemny / jasny).

import 'package:flutter/material.dart';

abstract final class AppColors {
  static bool isDarkMode = true;

  // Warstwy tła
  static Color get background => isDarkMode ? _backgroundDark : backgroundLight;
  static Color get backgroundSecondary => isDarkMode ? _backgroundSecondaryDark : _backgroundSecondaryLight;
  static Color get surface => isDarkMode ? _surfaceDark : surfaceLight;
  static Color get surfaceElevated => isDarkMode ? _surfaceElevatedDark : surfaceElevatedLight;

  // Akcenty (wspólne)
  static const Color primary = Color(0xFF26C6DA);
  static const Color primaryDim = Color(0xFF1AABB2);
  static const Color primarySubtle = Color(0x1A26C6DA);

  // Kolory semantyczne
  static const Color error = Color(0xFFCF6679);
  static const Color errorSubtle = Color(0x1ACF6679);
  static const Color warning = Color(0xFFFFB74D);
  static const Color warningSubtle = Color(0x1AFFB74D);
  static const Color success = Color(0xFF66BB6A);
  static const Color successSubtle = Color(0x1A66BB6A);

  // Hierarchia tekstu
  static Color get textPrimary => isDarkMode ? _textPrimaryDark : textPrimaryLight;
  static Color get textSecondary => isDarkMode ? _textSecondaryDark : textSecondaryLight;
  static Color get textTertiary => isDarkMode ? _textTertiaryDark : textTertiaryLight;
  static Color get textDisabled => isDarkMode ? _textDisabledDark : _textDisabledLight;

  // Ramki i linie
  static Color get border => isDarkMode ? _borderDark : borderLight;
  static Color get divider => isDarkMode ? _dividerDark : dividerLight;

  static const Color scrim = Color(0x99000000);

  // Lokacje przechowywania
  static const Color fridge = Color(0xFF42A5F5);
  static const Color freezer = Color(0xFF7E57C2);
  static const Color pantry = Color(0xFFD4A843);

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get backgroundGradient => LinearGradient(
        colors: isDarkMode
            ? const [Color(0xFF181818), Color(0xFF121212)]
            : const [Color(0xFFF5F5F5), Color(0xFFEEEEEE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get cardGradient => LinearGradient(
        colors: isDarkMode
            ? const [Color(0xFF2A2A2A), Color(0xFF1E1E1E)]
            : const [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // ── Light palette (public for ThemeData) ────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFF0F0F0);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF616161);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color dividerLight = Color(0xFFEEEEEE);

  // ── Dark palette (public for ThemeData) ─────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF6E6E6E);
  static const Color surfaceDark = Color(0xFF242424);
  static const Color surfaceElevatedDark = Color(0xFF2E2E2E);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color borderDark = Color(0xFF2E2E2E);
  static const Color dividerDark = Color(0xFF1E1E1E);

  // ── Dark palette (private aliases) ────────────────────────────────────────────
  static const Color _backgroundDark = backgroundDark;
  static const Color _backgroundSecondaryDark = Color(0xFF181818);
  static const Color _surfaceDark = surfaceDark;
  static const Color _surfaceElevatedDark = surfaceElevatedDark;
  static const Color _textPrimaryDark = textPrimaryDark;
  static const Color _textSecondaryDark = textSecondaryDark;
  static const Color _textTertiaryDark = textTertiaryDark;
  static const Color _textDisabledDark = Color(0xFF3E3E3E);
  static const Color _borderDark = borderDark;
  static const Color _dividerDark = dividerDark;

  static const Color _backgroundSecondaryLight = Color(0xFFEEEEEE);
  static const Color _textDisabledLight = Color(0xFFBDBDBD);
}

// ──────────────────────────────────────────────────────────────────────────────
// Fridgge — app_colors.dart
// Single source of truth for the entire color palette.
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Background layers ────────────────────────────────────────────────────────
  /// Primary background — very dark graphite
  static const Color background = Color(0xFF121212);

  /// Secondary background — slightly lighter, used for bottom nav area
  static const Color backgroundSecondary = Color(0xFF181818);

  /// Surface / card background
  static const Color surface = Color(0xFF242424);

  /// Elevated surface — dialogs, bottom sheets
  static const Color surfaceElevated = Color(0xFF2E2E2E);

  // ── Primary accent ───────────────────────────────────────────────────────────
  /// Cyan / Teal primary accent — CTAs, active icons, highlights
  static const Color primary = Color(0xFF26C6DA);

  /// Slightly dimmed primary for pressed states
  static const Color primaryDim = Color(0xFF1AABB2);

  /// Primary with low opacity — used for chips, badges backgrounds
  static const Color primarySubtle = Color(0x1A26C6DA);

  // ── Semantic colors ──────────────────────────────────────────────────────────
  /// Error / danger — expired products, "no match" indicator
  static const Color error = Color(0xFFCF6679);

  /// Error with low opacity — error chip backgrounds
  static const Color errorSubtle = Color(0x1ACF6679);

  /// Warning — expiring within 48 h
  static const Color warning = Color(0xFFFFB74D);

  /// Warning with low opacity
  static const Color warningSubtle = Color(0x1AFFB74D);

  /// Success — fresh products, matched ingredients
  static const Color success = Color(0xFF66BB6A);

  /// Success with low opacity
  static const Color successSubtle = Color(0x1A66BB6A);

  // ── Text hierarchy ───────────────────────────────────────────────────────────
  /// Primary text
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text — subtitles, labels
  static const Color textSecondary = Color(0xFFB3B3B3);

  /// Tertiary / hint text
  static const Color textTertiary = Color(0xFF6E6E6E);

  /// Disabled text
  static const Color textDisabled = Color(0xFF3E3E3E);

  // ── Borders / dividers ───────────────────────────────────────────────────────
  static const Color border = Color(0xFF2E2E2E);
  static const Color divider = Color(0xFF1E1E1E);

  // ── Overlay ───────────────────────────────────────────────────────────────────
  static const Color scrim = Color(0x99000000);

  // ── Storage location chips ────────────────────────────────────────────────────
  static const Color fridge = Color(0xFF42A5F5);   // blue — Lodówka
  static const Color freezer = Color(0xFF7E57C2);  // purple — Zamrażarka
  static const Color pantry = Color(0xFFD4A843);   // amber — Spiżarnia

  // ── Gradients ────────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF181818), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Palette kolorystyczna aplikacji.

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Warstwy tła
  static const Color background = Color(0xFF121212); // Ciemny grafit
  static const Color backgroundSecondary = Color(0xFF181818); // Dolny pasek
  static const Color surface = Color(0xFF242424); // Karty
  static const Color surfaceElevated = Color(0xFF2E2E2E); // Dialogi / Arkusze

  // Akcenty
  static const Color primary = Color(0xFF26C6DA); // Cyjan / Teal
  static const Color primaryDim = Color(0xFF1AABB2); // Kliknięcie
  static const Color primarySubtle = Color(0x1A26C6DA); // Tło chipów

  // Kolory semantyczne
  static const Color error = Color(0xFFCF6679); // Produkty po terminie
  static const Color errorSubtle = Color(0x1ACF6679);
  static const Color warning = Color(0xFFFFB74D); // Kończąca się data
  static const Color warningSubtle = Color(0x1AFFB74D);
  static const Color success = Color(0xFF66BB6A); // Świeże / dopasowane
  static const Color successSubtle = Color(0x1A66BB6A);

  // Hierarchia tekstu
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3); // Podpisy
  static const Color textTertiary = Color(0xFF6E6E6E); // Hinty kseruj
  static const Color textDisabled = Color(0xFF3E3E3E);

  // Ramki i linie
  static const Color border = Color(0xFF2E2E2E);
  static const Color divider = Color(0xFF1E1E1E);

  // Overlay
  static const Color scrim = Color(0x99000000);

  // Lokacje przechowywania
  static const Color fridge = Color(0xFF42A5F5);   // Lodówka
  static const Color freezer = Color(0xFF7E57C2);  // Zamrażarka
  static const Color pantry = Color(0xFFD4A843);   // Spiżarnia

  // Gradienty
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

// Definicja motywu Material 3: Dark i Light.
// Typografia: Inter (google_fonts).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  // Border radii (tokeny)
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(32));

  // Motyw CIEMNY
  static ThemeData get dark {
    final base = ThemeData.dark();
    final textTheme = _buildTextTheme(base.textTheme, isDark: true);

    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.backgroundDark,
        primaryContainer: AppColors.primarySubtle,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.primary,
        onSecondary: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        surfaceContainerHighest: AppColors.surfaceElevatedDark,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.dividerDark,
        scrim: AppColors.scrim,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        actionsIconTheme: const IconThemeData(color: AppColors.textSecondaryDark),
      ),

      // Karty
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        margin: EdgeInsets.zero,
      ),

      // Przyciski
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.borderDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.backgroundDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryDark,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // TextFieldy
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: AppColors.textTertiaryDark, fontSize: 14),
        labelStyle: TextStyle(color: AppColors.textSecondaryDark),
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // Chipy
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedColor: AppColors.primarySubtle,
        labelStyle: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
        side: BorderSide(color: AppColors.borderDark),
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // Dialogi
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLarge,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        modalElevation: 0,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 0,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: AppColors.textSecondaryDark,
        textColor: AppColors.textPrimaryDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // Ikony
      iconTheme: const IconThemeData(color: AppColors.textSecondaryDark, size: 24),
      primaryIconTheme: const IconThemeData(color: AppColors.primary, size: 24),

      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        contentTextStyle: TextStyle(color: AppColors.textPrimaryDark),
        actionTextColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        behavior: SnackBarBehavior.floating,
      ),

      // Switche
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.background;
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.border;
        }),
      ),

      // Progress bar
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // Tab bar
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiaryDark,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
      ),
    );
  }

  // Motyw JASNY
  static ThemeData get light {
    final base = ThemeData.light();
    final textTheme = _buildTextTheme(base.textTheme, isDark: false);

    return base.copyWith(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primarySubtle,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.primary,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        surfaceContainerHighest: AppColors.surfaceElevatedLight,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.dividerLight,
        scrim: AppColors.scrim,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        actionsIconTheme: const IconThemeData(color: AppColors.textSecondaryLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.borderLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: radiusMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textTertiaryLight, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevatedLight,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: radiusLarge),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondaryLight,
        textColor: AppColors.textPrimaryLight,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondaryLight, size: 24),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.textTertiaryLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.borderLight;
        }),
      ),
    );
  }

  // ── Text Theme (Inter via google_fonts) ─────────────────────────────────────
  static TextTheme _buildTextTheme(TextTheme base, {required bool isDark}) {
    final primary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final tertiary = isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

    return GoogleFonts.interTextTheme(base).copyWith(
      // Display
      displayLarge: GoogleFonts.inter(
        fontSize: 57, fontWeight: FontWeight.w700,
        color: primary, letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45, fontWeight: FontWeight.w700,
        color: primary, letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36, fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: primary, letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0.1,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: secondary, letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w500,
        color: tertiary, letterSpacing: 0.5,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Thème principal de BudgetWise.
///
/// Usage dans [MaterialApp] :
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  // ── Constantes de design ─────────────────────────────
  static const double radiusSmall  = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge  = 20.0;
  static const double radiusXL     = 28.0;

  static const double spacingXS    = 4.0;
  static const double spacingS     = 8.0;
  static const double spacingM     = 16.0;
  static const double spacingL     = 24.0;
  static const double spacingXL    = 32.0;

  // ── Thème clair ──────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary:          AppColors.primary,
      onPrimary:        Colors.white,
      primaryContainer: AppColors.primaryLight,
      secondary:        AppColors.secondary,
      onSecondary:      Colors.white,
      surface:          AppColors.surface,
      onSurface:        AppColors.textPrimary,
      error:            AppColors.expense,
      onError:          Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: _appBarTheme(Brightness.light),
    cardTheme: _cardTheme(Brightness.light),
    elevatedButtonTheme: _elevatedButtonTheme(),
    inputDecorationTheme: _inputDecorationTheme(Brightness.light),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
    chipTheme: _chipTheme(Brightness.light),
  );

  // ── Thème sombre ─────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary:          AppColors.primaryLight,
      onPrimary:        AppColors.primaryDark,
      primaryContainer: AppColors.primaryDark,
      secondary:        AppColors.secondaryLight,
      onSecondary:      AppColors.secondaryDark,
      surface:          AppColors.darkSurface,
      onSurface:        Colors.white,
      error:            AppColors.expense,
      onError:          Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: _appBarTheme(Brightness.dark),
    cardTheme: _cardTheme(Brightness.dark),
    elevatedButtonTheme: _elevatedButtonTheme(),
    inputDecorationTheme: _inputDecorationTheme(Brightness.dark),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),
    chipTheme: _chipTheme(Brightness.dark),
  );

  // ── Constructeurs privés ─────────────────────────────

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? AppColors.textPrimary
        : Colors.white;

    return GoogleFonts.interTextTheme().copyWith(
      displayLarge:  AppTextStyles.displayLarge.copyWith(color: color),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
      bodyLarge:     AppTextStyles.bodyLarge.copyWith(color: color),
      bodyMedium:    AppTextStyles.bodyMedium.copyWith(color: color),
      bodySmall:     AppTextStyles.bodySmall,
      labelLarge:    AppTextStyles.labelLarge.copyWith(color: color),
    );
  }

  static AppBarTheme _appBarTheme(Brightness brightness) => AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: false,
    backgroundColor: brightness == Brightness.light
        ? AppColors.surface
        : AppColors.darkSurface,
    foregroundColor: brightness == Brightness.light
        ? AppColors.textPrimary
        : Colors.white,
  );

  static CardThemeData _cardTheme(Brightness brightness) => CardThemeData(
    elevation: 0,
    color: brightness == Brightness.light
        ? AppColors.card
        : AppColors.darkCard,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
      side: BorderSide(
        color: brightness == Brightness.light
            ? AppColors.divider
            : AppColors.darkDivider,
        width: 1,
      ),
    ),
    margin: EdgeInsets.zero,
  );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) =>
      InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? AppColors.card
            : AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
      );

  static ChipThemeData _chipTheme(Brightness brightness) => ChipThemeData(
    backgroundColor: brightness == Brightness.light
        ? AppColors.surface
        : AppColors.darkCard,
    labelStyle: AppTextStyles.bodySmall,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusSmall),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingS,
      vertical: spacingXS,
    ),
  );
}
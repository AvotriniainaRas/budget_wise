import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Styles de texte de l'application BudgetWise.
///
/// Basés sur la police [Inter] via Google Fonts.
/// Hiérarchie : displayLarge → bodySmall → labelSmall.
abstract final class AppTextStyles {
  static TextStyle get _base => GoogleFonts.inter(
    color: AppColors.textPrimary,
  );

  // ── Titres principaux ────────────────────────────────
  static TextStyle get displayLarge => _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get headlineLarge => _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headlineMedium => _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineSmall => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // ── Corps de texte ───────────────────────────────────
  static TextStyle get bodyLarge => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodySmall => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Labels & montants ────────────────────────────────
  static TextStyle get labelLarge => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  /// Style spécifique pour afficher les montants financiers.
  static TextStyle get amount => _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
  );

  static TextStyle get amountSmall => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );
}
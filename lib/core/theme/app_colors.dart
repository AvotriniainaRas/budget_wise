import 'package:flutter/material.dart';

/// Palette de couleurs de l'application BudgetWise.
///
/// Toutes les couleurs sont définies ici et référencées
/// depuis [AppTheme]. Ne jamais écrire de couleurs en dur
/// dans les widgets — toujours utiliser cette classe ou
/// [Theme.of(context).colorScheme].
abstract final class AppColors {
  // ── Couleurs primaires ──────────────────────────────
  static const Color primary        = Color(0xFF5C6BC0); // Indigo
  static const Color primaryLight   = Color(0xFF8E99F3);
  static const Color primaryDark    = Color(0xFF26418F);

  // ── Couleurs secondaires ────────────────────────────
  static const Color secondary      = Color(0xFF26A69A); // Teal
  static const Color secondaryLight = Color(0xFF64D8CB);
  static const Color secondaryDark  = Color(0xFF00766C);

  // ── Sémantique financière ───────────────────────────
  static const Color income         = Color(0xFF66BB6A); // Vert  = revenu
  static const Color expense        = Color(0xFFEF5350); // Rouge = dépense
  static const Color savings        = Color(0xFFFFB300); // Ambre = épargne

  // ── Neutres ─────────────────────────────────────────
  static const Color surface        = Color(0xFFF8F9FA);
  static const Color card           = Color(0xFFFFFFFF);
  static const Color divider        = Color(0xFFE0E0E0);

  // ── Textes ──────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF1A1A2E);
  static const Color textSecondary  = Color(0xFF6B7280);
  static const Color textHint       = Color(0xFFB0BEC5);

  // ── Dark mode ───────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface    = Color(0xFF1A1A2E);
  static const Color darkCard       = Color(0xFF252540);
  static const Color darkDivider    = Color(0xFF2E2E4A);
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';

/// Widget racine de l'application BudgetWise.
///
/// [ConsumerWidget] permet d'écouter les providers Riverpod.
/// Ici on l'utilise pour observer le [themeMode] (clair/sombre).
class BudgetWiseApp extends ConsumerWidget {
  const BudgetWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'BudgetWise',
      debugShowCheckedModeBanner: false,

      // Thèmes clair et sombre définis dans AppTheme.
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // Suit les préférences système pour l'instant.
      // On branchera un provider Riverpod ici plus tard.
      themeMode: ThemeMode.system,

      // Écran temporaire pour vérifier que tout compile.
      home: const _PlaceholderScreen(),
    );
  }
}

/// Écran temporaire — sera remplacé par go_router.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts  = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Text('BudgetWise', style: texts.displayLarge),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                'Thème chargé avec succès ✓',
                style: texts.bodyLarge?.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Aperçu des couleurs
              Text('Palette de couleurs', style: texts.headlineSmall),
              const SizedBox(height: AppTheme.spacingM),
              _ColorRow(label: 'Primary',  color: AppColors.primary),
              _ColorRow(label: 'Secondary',color: AppColors.secondary),
              _ColorRow(label: 'Revenus',  color: AppColors.income),
              _ColorRow(label: 'Dépenses', color: AppColors.expense),
              _ColorRow(label: 'Épargne',  color: AppColors.savings),

              const SizedBox(height: AppTheme.spacingXL),

              // Aperçu des typographies
              Text('Typographie', style: texts.headlineSmall),
              const SizedBox(height: AppTheme.spacingM),
              Text('Headline Large',  style: texts.headlineLarge),
              Text('Headline Medium', style: texts.headlineMedium),
              Text('Body Large',      style: texts.bodyLarge),
              Text('Body Small',      style: texts.bodySmall),
              Text(
                '1 234 500 Ar',
                style: AppTextStyles.amount.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget utilitaire pour afficher une couleur avec son label.
class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.label, required this.color});

  final String label;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
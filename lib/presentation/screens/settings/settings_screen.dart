import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../providers/providers.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/models.dart';

import '../../../core/services/preferences_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── En-tête ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paramètres',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Personnalisez votre expérience',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // ── Apparence ──────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Apparence',
                children: [
                  _ThemeSelector(currentMode: themeMode),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Export ─────────────────────────────────
            const SliverToBoxAdapter(
              child: _Section(
                title: 'Export des données',
                children: [
                  _ExportTile(
                    icon: Icons.table_chart_rounded,
                    color: AppColors.secondary,
                    title: 'Exporter en CSV',
                    subtitle: 'Compatible Excel, Google Sheets',
                    format: 'csv',
                  ),
                  _ExportTile(
                    icon: Icons.picture_as_pdf_rounded,
                    color: AppColors.expense,
                    title: 'Exporter en PDF',
                    subtitle: 'Rapport complet avec résumé',
                    format: 'pdf',
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── À propos ────────────────────────────────
            const SliverToBoxAdapter(
              child: _Section(
                title: 'À propos',
                children: [
                  _InfoTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Version',
                    trailing: '1.0.0',
                  ),
                  _InfoTile(
                    icon: Icons.code_rounded,
                    title: 'Développé avec Flutter',
                    trailing: '❤️',
                  ),
                  _InfoTile(
                    icon: Icons.school_rounded,
                    title: 'Developpé par',
                    trailing: 'Avotriniaina Ras',
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            const SliverToBoxAdapter(
              child: _Section(
                title: 'Zone de danger',
                children: [
                  _ResetTile(),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingXL),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets internes ─────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: children.asMap().entries.map((entry) {
                final isLast = entry.key == children.length - 1;
                return Column(
                  children: [
                    entry.value,
                    if (!isLast) const Divider(height: 1, indent: 56),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sélecteur de thème ────────────────────────────────────

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector({required this.currentMode});

  final ThemeMode currentMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.palette_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text(
                'Thème',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              _ThemeOption(
                label: 'Clair',
                icon: Icons.light_mode_rounded,
                selected: currentMode == ThemeMode.light,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light),
              ),
              _ThemeOption(
                label: 'Sombre',
                icon: Icons.dark_mode_rounded,
                selected: currentMode == ThemeMode.dark,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark),
              ),
              _ThemeOption(
                label: 'Système',
                icon: Icons.settings_suggest_rounded,
                selected: currentMode == ThemeMode.system,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingM,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textHint,
                size: 22,
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tuile d'export ────────────────────────────────────────

class _ExportTile extends ConsumerWidget {
  const _ExportTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.format,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(
        Icons.download_rounded,
        color: AppColors.textHint,
      ),
      onTap: () => _export(context, ref),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    bool dialogOpen = false;

    try {
      // Ouvre le loader
      dialogOpen = true;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final exportService = ref.read(exportServiceProvider);
      final transactions =
          await ref.read(transactionRepositoryProvider).getAll();
      final categories = await ref.read(categoryRepositoryProvider).getAll();
      final summary = await ref
          .read(getMonthlySummaryProvider)
          .call(DateTime.now().year, DateTime.now().month);

      String path;
      if (format == 'csv') {
        path = await exportService.exportToCsv(transactions, categories);
      } else {
        path = await exportService.exportToPdf(
          transactions,
          categories,
          summary,
        );
      }

      if (context.mounted) {
        // Ferme le loader avec le navigator racine
        if (dialogOpen) {
          Navigator.of(context, rootNavigator: true).pop();
          dialogOpen = false;
        }
        _showSuccessDialog(context, path);
      }
    } catch (e) {
      if (context.mounted) {
        if (dialogOpen) {
          Navigator.of(context, rootNavigator: true).pop();
          dialogOpen = false;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur export : $e'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.income),
            SizedBox(width: AppTheme.spacingS),
            Text('Export réussi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fichier enregistré dans :'),
            const SizedBox(height: AppTheme.spacingS),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                path,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ── Tuile d'information ───────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Text(
        trailing,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}

class _ResetTile extends ConsumerWidget {
  const _ResetTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.expense.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: const Icon(
          Icons.delete_forever_rounded,
          color: AppColors.expense,
          size: 18,
        ),
      ),
      title: Text(
        'Réinitialiser les données',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.expense,
            ),
      ),
      subtitle: Text(
        'Supprimer toutes les transactions, catégories et objectifs',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.expense,
      ),
      onTap: () => _confirmReset(context, ref),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    // ── Première confirmation ────────────────────────
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.expense,
            ),
            SizedBox(width: AppTheme.spacingS),
            Text('Réinitialiser ?'),
          ],
        ),
        content: const Text(
          'Toutes vos données seront supprimées définitivement :\n\n'
          '• Toutes les transactions\n'
          '• Toutes les catégories\n'
          '• Tous les objectifs d\'épargne\n\n'
          'Cette action est IRRÉVERSIBLE.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );

    if (firstConfirm != true || !context.mounted) return;

    // ── Deuxième confirmation — saisie de texte ──────
    final textCtrl = TextEditingController();
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation finale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tapez "SUPPRIMER" pour confirmer la réinitialisation :',
            ),
            const SizedBox(height: AppTheme.spacingM),
            TextField(
              controller: textCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'SUPPRIMER',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
            ),
            onPressed: () {
              final confirmed = textCtrl.text.trim() == 'SUPPRIMER';
              Navigator.of(context, rootNavigator: true).pop(confirmed);
            },
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );

    textCtrl.dispose();
    if (secondConfirm != true || !context.mounted) return;

    // ── Exécution du reset ───────────────────────────
    await _performReset(context, ref);
  }

  Future<void> _performReset(BuildContext context, WidgetRef ref) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Vide toutes les boîtes Hive
      await Hive.box<TransactionModel>('transactions').clear();
      await Hive.box<CategoryModel>('categories').clear();
      await Hive.box<SavingsGoalModel>('savings_goals').clear();

      // ← Ajouter cette ligne — remet l'onboarding à afficher
      await PreferencesService.instance.setOnboardingDone(false);

      // Réinitialise les catégories par défaut
      await ref.read(categoryRepositoryProvider).seedDefaults();

      // Invalide tous les providers
      ref.invalidate(transactionsProvider);
      ref.invalidate(monthlySummaryProvider);
      ref.invalidate(categoriesProvider);
      ref.invalidate(savingsGoalsProvider);
      ref.invalidate(activeSavingsGoalsProvider);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Données réinitialisées avec succès. Veuillez relancer l\'application.'),
            backgroundColor: AppColors.income,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }
}

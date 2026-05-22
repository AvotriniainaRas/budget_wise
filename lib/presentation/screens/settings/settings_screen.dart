import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/export_service.dart';
import '../../providers/providers.dart';

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
                      style: Theme.of(context).textTheme.bodyMedium
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
            SliverToBoxAdapter(
              child: _Section(
                title: 'Export des données',
                children: [
                  _ExportTile(
                    icon:     Icons.table_chart_rounded,
                    color:    AppColors.secondary,
                    title:    'Exporter en CSV',
                    subtitle: 'Compatible Excel, Google Sheets',
                    format:   'csv',
                  ),
                  _ExportTile(
                    icon:     Icons.picture_as_pdf_rounded,
                    color:    AppColors.expense,
                    title:    'Exporter en PDF',
                    subtitle: 'Rapport complet avec résumé',
                    format:   'pdf',
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── À propos ────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'À propos',
                children: [
                  _InfoTile(
                    icon:     Icons.info_outline_rounded,
                    title:    'Version',
                    trailing: '1.0.0',
                  ),
                  _InfoTile(
                    icon:     Icons.code_rounded,
                    title:    'Développé avec Flutter',
                    trailing: '❤️',
                  ),
                  _InfoTile(
                    icon:     Icons.school_rounded,
                    title:    'Architecture',
                    trailing: 'Clean Architecture',
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingXL),
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

  final String         title;
  final List<Widget>   children;

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
              color:          AppColors.primary,
              letterSpacing:  1,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Container(
            decoration: BoxDecoration(
              color:        Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: children
                  .asMap()
                  .entries
                  .map((entry) {
                    final isLast = entry.key == children.length - 1;
                    return Column(
                      children: [
                        entry.value,
                        if (!isLast)
                          const Divider(height: 1, indent: 56),
                      ],
                    );
                  })
                  .toList(),
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
                width:       36,
                height:      36,
                decoration:  BoxDecoration(
                  color:        AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.palette_rounded,
                  color: AppColors.primary,
                  size:  18,
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
                label:    'Clair',
                icon:     Icons.light_mode_rounded,
                selected: currentMode == ThemeMode.light,
                onTap:    () => ref
                    .read(themeModeProvider.notifier)
                    .state = ThemeMode.light,
              ),
              const SizedBox(width: AppTheme.spacingS),
              _ThemeOption(
                label:    'Sombre',
                icon:     Icons.dark_mode_rounded,
                selected: currentMode == ThemeMode.dark,
                onTap:    () => ref
                    .read(themeModeProvider.notifier)
                    .state = ThemeMode.dark,
              ),
              const SizedBox(width: AppTheme.spacingS),
              _ThemeOption(
                label:    'Système',
                icon:     Icons.settings_suggest_rounded,
                selected: currentMode == ThemeMode.system,
                onTap:    () => ref
                    .read(themeModeProvider.notifier)
                    .state = ThemeMode.system,
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

  final String       label;
  final IconData     icon;
  final bool         selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration:   const Duration(milliseconds: 200),
          padding:    const EdgeInsets.symmetric(
            vertical: AppTheme.spacingM,
          ),
          decoration: BoxDecoration(
            color:        selected
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
                size:  22,
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:      selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
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
  final Color    color;
  final String   title;
  final String   subtitle;
  final String   format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical:   AppTheme.spacingXS,
      ),
      leading: Container(
        width:       36,
        height:      36,
        decoration:  BoxDecoration(
          color:        color.withValues(alpha: 0.1),
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
    // Affiche un indicateur de chargement
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final exportService   = ref.read(exportServiceProvider);
      final transactions    = await ref
          .read(transactionRepositoryProvider)
          .getAll();
      final categories      = await ref
          .read(categoryRepositoryProvider)
          .getAll();
      final summary         = await ref
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
        Navigator.pop(context); // Ferme le loader
        _showSuccessDialog(context, path);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:         Text('Erreur export : $e'),
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
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.income),
            const SizedBox(width: AppTheme.spacingS),
            const Text('Export réussi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fichier enregistré dans :'),
            const SizedBox(height: AppTheme.spacingS),
            Container(
              padding:    const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color:        AppColors.surface,
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
            onPressed: () => Navigator.pop(context),
            child:     const Text('OK'),
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
  final String   title;
  final String   trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical:   AppTheme.spacingXS,
      ),
      leading: Container(
        width:       36,
        height:      36,
        decoration:  BoxDecoration(
          color:        AppColors.primary.withValues(alpha: 0.1),
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
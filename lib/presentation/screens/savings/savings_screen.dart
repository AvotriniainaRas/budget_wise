import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../navigation/app_router.dart';
import '../../providers/providers.dart';
import '../../widgets/common/empty_state.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync    = ref.watch(activeSavingsGoalsProvider);
    final completedAsync = ref.watch(savingsGoalsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed:       () => context.push(AppRoutes.addSavingsGoal),
        backgroundColor: AppColors.savings,
        foregroundColor: Colors.white,
        icon:            const Icon(Icons.add_rounded),
        label:           const Text('Nouvel objectif'),
      ),
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
                      'Épargne',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Suivez vos objectifs financiers',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // ── Résumé épargne ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: _SavingsSummaryCard(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingL),
            ),

            // ── Objectifs en cours ─────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: Text(
                  'En cours',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            activeAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Erreur : $e')),
              ),
              data: (goals) {
                if (goals.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                      icon:     Icons.savings_rounded,
                      title:    'Aucun objectif en cours',
                      subtitle: 'Créez votre premier objectif\nd\'épargne !',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _SavingsGoalCard(
                        goal: goals[index],
                      ),
                      childCount: goals.length,
                    ),
                  ),
                );
              },
            ),

            // ── Objectifs complétés ────────────────────
            completedAsync.when(
              loading: () => const SliverToBoxAdapter(child: SizedBox()),
              error:   (_, __) => const SliverToBoxAdapter(child: SizedBox()),
              data: (allGoals) {
                final completed = allGoals
                    .where((g) => g.isCompleted)
                    .toList();
                if (completed.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }
                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.spacingL,
                          AppTheme.spacingL,
                          AppTheme.spacingL,
                          AppTheme.spacingM,
                        ),
                        child: Text(
                          'Complétés 🎉',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacingL,
                        0,
                        AppTheme.spacingL,
                        120,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _SavingsGoalCard(
                            goal:        completed[index],
                            isCompleted: true,
                          ),
                          childCount: completed.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Carte résumé global ───────────────────────────────────

class _SavingsSummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider);

    return goalsAsync.when(
      loading: () => const SizedBox.shrink(),
      error:   (_, __) => const SizedBox.shrink(),
      data: (goals) {
        final totalTarget  = goals.fold<double>(
          0, (sum, g) => sum + g.targetAmount,
        );
        final totalCurrent = goals.fold<double>(
          0, (sum, g) => sum + g.currentAmount,
        );
        final totalProgress = totalTarget == 0
            ? 0.0
            : totalCurrent / totalTarget;

        final formatter = NumberFormat('#,###', 'fr_FR');

        return Container(
          padding:    const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
              colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total épargné',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                '${formatter.format(totalCurrent)} Ar',
                style: AppTextStyles.displayLarge.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                'sur ${formatter.format(totalTarget)} Ar visés',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Barre de progression globale
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value:            totalProgress,
                  backgroundColor:  Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(totalProgress * 100).toStringAsFixed(1)}% atteint',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    '${goals.length} objectif${goals.length > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Carte objectif individuel ─────────────────────────────

class _SavingsGoalCard extends ConsumerWidget {
  const _SavingsGoalCard({
    required this.goal,
    this.isCompleted = false,
  });

  final SavingsGoal goal;
  final bool        isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    final daysLeft  = goal.deadline.difference(DateTime.now()).inDays;

    return Container(
      margin:  const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color:        Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: isCompleted
              ? AppColors.income.withValues(alpha: 0.4)
              : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre + actions ───────────────────────────
          Row(
            children: [
              // Icône
              Container(
                width:       44,
                height:      44,
                decoration:  BoxDecoration(
                  color:        isCompleted
                      ? AppColors.income.withValues(alpha: 0.15)
                      : AppColors.savings.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.savings_rounded,
                  color: isCompleted ? AppColors.income : AppColors.savings,
                  size:  22,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),

              // Titre et délai
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      isCompleted
                          ? 'Objectif atteint ✓'
                          : goal.isOverdue
                              ? 'Délai dépassé !'
                              : '$daysLeft jour${daysLeft > 1 ? 's' : ''} restant${daysLeft > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isCompleted
                            ? AppColors.income
                            : goal.isOverdue
                                ? AppColors.expense
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu actions
              if (!isCompleted)
                PopupMenuButton<String>(
                  onSelected: (value) => _handleAction(context, ref, value),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'add',
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Ajouter un montant'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size:  18,
                            color: AppColors.expense,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Supprimer',
                            style: TextStyle(color: AppColors.expense),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // ── Montants ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${formatter.format(goal.currentAmount)} Ar',
                style: AppTextStyles.amountSmall.copyWith(
                  color: isCompleted ? AppColors.income : AppColors.savings,
                ),
              ),
              Text(
                '${formatter.format(goal.targetAmount)} Ar',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingS),

          // ── Barre de progression ──────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value:           goal.progress,
              backgroundColor: isCompleted
                  ? AppColors.income.withValues(alpha: 0.15)
                  : AppColors.savings.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? AppColors.income : AppColors.savings,
              ),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: AppTheme.spacingXS),

          // ── Pourcentage ───────────────────────────────
          Text(
            '${goal.progressPercent.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isCompleted ? AppColors.income : AppColors.savings,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) {
    if (action == 'add') {
      _showAddAmountDialog(context, ref);
    } else if (action == 'delete') {
      _confirmDelete(context, ref);
    }
  }

  Future<void> _showAddAmountDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final ctrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title:   const Text('Ajouter un montant'),
        content: TextField(
          controller:   ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration:   const InputDecoration(
            hintText:   'Montant en Ar',
            prefixText: 'Ar  ',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:     const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.savings,
              minimumSize:     const Size(80, 40),
            ),
            onPressed: () async {
              final amount = double.tryParse(
                ctrl.text.replaceAll(',', '.'),
              );
              if (amount == null || amount <= 0) return;

              await ref
                  .read(updateSavingsProgressProvider)
                  .call(goal.id, amount);

              ref.invalidate(savingsGoalsProvider);
              ref.invalidate(activeSavingsGoalsProvider);

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:   const Text('Supprimer l\'objectif ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:     const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.expense,
            ),
            onPressed: () => Navigator.pop(context, true),
            child:     const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ref.read(deleteSavingsGoalProvider).call(goal.id);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(activeSavingsGoalsProvider);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider);
    final texts        = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BudgetWise', style: texts.headlineLarge),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                'Tableau de bord',
                style: texts.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              summaryAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Text(
                  'Erreur : $e',
                  style: const TextStyle(color: AppColors.expense),
                ),
                data: (summary) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Solde du mois', style: texts.headlineSmall),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      '${summary.balance.toStringAsFixed(0)} Ar',
                      style: AppTextStyles.amount.copyWith(
                        color: summary.isPositive
                            ? AppColors.income
                            : AppColors.expense,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    Row(
                      children: [
                        _SummaryChip(
                          label:  'Revenus',
                          amount: summary.totalIncome,
                          color:  AppColors.income,
                          icon:   Icons.arrow_upward_rounded,
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        _SummaryChip(
                          label:  'Dépenses',
                          amount: summary.totalExpense,
                          color:  AppColors.expense,
                          icon:   Icons.arrow_downward_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String   label;
  final double   amount;
  final Color    color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color:        color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border:       Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              '${amount.toStringAsFixed(0)} Ar',
              style: AppTextStyles.amountSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
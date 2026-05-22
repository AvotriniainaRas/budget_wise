import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/usecases/transaction/get_monthly_summary.dart';
import '../../widgets/common/animated_counter.dart';

/// Grande carte affichant le solde du mois.
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'fr_FR');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: summary.isPositive
              ? [AppColors.primary, AppColors.primaryDark]
              : [AppColors.expense, const Color(0xFFB71C1C)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Solde du mois',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: AppTheme.spacingS),

          // Montant principal
          AnimatedCounter(
            value: summary.balance.abs(),
            prefix: '',
            suffix: ' Ar',
            style: AppTextStyles.displayLarge.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),

          // Indicateur positif/négatif
          Row(
            children: [
              Icon(
                summary.isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 16,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Text(
                summary.isPositive
                    ? 'Taux d\'épargne : ${summary.savingsRate.toStringAsFixed(1)}%'
                    : 'Dépenses supérieures aux revenus',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingL),
          const Divider(color: Colors.white24, thickness: 1),
          const SizedBox(height: AppTheme.spacingM),

          // Revenus et dépenses
          Row(
            children: [
              Expanded(
                child: _BalanceItem(
                  label: 'Revenus',
                  amount: summary.totalIncome,
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFF81C784),
                  formatter: formatter,
                ),
              ),
              Expanded(
                child: _BalanceItem(
                  label: 'Dépenses',
                  amount: summary.totalExpense,
                  icon: Icons.arrow_downward_rounded,
                  color: const Color(0xFFEF9A9A),
                  formatter: formatter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  const _BalanceItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.formatter,
  });

  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingXS),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppTheme.spacingS),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
            ),
            Text(
              '${formatter.format(amount)} Ar',
              style: AppTextStyles.amountSmall.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

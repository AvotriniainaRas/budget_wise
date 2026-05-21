import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../providers/providers.dart';

/// Widget de navigation entre les mois.
///
/// Affiche le mois courant avec deux flèches pour
/// naviguer vers le mois précédent ou suivant.
class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final now           = DateTime.now();
    final isCurrentMonth =
        selectedMonth.year  == now.year &&
        selectedMonth.month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Flèche gauche — mois précédent
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: () => ref.read(selectedMonthProvider.notifier).state =
              DateTime(
                selectedMonth.year,
                selectedMonth.month - 1,
              ),
        ),

        // Mois affiché au centre
        Column(
          children: [
            Text(
              DateFormat('MMMM', 'fr_FR').format(selectedMonth).toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ),
            Text(
              selectedMonth.year.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),

        // Flèche droite — mois suivant (désactivée si mois courant)
        _NavButton(
          icon:     Icons.chevron_right_rounded,
          disabled: isCurrentMonth,
          onTap:    isCurrentMonth
              ? null
              : () => ref.read(selectedMonthProvider.notifier).state =
                    DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                    ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  36,
        height: 36,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.divider
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Icon(
          icon,
          color: disabled
              ? AppColors.textHint
              : AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}
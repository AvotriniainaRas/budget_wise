import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';

/// Élément de liste pour une transaction.
class TransactionListItem extends ConsumerWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  final Transaction    transaction;
  final VoidCallback?  onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final formatter       = DateFormat('dd MMM', 'fr_FR');

    return categoriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error:   (_, __) => const SizedBox.shrink(),
      data: (categories) {
        final category = categories.firstWhere(
          (c) => c.id == transaction.categoryId,
          orElse: () => const Category(
            id:    '',
            name:  'Autre',
            icon:  Icons.category_rounded,
            color: AppColors.textSecondary,
          ),
        );

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin:  const EdgeInsets.only(bottom: AppTheme.spacingS),
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color:        Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(
                color: Theme.of(context).dividerTheme.color ??
                    AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                // Icône catégorie
                Container(
                  width:       44,
                  height:      44,
                  decoration:  BoxDecoration(
                    color:        category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size:  22,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),

                // Titre et date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines:  1,
                        overflow:  TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${category.name} · ${formatter.format(transaction.date)}',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Montant
                Text(
                  '${transaction.isIncome ? '+' : '-'}'
                  '${NumberFormat('#,###', 'fr_FR').format(transaction.amount)} Ar',
                  style: AppTextStyles.amountSmall.copyWith(
                    fontSize: 15,
                    color: transaction.isIncome
                        ? AppColors.income
                        : AppColors.expense,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
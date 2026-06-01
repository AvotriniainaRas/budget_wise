import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../navigation/app_router.dart';
import '../../providers/providers.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/month_selector.dart';
import '../../widgets/common/transaction_list_item.dart';

import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredTransactionsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed:       () => context.push(AppRoutes.addTransaction),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child:           const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── En-tête ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                ),
                child: Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),

            // ── Sélecteur de mois ────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: MonthSelector(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Barre de recherche ───────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: _SearchBar(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Filtres type ─────────────────────────────
            SliverToBoxAdapter(
              child: _TypeFilterRow(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Filtres catégorie ────────────────────────
            SliverToBoxAdapter(
              child: _CategoryFilterRow(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Résumé rapide ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: _QuickSummary(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Liste des transactions ───────────────────
            filteredAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Erreur : $e')),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                      icon:     Icons.receipt_long_rounded,
                      title:    'Aucune transaction',
                      subtitle: 'Aucune transaction ne correspond\nà votre recherche.',
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingL,
                    0,
                    AppTheme.spacingL,
                    100,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => TransactionListItem(
                        transaction: transactions[index],
                        onTap: () => context.push(
                          '/transactions/edit/${transactions[index].id}',
                        ),
                      ),
                      childCount: transactions.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets internes ─────────────────────────────────────

class _SearchBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (value) =>
          ref.read(searchQueryProvider.notifier).state = value,
      decoration: InputDecoration(
        hintText:    'Rechercher une transaction...',
        prefixIcon:  const Icon(
          Icons.search_rounded,
          color: AppColors.textHint,
        ),
        suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
            ? IconButton(
                icon:     const Icon(Icons.clear_rounded),
                onPressed: () =>
                    ref.read(searchQueryProvider.notifier).state = '',
              )
            : null,
      ),
    );
  }
}

class _TypeFilterRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(transactionTypeFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
      ),
      child: Row(
        children: [
          _FilterChip(
            label:    'Tous',
            selected: activeFilter == null,
            color:    AppColors.primary,
            onTap:    () => ref
                .read(transactionTypeFilterProvider.notifier)
                .state = null,
          ),
          const SizedBox(width: AppTheme.spacingS),
          _FilterChip(
            label:    'Revenus',
            selected: activeFilter == TransactionType.income,
            color:    AppColors.income,
            icon:     Icons.arrow_upward_rounded,
            onTap:    () => ref
                .read(transactionTypeFilterProvider.notifier)
                .state = TransactionType.income,
          ),
          const SizedBox(width: AppTheme.spacingS),
          _FilterChip(
            label:    'Dépenses',
            selected: activeFilter == TransactionType.expense,
            color:    AppColors.expense,
            icon:     Icons.arrow_downward_rounded,
            onTap:    () => ref
                .read(transactionTypeFilterProvider.notifier)
                .state = TransactionType.expense,
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync  = ref.watch(categoriesProvider);
    final activeCategory   = ref.watch(categoryFilterProvider);
    final activeTypeFilter = ref.watch(transactionTypeFilterProvider);

    return categoriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error:   (_, __) => const SizedBox.shrink(),
      data: (categories) {
        // Filtre les catégories selon le type sélectionné
        final filtered = activeTypeFilter == null
            ? categories
            : activeTypeFilter == TransactionType.income
                ? categories.where((c) => _isIncome(c.name)).toList()
                : categories.where((c) => !_isIncome(c.name)).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingL,
          ),
          child: Row(
            children: filtered.map((category) {
              final isSelected = category.id == activeCategory;
              return Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingS),
                child: _FilterChip(
                  label:    category.name,
                  selected: isSelected,
                  color:    category.color,
                  icon:     category.icon,
                  onTap: () {
                    ref.read(categoryFilterProvider.notifier).state =
                        isSelected ? null : category.id;
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  bool _isIncome(String name) =>
      ['Salaire', 'Freelance', 'Autres revenus'].contains(name);
}

class _QuickSummary extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredTransactionsProvider);

    return filteredAsync.when(
      loading: () => const SizedBox.shrink(),
      error:   (_, __) => const SizedBox.shrink(),
      data: (transactions) {
        final totalIncome = transactions
            .where((t) => t.isIncome)
            .fold<double>(0, (sum, t) => sum + t.amount);
        final totalExpense = transactions
            .where((t) => t.isExpense)
            .fold<double>(0, (sum, t) => sum + t.amount);
        final count = transactions.length;

        return Container(
          padding:    const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color:        Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Ligne 1 : nombre de transactions ────────
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                    size:  16,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    '$count transaction${count > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:      AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingS),
              const Divider(height: 1),
              const SizedBox(height: AppTheme.spacingS),

              // ── Ligne 2 : revenus et dépenses ───────────
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward_rounded,
                          color: AppColors.income,
                          size:  16,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Expanded(
                          child: Text(
                            '+${NumberFormat('#,###', 'fr_FR').format(totalIncome)} Ar',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color:      AppColors.income,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColors.expense,
                          size:  16,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Expanded(
                          child: Text(
                            '-${NumberFormat('#,###', 'fr_FR').format(totalExpense)} Ar',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color:      AppColors.expense,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

// class _SummaryItem extends StatelessWidget {
//   const _SummaryItem({
//     required this.label,
//     required this.icon,
//     required this.color,
//   });

//   final String   label;
//   final IconData icon;
//   final Color    color;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 16),
//         const SizedBox(width: AppTheme.spacingXS),
//         Text(
//           label,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             color:      color,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _Divider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width:  1,
//       height: 24,
//       color:  AppColors.divider,
//     );
//   }
// }

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
    this.icon,
  });

  final String     label;
  final bool       selected;
  final Color      color;
  final VoidCallback onTap;
  final IconData?  icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:   const Duration(milliseconds: 200),
        padding:    const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical:   AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color:        selected
              ? color.withValues(alpha: 0.15)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: selected ? color : AppColors.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size:  14,
                color: selected ? color : AppColors.textSecondary,
              ),
              const SizedBox(width: AppTheme.spacingXS),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:      selected ? color : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
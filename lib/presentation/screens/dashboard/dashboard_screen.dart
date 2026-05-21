import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:intl/date_symbol_data_local.dart';
import '../../../core/theme/theme.dart';
// import '../../../domain/entities/entities.dart';
import '../../navigation/app_router.dart';
import '../../providers/providers.dart';
import '../../widgets/common/balance_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/month_selector.dart';
import '../../widgets/common/transaction_list_item.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync      = ref.watch(monthlySummaryProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // Bouton d'ajout rapide
      floatingActionButton: FloatingActionButton.extended(
        onPressed:    () => context.push(AppRoutes.addTransaction),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon:          const Icon(Icons.add_rounded),
        label:         const Text('Ajouter'),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(transactionsProvider);
            ref.invalidate(monthlySummaryProvider);
          },
          child: CustomScrollView(
            slivers: [
              // ── En-tête ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingL,
                    AppTheme.spacingL,
                    AppTheme.spacingL,
                    AppTheme.spacingM,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BudgetWise',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            'Gérez votre budget',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      // Avatar placeholder
                      CircleAvatar(
                        radius:          22,
                        backgroundColor: AppColors.primary
                            .withValues(alpha: 0.15),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Sélecteur de mois ─────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                  ),
                  child: const MonthSelector(),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingM),
              ),

              // ── Carte de solde ────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                  ),
                  child: summaryAsync.when(
                    loading: () => const _LoadingCard(),
                    error:   (e, _) => _ErrorCard(message: e.toString()),
                    data:    (summary) => BalanceCard(summary: summary),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingL),
              ),

              // ── Titre transactions récentes ───────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions récentes',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.transactions),
                        child: const Text('Voir tout'),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingS),
              ),

              // ── Liste des transactions ────────────────────
              transactionsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: _ErrorCard(message: e.toString()),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: EmptyState(
                        icon:     Icons.receipt_long_rounded,
                        title:    'Aucune transaction',
                        subtitle: 'Appuyez sur + pour ajouter\nvotre première transaction.',
                      ),
                    );
                  }

                  // Affiche les 5 plus récentes sur le dashboard
                  final recent = transactions.take(5).toList();

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacingL,
                      0,
                      AppTheme.spacingL,
                      100, // espace pour le FAB
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TransactionListItem(
                          transaction: recent[index],
                          onTap: () => context.push(
                            '/transactions/edit/${recent[index].id}',
                          ),
                        ),
                        childCount: recent.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets utilitaires internes ─────────────────────────

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height:      180,
      decoration:  BoxDecoration(
        color:        AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:     const EdgeInsets.all(AppTheme.spacingM),
      decoration:  BoxDecoration(
        color:        AppColors.expense.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Text(
        'Erreur : $message',
        style: TextStyle(color: AppColors.expense),
      ),
    );
  }
}
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../providers/providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── En-tête ──────────────────────────────
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
                      'Statistiques',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Analyse de vos finances',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // ── KPI ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: _KpiRow(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingL),
            ),

            // ── Graphique barres ──────────────────────
            SliverToBoxAdapter(
              child: _ChartCard(
                title:    'Revenus vs Dépenses',
                subtitle: '6 derniers mois',
                child:    _BarChart(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Graphique linéaire ────────────────────
            SliverToBoxAdapter(
              child: _ChartCard(
                title:    'Évolution du solde',
                subtitle: '6 derniers mois',
                child:    _LineChart(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingM),
            ),

            // ── Camembert ────────────────────────────
            SliverToBoxAdapter(
              child: _ChartCard(
                title:    'Dépenses par catégorie',
                subtitle: 'Mois en cours',
                child:    _PieChart(),
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

// ── KPI Row ───────────────────────────────────────────────

class _KpiRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider);

    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:   (e, _) => const SizedBox.shrink(),
      data: (summary) {
        final formatter = NumberFormat('#,###', 'fr_FR');
        return Row(
          children: [
            _KpiCard(
              label:  'Solde',
              value:  '${formatter.format(summary.balance)} Ar',
              icon:   Icons.account_balance_wallet_rounded,
              color:  summary.isPositive
                  ? AppColors.income
                  : AppColors.expense,
            ),
            const SizedBox(width: AppTheme.spacingS),
            _KpiCard(
              label:  'Épargne',
              value:  '${summary.savingsRate.toStringAsFixed(1)}%',
              icon:   Icons.savings_rounded,
              color:  AppColors.savings,
            ),
          ],
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String   label;
  final String   value;
  final IconData icon;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:    const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color:        color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding:    const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color:        color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color:      color,
                    ),
                    maxLines:  1,
                    overflow:  TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Conteneur carte graphique ─────────────────────────────

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
      ),
      child: Container(
        padding:    const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          color:        Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacingL),
            child,
          ],
        ),
      ),
    );
  }
}

// ── Graphique en barres ───────────────────────────────────

class _BarChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(monthlyStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child:  Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (stats) {
        if (stats.every((s) => s.income == 0 && s.expense == 0)) {
          return const _EmptyChart();
        }

        final maxY = stats.fold<double>(
          0,
          (max, s) => s.income > max
              ? s.income
              : s.expense > max
                  ? s.expense
                  : max,
        ) * 1.2;

        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY:             maxY,
              barTouchData:     BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) =>
                      Theme.of(context).cardTheme.color ?? Colors.white,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final label = rodIndex == 0 ? 'Revenus' : 'Dépenses';
                    return BarTooltipItem(
                      '$label\n${NumberFormat('#,###').format(rod.toY)} Ar',
                      TextStyle(
                        color:      rodIndex == 0
                            ? AppColors.income
                            : AppColors.expense,
                        fontWeight: FontWeight.w600,
                        fontSize:   12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show:          true,
                bottomTitles:  AxisTitles(
                  sideTitles: SideTitles(
                    showTitles:  true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= stats.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM', 'fr_FR')
                              .format(stats[index].date),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles:   const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles:  const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles:    const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData:   FlBorderData(show: false),
              gridData:     FlGridData(
                show:              true,
                drawVerticalLine:  false,
                getDrawingHorizontalLine: (_) => const FlLine(
                  color:       AppColors.divider,
                  strokeWidth: 1,
                ),
              ),
              barGroups: stats.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x:        entry.key,
                  barRods:  [
                    BarChartRodData(
                      toY:   entry.value.income,
                      color: AppColors.income,
                      width: 10,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    BarChartRodData(
                      toY:   entry.value.expense,
                      color: AppColors.expense,
                      width: 10,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ── Graphique linéaire ────────────────────────────────────

class _LineChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(monthlyStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child:  Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (stats) {
        if (stats.every((s) => s.balance == 0)) {
          return const _EmptyChart();
        }

        final spots = stats.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            entry.value.balance,
          );
        }).toList();

        final maxY = stats
                .map((s) => s.balance.abs())
                .reduce((a, b) => a > b ? a : b) *
            1.3;

        return SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY:         -maxY,
              maxY:          maxY,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) =>
                      Theme.of(context).cardTheme.color ?? Colors.white,
                  getTooltipItems: (spots) => spots.map((spot) {
                    final balance = spot.y;
                    return LineTooltipItem(
                      '${NumberFormat('#,###').format(balance)} Ar',
                      TextStyle(
                        color:      balance >= 0
                            ? AppColors.income
                            : AppColors.expense,
                        fontWeight: FontWeight.w600,
                        fontSize:   12,
                      ),
                    );
                  }).toList(),
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles:  true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= stats.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM', 'fr_FR')
                              .format(stats[index].date),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles:  const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles:   const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData:   FlGridData(
                show:             true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => const FlLine(
                  color:       AppColors.divider,
                  strokeWidth: 1,
                ),
              ),
              // Ligne zéro
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y:           0,
                    color:       AppColors.textHint,
                    strokeWidth: 1,
                    dashArray:   [4, 4],
                  ),
                ],
              ),
              lineBarsData: [
                LineChartBarData(
                  spots:          spots,
                  isCurved:       true,
                  curveSmoothness: 0.35,
                  color:          AppColors.primary,
                  barWidth:       3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) =>
                        FlDotCirclePainter(
                      radius: 4,
                      color:  spot.y >= 0
                          ? AppColors.income
                          : AppColors.expense,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show:  true,
                    color: AppColors.primary.withValues(alpha: 0.08),
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

// ── Graphique camembert ───────────────────────────────────

class _PieChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(expensesByCategoryProvider);

    return dataAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child:  Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (data) {
        if (data.isEmpty) return const _EmptyChart();

        return Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace:    3,
                  centerSpaceRadius: 50,
                  sections: data.map((item) {
                    return PieChartSectionData(
                      value:      item.amount,
                      color:      item.category.color,
                      radius:     55,
                      showTitle:  item.percentage >= 10,
                      title:      '${item.percentage.toStringAsFixed(0)}%',
                      titleStyle: const TextStyle(
                        fontSize:   12,
                        fontWeight: FontWeight.w700,
                        color:      Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Légende
            Wrap(
              spacing:    AppTheme.spacingM,
              runSpacing: AppTheme.spacingS,
              children:   data.take(6).map((item) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width:        12,
                      height:       12,
                      decoration:   BoxDecoration(
                        color:        item.category.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.category.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

// ── État vide ─────────────────────────────────────────────

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            size:  48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Pas encore de données',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'Ajoutez des transactions pour voir vos graphiques',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
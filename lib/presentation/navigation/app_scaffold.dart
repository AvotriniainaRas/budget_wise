import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import 'app_router.dart';

/// Scaffold principal avec barre de navigation du bas.
///
/// Enveloppe tous les écrans principaux via [ShellRoute].
/// L'écran actif est déterminé par la route courante.
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(currentLocation: location),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentLocation});

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return NavigationBar(
      elevation:     0,
      backgroundColor: colors.surface,
      indicatorColor:  AppColors.primary.withValues(alpha: 0.12),
      selectedIndex:   _selectedIndex(currentLocation),
      onDestinationSelected: (index) => _onTap(context, index),
      // Labels toujours visibles et centrés
      labelBehavior:   NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon:         Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label:        'Accueil',       // Dashboard → Accueil (plus court)
        ),
        NavigationDestination(
          icon:         Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long_rounded),
          label:        'Transactions',
        ),
        NavigationDestination(
          icon:         Icon(Icons.savings_outlined),
          selectedIcon: Icon(Icons.savings_rounded),
          label:        'Épargne',       // ← position 2 (avant Stats)
        ),
        NavigationDestination(
          icon:         Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart_rounded),
          label:        'Stats',         // Statistiques → Stats (plus court)
        ),
        NavigationDestination(
          icon:         Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded),
          label:        'Paramètres',
        ),
      ],
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.transactions)) return 1;
    if (location.startsWith(AppRoutes.savings))      return 2; // ← 2
    if (location.startsWith(AppRoutes.statistics))   return 3; // ← 3
    if (location.startsWith(AppRoutes.settings))     return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.dashboard);    break;
      case 1: context.go(AppRoutes.transactions); break;
      case 2: context.go(AppRoutes.savings);      break; // ← 2
      case 3: context.go(AppRoutes.statistics);   break; // ← 3
      case 4: context.go(AppRoutes.settings);     break;
    }
  }
}
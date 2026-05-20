import 'package:go_router/go_router.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/transactions/transactions_screen.dart';
import '../screens/transactions/add_transaction_screen.dart';
import '../screens/savings/savings_screen.dart';
import '../screens/savings/add_savings_goal_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'app_scaffold.dart';

/// Identifiants de routes — jamais de strings en dur dans les widgets.
abstract final class AppRoutes {
  static const String dashboard       = '/';
  static const String transactions    = '/transactions';
  static const String addTransaction  = '/transactions/add';
  static const String editTransaction = '/transactions/edit/:id';
  static const String savings         = '/savings';
  static const String addSavingsGoal  = '/savings/add';
  static const String settings        = '/settings';
}

/// Configuration centrale de la navigation.
final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  debugLogDiagnostics: false,
  routes: [
    // Shell route — enveloppe tous les écrans principaux
    // dans le scaffold avec la barre de navigation du bas.
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.savings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SavingsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),

    // Routes modales — hors du shell (pas de bottom nav)
    GoRoute(
      path: AppRoutes.addTransaction,
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: AppRoutes.editTransaction,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddTransactionScreen(transactionId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.addSavingsGoal,
      builder: (context, state) => const AddSavingsGoalScreen(),
    ),
  ],
);
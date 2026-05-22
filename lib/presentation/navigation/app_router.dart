import 'package:go_router/go_router.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/transactions/transactions_screen.dart';
import '../screens/transactions/add_transaction_screen.dart';
import '../screens/savings/savings_screen.dart';
import '../screens/savings/add_savings_goal_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import 'app_scaffold.dart';
import '../screens/splash/splash_screen.dart';
import '../../core/utils/transitions.dart';

/// Identifiants de routes — jamais de strings en dur dans les widgets.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String dashboard = '/';
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/edit/:id';
  static const String savings = '/savings';
  static const String addSavingsGoal = '/savings/add';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
}

/// Configuration centrale de la navigation.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // Shell route — enveloppe tous les écrans principaux
    // dans le scaffold avec la barre de navigation du bas.
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          pageBuilder: (context, state) => AppTransitions.fade(
            key: state.pageKey,
            child: const DashboardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          pageBuilder: (context, state) => AppTransitions.fade(
            key: state.pageKey,
            child: const TransactionsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.statistics,
          pageBuilder: (context, state) => AppTransitions.fade(
            key: state.pageKey,
            child: const StatisticsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.savings,
          pageBuilder: (context, state) => AppTransitions.fade(
            key: state.pageKey,
            child: const SavingsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => AppTransitions.fade(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
        ),
      ],
    ),

    // Routes modales — hors du shell (pas de bottom nav)
    GoRoute(
      path: AppRoutes.addTransaction,
      pageBuilder: (context, state) => AppTransitions.slideUp(
        key: state.pageKey,
        child: const AddTransactionScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editTransaction,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return AppTransitions.slideUp(
          key: state.pageKey,
          child: AddTransactionScreen(transactionId: id),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addSavingsGoal,
      pageBuilder: (context, state) => AppTransitions.slideUp(
        key: state.pageKey,
        child: const AddSavingsGoalScreen(),
      ),
    ),
  ],
);
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/providers/providers.dart';

class BudgetWiseApp extends ConsumerWidget {
  const BudgetWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title:                      'BudgetWise',
      debugShowCheckedModeBanner: false,
      theme:                      AppTheme.light,
      darkTheme:                  AppTheme.dark,
      themeMode:                  themeMode,
      routerConfig:               appRouter,
    );
  }
}
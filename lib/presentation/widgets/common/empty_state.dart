import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Widget affiché quand une liste est vide.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String   title;
  final String   subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:       80,
              height:      80,
              decoration:  BoxDecoration(
                color:        AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
              ),
              child: Icon(
                icon,
                size:  40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
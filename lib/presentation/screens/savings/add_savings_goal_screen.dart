import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../../core/utils/date_picker_helper.dart';

class AddSavingsGoalScreen extends ConsumerStatefulWidget {
  const AddSavingsGoalScreen({super.key});

  @override
  ConsumerState<AddSavingsGoalScreen> createState() =>
      _AddSavingsGoalScreenState();
}

class _AddSavingsGoalScreenState extends ConsumerState<AddSavingsGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _currentCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  DateTime _deadline = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _currentCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showAppDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && mounted) {
      setState(() => _deadline = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final goal = SavingsGoal(
        id: const Uuid().v4(),
        title: _titleCtrl.text.trim(),
        targetAmount: double.parse(
          _amountCtrl.text.replaceAll(',', '.'),
        ),
        currentAmount: _currentCtrl.text.isEmpty
            ? 0
            : double.parse(_currentCtrl.text.replaceAll(',', '.')),
        deadline: _deadline,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      );

      await ref.read(addSavingsGoalProvider).call(goal);

      ref.invalidate(savingsGoalsProvider);
      ref.invalidate(activeSavingsGoalsProvider);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Nouvel objectif'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          children: [
            // ── Titre ────────────────────────────────
            const _Label('Nom de l\'objectif'),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _titleCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ex : Vacances, Téléphone...',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Montant cible ────────────────────────
            const _Label('Montant cible (Ar)'),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              style: AppTextStyles.amount.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
              decoration: const InputDecoration(
                hintText: '0',
                prefixText: 'Ar  ',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Montant requis';
                final amount = double.tryParse(v.replaceAll(',', '.'));
                if (amount == null || amount <= 0) {
                  return 'Montant invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Montant déjà épargné ─────────────────
            const _Label('Déjà épargné (optionnel)'),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _currentCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              decoration: const InputDecoration(
                hintText: '0',
                prefixText: 'Ar  ',
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Date limite ──────────────────────────
            const _Label('Date limite'),
            const SizedBox(height: AppTheme.spacingS),
            GestureDetector(
              onTap: _pickDeadline,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Text(
                      '${_deadline.day.toString().padLeft(2, '0')} / '
                      '${_deadline.month.toString().padLeft(2, '0')} / '
                      '${_deadline.year}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Text(
                      '${_deadline.difference(DateTime.now()).inDays} jours',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Note ─────────────────────────────────
            const _Label('Note (optionnel)'),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Pourquoi cet objectif ?',
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // ── Bouton ────────────────────────────────
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Créer l\'objectif'),
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
    );
  }
}
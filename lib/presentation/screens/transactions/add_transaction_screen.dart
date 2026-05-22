import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../../core/utils/date_picker_helper.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, this.transactionId});

  final String? transactionId;

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String? _categoryId;
  DateTime _date = DateTime.now();
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.transactionId != null;
    if (_isEditMode) _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    final repo = ref.read(transactionRepositoryProvider);
    final transaction = await repo.getById(widget.transactionId!);
    if (transaction == null) return;

    setState(() {
      _titleCtrl.text = transaction.title;
      _amountCtrl.text = transaction.amount.toStringAsFixed(0);
      _noteCtrl.text = transaction.note ?? '';
      _type = transaction.type;
      _categoryId = transaction.categoryId;
      _date = transaction.date;
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      _showError('Veuillez sélectionner une catégorie.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final transaction = Transaction(
        id: widget.transactionId ?? const Uuid().v4(),
        title: _titleCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.replaceAll(',', '.')),
        type: _type,
        categoryId: _categoryId!,
        date: _date,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      );

      if (_isEditMode) {
        await ref.read(updateTransactionProvider).call(transaction);
      } else {
        await ref.read(addTransactionProvider).call(transaction);
      }

      // Invalide les providers pour forcer le rechargement.
      ref.invalidate(transactionsProvider);
      ref.invalidate(monthlySummaryProvider);

      if (mounted) context.pop();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la transaction ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.expense,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ref.read(deleteTransactionProvider).call(widget.transactionId!);
    ref.invalidate(transactionsProvider);
    ref.invalidate(monthlySummaryProvider);

    if (mounted) context.pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.expense,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showAppDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Modifier' : 'Nouvelle transaction'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.expense,
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          children: [
            // ── Type : Revenu / Dépense ───────────────────
            _TypeSelector(
              selected: _type,
              onChanged: (type) => setState(() {
                _type = type;
                _categoryId = null;
              }),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Montant ───────────────────────────────────
            const _SectionLabel(label: 'Montant (Ar)'),
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
                fontSize: 28,
              ),
              decoration: const InputDecoration(
                hintText: '0',
                prefixText: 'Ar  ',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Montant requis';
                final amount = double.tryParse(
                  v.replaceAll(',', '.'),
                );
                if (amount == null || amount <= 0) {
                  return 'Montant invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Titre ─────────────────────────────────────
            const _SectionLabel(label: 'Description'),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _titleCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ex : Courses, Salaire...',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Description requise'
                  : null,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Catégorie ─────────────────────────────────
            const _SectionLabel(label: 'Catégorie'),
            const SizedBox(height: AppTheme.spacingS),
            _CategorySelector(
              selectedId: _categoryId,
              type: _type,
              onSelected: (id) => setState(() => _categoryId = id),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // ── Date ──────────────────────────────────────
            const _SectionLabel(label: 'Date'),
            const SizedBox(height: AppTheme.spacingS),
            _DateSelector(date: _date, onTap: _pickDate),
            const SizedBox(height: AppTheme.spacingL),

            // ── Note (optionnel) ──────────────────────────
            const _SectionLabel(label: 'Note (optionnel)'),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ajouter une note...',
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // ── Bouton valider ────────────────────────────
            ElevatedButton(
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
                  : Text(
                      _isEditMode ? 'Modifier' : 'Enregistrer',
                    ),
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }
}

// ── Widgets internes ─────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.onChanged,
  });

  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _TypeTab(
            label: 'Dépense',
            icon: Icons.arrow_downward_rounded,
            color: AppColors.expense,
            selected: selected == TransactionType.expense,
            onTap: () => onChanged(TransactionType.expense),
          ),
          _TypeTab(
            label: 'Revenu',
            icon: Icons.arrow_upward_rounded,
            color: AppColors.income,
            selected: selected == TransactionType.income,
            onTap: () => onChanged(TransactionType.income),
          ),
        ],
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingM,
          ),
          decoration: BoxDecoration(
            color:
                selected ? color.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? color : AppColors.textHint, size: 18),
              const SizedBox(width: AppTheme.spacingXS),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected ? color : AppColors.textHint,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySelector extends ConsumerWidget {
  const _CategorySelector({
    required this.selectedId,
    required this.type,
    required this.onSelected,
  });

  final String? selectedId;
  final TransactionType type;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = type == TransactionType.income
        ? ref.watch(incomeCategoriesProvider)
        : ref.watch(expenseCategoriesProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Erreur : $e'),
      data: (categories) => Wrap(
        spacing: AppTheme.spacingS,
        runSpacing: AppTheme.spacingS,
        children: categories.map((category) {
          final isSelected = category.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? category.color.withValues(alpha: 0.15)
                    : Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: isSelected ? category.color : AppColors.divider,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    color:
                        isSelected ? category.color : AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? category.color
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.date,
    required this.onTap,
  });

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              Icons.calendar_today_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacingM),
            Text(
              '${date.day.toString().padLeft(2, '0')} / '
              '${date.month.toString().padLeft(2, '0')} / '
              '${date.year}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

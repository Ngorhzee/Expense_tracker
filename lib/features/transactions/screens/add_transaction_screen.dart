import 'package:expense_traker/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.accent,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a category'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate network delay for UX
    await Future.delayed(const Duration(milliseconds: 500));

    final transaction = Transaction(
      id: const Uuid().v4(),
      amount: -double.parse(_amountController.text),
      merchant: _merchantController.text.trim(),
      category: _selectedCategory!,
      date: _selectedDate,
      status: TransactionStatus.completed,
      note:
          _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
    );

    ref.read(transactionProvider.notifier).addTransaction(transaction);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaction added successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.keyboard_arrow_left_outlined,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Add Transaction',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  SizedBox(width: 48.w),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── Form ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: _amountController,
                        label: "Amount",
                        hint: '0.00',
                        prefixText: '\$',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid amount greater than 0';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24.h),

                      AppTextField(
                        controller: _merchantController,
                        textCapitalization: TextCapitalization.words,
                        label: "Merchant Name",
                        hint: 'e.g. Whole Foods',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a merchant name';
                          }
                          if (value.trim().length < 2) {
                            return 'Merchant name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),

                       SizedBox(height: 24.h),

                      // Category picker
                      _FieldLabel('Category'),
                      const SizedBox(height: 8),
                      _CategoryPicker(
                        selectedCategory: _selectedCategory,
                        onSelected:
                            (cat) => setState(() => _selectedCategory = cat),
                      ),

                       SizedBox(height: 24.h),

                      // Date picker
                      _FieldLabel('Date'),
                       SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                               Icon(
                                Icons.calendar_month_outlined,
                                size: 20.sp,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat(
                                  'EEEE, MMM d, yyyy',
                                ).format(_selectedDate),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_downward,
                                size: 18,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Note field (optional)
                      _FieldLabel('Note (optional)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Add a note about this transaction...',
                          alignLabelWithHint: true,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          child:
                              _isSubmitting
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  :  Text(
                                    'Add Transaction',
                                    style:Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  final TransactionCategory? selectedCategory;
  final ValueChanged<TransactionCategory> onSelected;

  const _CategoryPicker({
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          TransactionCategory.values.map((category) {
            final isSelected = selectedCategory == category;
            final color = getCategoryColor(category);

            return GestureDetector(
              onTap: () => onSelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? color.withValues(alpha:  0.15)
                          : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      getCategoryIcon(category),
                      size: 16,
                      color: isSelected ? color : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}

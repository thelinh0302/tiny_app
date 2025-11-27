import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/widgets/categories_grid.dart'
    show kCategories;

/// Add Expense screen with:
/// - date field
/// - category dropdown
/// - amount (money)
/// - name
/// - description
/// - image URL (upload handled by backend)
///
/// On Save, the page pops with a Map payload. Caller/Bloc can send to backend.
class AddExpensePage extends StatefulWidget {
  final CategoryData? initialCategory;

  const AddExpensePage({super.key, this.initialCategory});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _imageUrlCtrl = TextEditingController();

  DateTime? _selectedDate;
  CategoryData? _selectedCategory;

  String? _amountError;
  String? _nameError;
  String? _categoryError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _imageUrlCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _amountCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime initial = _selectedDate ?? DateTime.now();
    final DateTime first = DateTime(2000);
    final DateTime last = DateTime(2100);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = picked.toIso8601String().split('T').first;
        _dateError = null;
      });
    }
  }

  void _save() {
    setState(() {
      _amountError = null;
      _nameError = null;
      _categoryError = null;
      _dateError = null;
    });

    if (_selectedDate == null) {
      _dateError = 'Please select a date';
    }
    if (_selectedCategory == null) {
      _categoryError = 'Please select a category';
    }
    if (_nameCtrl.text.trim().isEmpty) {
      _nameError = 'Please enter a name';
    }
    final String amountText = _amountCtrl.text.trim();
    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _amountError = 'Please enter a valid amount';
    }

    if (_dateError != null ||
        _categoryError != null ||
        _nameError != null ||
        _amountError != null) {
      setState(() {});
      return;
    }

    final payload = <String, dynamic>{
      'date': _selectedDate!.toIso8601String(),
      'category': _selectedCategory!.title,
      'categoryIcon': _selectedCategory!.iconAsset,
      'amount': amount,
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      // Backend will handle upload. We pass the URL if provided.
      'imageUrl': _imageUrlCtrl.text.trim(),
    };

    Navigator.of(context).pop(payload);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: const MainAppBar(titleKey: 'Add Expense'),
      enableContentScroll: true,
      topHeightRatio: 0.2,
      topChild: null,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.horizontalMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.verticalSpaceMedium,

            // Date field
            CustomTextField(
              controller: _dateCtrl,
              labelText: 'Date',
              hintText: 'YYYY-MM-DD',
              readOnly: true,
              onTap: _pickDate,
              errorText: _dateError,
            ),
            AppSpacing.verticalSpaceMedium,

            // Category dropdown
            Text(
              'Category',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CategoryData>(
              value: _selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusLarge,
                  borderSide: const BorderSide(
                    color: AppColors.borderButtonPrimary,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusLarge,
                  borderSide: const BorderSide(
                    color: AppColors.borderButtonPrimary,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusLarge,
                  borderSide: const BorderSide(
                    color: AppColors.errorColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusLarge,
                  borderSide: const BorderSide(
                    color: AppColors.errorColor,
                    width: 2,
                  ),
                ),
                errorText: _categoryError,
              ),
              items:
                  kCategories
                      .map(
                        (c) => DropdownMenuItem<CategoryData>(
                          value: c,
                          child: Text(c.title),
                        ),
                      )
                      .toList(),
              onChanged:
                  (val) => setState(() {
                    _selectedCategory = val;
                    _categoryError = null;
                  }),
            ),
            AppSpacing.verticalSpaceMedium,

            // Amount
            CustomTextField(
              controller: _amountCtrl,
              labelText: 'Amount',
              hintText: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              errorText: _amountError,
            ),
            AppSpacing.verticalSpaceMedium,

            // Name
            CustomTextField(
              controller: _nameCtrl,
              labelText: 'Name',
              hintText: 'e.g., Lunch',
              errorText: _nameError,
            ),
            AppSpacing.verticalSpaceMedium,

            // Description
            CustomTextField(
              controller: _descCtrl,
              labelText: 'Description',
              hintText: 'Optional details',
              maxLines: 3,
            ),
            AppSpacing.verticalSpaceMedium,

            // Image URL (backend will upload)
            CustomTextField(
              controller: _imageUrlCtrl,
              labelText: 'Image URL',
              hintText: 'https://...',
            ),
            const SizedBox(height: 8),
            if (_imageUrlCtrl.text.trim().isNotEmpty)
              ClipRRect(
                borderRadius: AppSpacing.borderRadiusLarge,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    _imageUrlCtrl.text.trim(),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: AppColors.borderButtonPrimary.withValues(
                            alpha: 0.2,
                          ),
                          child: const Center(child: Text('Invalid image URL')),
                        ),
                  ),
                ),
              ),

            AppSpacing.verticalSpaceLarge,
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: PrimaryButton(text: 'Save', onPressed: _save),
              ),
            ),
            AppSpacing.verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/image_picker_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_dropdown_field.dart';

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
  XFile? _imageFile;
  Uint8List? _imageBytes;

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
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _amountCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
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
      // Image selected locally; caller should handle upload.
      'imagePath': _imageFile?.path,
      'imageBytes': _imageBytes,
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
            CategoryDropdownField(
              value: _selectedCategory,
              errorText: _categoryError,
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

            // Receipt Image (selected from device)
            ImagePickerField(
              labelText: 'Receipt Image',
              onChanged: (file, bytes) {
                setState(() {
                  _imageFile = file;
                  _imageBytes = bytes;
                });
              },
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

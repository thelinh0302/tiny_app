import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/image_picker_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/custom_dropdown_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_list_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

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
  final String? initialCategory;

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
  String? _selectedCategory;

  String? _amountError;
  String? _nameError;
  String? _categoryError;
  String? _dateError;

  void _onAmountChanged(String value) {
    final localeCode = context.locale.languageCode.toLowerCase();
    final isVi = localeCode.startsWith('vi');
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      _amountCtrl.value = const TextEditingValue(text: '');
      setState(() {});
      return;
    }
    if (isVi) {
      final int amount = int.parse(digitsOnly);
      final formatter = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '₫',
        decimalDigits: 0,
      );
      final formatted = formatter.format(amount);
      _amountCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      final int cents = int.parse(digitsOnly);
      final double amount = cents / 100;
      final formatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: r'$',
        decimalDigits: 2,
      );
      final formatted = formatter.format(amount);
      _amountCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    setState(() {
      _amountError = null;
    });
  }

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
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now;
    final DateTime first = DateTime(2000);
    final DateTime last = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: last,
    );

    if (pickedDate == null) return;

    final TimeOfDay initialTime =
        _selectedDate != null
            ? TimeOfDay.fromDateTime(_selectedDate!)
            : TimeOfDay.fromDateTime(now);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime == null) return;

    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDate = combined;
      final DateFormat formatter = DateFormat('MM-dd-yyyy HH:mm');
      _dateCtrl.text = formatter.format(combined);
      _dateError = null;
    });
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
    final String rawAmount = _amountCtrl.text.trim();
    final String localeCode = context.locale.languageCode.toLowerCase();
    final bool isVi = localeCode.startsWith('vi');
    final String digitsOnly = rawAmount.replaceAll(RegExp(r'[^0-9]'), '');
    double? amount;
    if (digitsOnly.isEmpty) {
      amount = null;
    } else if (isVi) {
      // VND formatted without decimals -> digitsOnly already in units
      amount = double.tryParse(digitsOnly);
    } else {
      // USD formatted as dollars with 2 decimals -> digitsOnly are cents
      final double? cents = double.tryParse(digitsOnly);
      amount = cents != null ? cents / 100.0 : null;
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryListBloc>(
      create:
          (_) =>
              Modular.get<CategoryListBloc>()
                ..add(const CategoryListRequested(page: 1, pageSize: 20)),
      child: MainLayout(
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
                labelText: 'Date & Time',
                hintText: 'MM-DD-YYYY HH:mm',
                readOnly: true,
                onTap: _pickDate,
                errorText: _dateError,
              ),
              AppSpacing.verticalSpaceMedium,

              // Category dropdown (driven by CategoryListBloc)
              BlocBuilder<CategoryListBloc, CategoryListState>(
                builder: (context, state) {
                  final List<DropdownMenuItem<String>> items =
                      <DropdownMenuItem<String>>[];
                  if (state is CategoryListLoadSuccess) {
                    final Set<String> seen = <String>{};
                    for (final e in state.items) {
                      final String id = e.id;
                      if (seen.add(id)) {
                        items.add(
                          DropdownMenuItem<String>(
                            value: id,
                            child: Text(e.name),
                          ),
                        );
                      }
                    }
                  }

                  final bool hasSelected =
                      items.where((m) => m.value == _selectedCategory).length ==
                      1;
                  final String? selectedId =
                      hasSelected ? _selectedCategory : null;

                  return CustomDropdownField<String>(
                    labelText: 'Category',
                    value: selectedId,
                    items: items,
                    errorText: _categoryError,
                    placeholderText: 'Select category',
                    enabled: state is! CategoryListLoadInProgress,
                    onChanged:
                        (String? val) => setState(() {
                          _selectedCategory = val;
                          _categoryError = null;
                        }),
                  );
                },
              ),
              AppSpacing.verticalSpaceMedium,

              // Amount
              CustomTextField(
                controller: _amountCtrl,
                labelText: 'Amount',
                hintText:
                    context.locale.languageCode.toLowerCase().startsWith('vi')
                        ? '0 ₫'
                        : '\$0.00',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: _onAmountChanged,
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
      ),
    );
  }
}

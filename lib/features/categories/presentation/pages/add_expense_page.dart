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
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';
import 'package:finly_app/core/widgets/app_alert.dart';

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
  Uint8List? _imageBytes;

  DateTime? _selectedDate;
  String? _selectedCategory;

  String? _amountError;
  String? _nameError;
  String? _categoryError;
  String? _dateError;

  void _onAmountChanged(BuildContext context, String value) {
    final localeCode = context.locale.languageCode.toLowerCase();
    final isVi = localeCode.startsWith('vi');

    // --------------------- //
    // VIETNAMESE            //
    // --------------------- //
    if (isVi) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) {
        _amountCtrl.value = const TextEditingValue(text: '');
        BlocProvider.of<AddExpenseBloc>(
          context,
        ).add(const AddExpenseAmountChanged(null));
        return;
      }

      final amount = int.tryParse(digits) ?? 0;

      final formatted = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '₫',
        decimalDigits: 0,
      ).format(amount);

      // Always push caret to end
      _amountCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );

      BlocProvider.of<AddExpenseBloc>(
        context,
      ).add(AddExpenseAmountChanged(amount.toDouble()));
      return;
    }

    // --------------------- //
    // EN (US Dollar)        //
    // --------------------- //

    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');

    // CASE A: empty
    if (cleaned.isEmpty) {
      _amountCtrl.value = const TextEditingValue(text: '');
      BlocProvider.of<AddExpenseBloc>(
        context,
      ).add(const AddExpenseAmountChanged(null));
      return;
    }

    // Split number
    final parts = cleaned.split('.');

    // CASE B: user typing dot at the end → "5."
    if (cleaned.endsWith('.')) {
      final display = "${parts[0]}.";
      _amountCtrl.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );

      BlocProvider.of<AddExpenseBloc>(
        context,
      ).add(AddExpenseAmountChanged(double.tryParse(parts[0]) ?? 0));
      return;
    }

    // CASE C: decimals exist but not enough to format → "5.2"
    if (parts.length == 2 && parts[1].length < 2) {
      // Do NOT format yet — keep raw input
      final display = cleaned;
      _amountCtrl.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );

      final asDouble = double.tryParse(display) ?? 0;
      BlocProvider.of<AddExpenseBloc>(
        context,
      ).add(AddExpenseAmountChanged(asDouble));
      return;
    }

    // CASE D: Safe to format: "5.20", "12.34", "50.00"
    String decimals = parts.length == 2 ? parts[1] : "00";
    if (decimals.length > 2) decimals = decimals.substring(0, 2);

    final amount = double.parse("${parts[0]}.$decimals");

    final formatted = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 2,
    ).format(amount);

    final caretPos = formatted.length - 3; // before decimal part

    _amountCtrl.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: caretPos),
    );

    BlocProvider.of<AddExpenseBloc>(
      context,
    ).add(AddExpenseAmountChanged(amount));
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

  Future<void> _pickDate(BuildContext context) async {
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

    final DateFormat formatter = DateFormat('MM-dd-yyyy HH:mm');
    _dateCtrl.text = formatter.format(combined);
    BlocProvider.of<AddExpenseBloc>(
      context,
    ).add(AddExpenseDateChanged(combined));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryListBloc>(
          create:
              (_) =>
                  Modular.get<CategoryListBloc>()
                    ..add(const CategoryListRequested(page: 1, pageSize: 20)),
        ),
        BlocProvider<AddExpenseBloc>(
          create:
              (_) =>
                  Modular.get<AddExpenseBloc>()..add(
                    AddExpenseInitialized(categoryId: widget.initialCategory),
                  ),
        ),
      ],
      child: BlocListener<AddExpenseBloc, AddExpenseState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == AddExpenseStatus.submissionSuccess) {
            // Avoid showing SnackBar here to prevent overlay issues causing black screen on pop
            Navigator.of(context).pop(true);
            return;
          } else if (state.status == AddExpenseStatus.submissionFailure &&
              state.errorMessage != null) {
            AppAlert.error(context, state.errorMessage!);
          }

          // Keep date controller in sync
          if (state.date.value != null) {
            final DateFormat formatter = DateFormat('MM-dd-yyyy HH:mm');
            _dateCtrl.text = formatter.format(state.date.value!);
          }
        },
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
                BlocBuilder<AddExpenseBloc, AddExpenseState>(
                  buildWhen: (p, c) => p.date != c.date,
                  builder: (context, state) {
                    final dateError =
                        context.select((AddExpenseBloc b) => b.state.showErrors)
                            ? (state.date.value == null
                                ? 'Please select a date'
                                : null)
                            : null;
                    return CustomTextField(
                      controller: _dateCtrl,
                      labelText: 'Date & Time',
                      hintText: 'MM-DD-YYYY HH:mm',
                      readOnly: true,
                      onTap: () => _pickDate(context),
                      errorText: dateError,
                    );
                  },
                ),
                AppSpacing.verticalSpaceMedium,

                // Category dropdown (driven by CategoryListBloc)
                BlocBuilder<CategoryListBloc, CategoryListState>(
                  builder: (context, catState) {
                    final List<DropdownMenuItem<String>> items =
                        <DropdownMenuItem<String>>[];
                    if (catState is CategoryListLoadSuccess) {
                      final Set<String> seen = <String>{};
                      for (final e in catState.items) {
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

                    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
                      buildWhen: (p, c) => p.categoryId != c.categoryId,
                      builder: (context, state) {
                        final categoryError =
                            context.select(
                                  (AddExpenseBloc b) => b.state.showErrors,
                                )
                                ? (state.categoryId.value == null
                                    ? 'Please select a category'
                                    : null)
                                : null;
                        return CustomDropdownField<String>(
                          labelText: 'Category',
                          value: state.categoryId.value,
                          items: items,
                          errorText: categoryError,
                          placeholderText: 'Select category',
                          enabled: catState is! CategoryListLoadInProgress,
                          onChanged:
                              (String? val) => BlocProvider.of<AddExpenseBloc>(
                                context,
                              ).add(AddExpenseCategoryChanged(val)),
                        );
                      },
                    );
                  },
                ),
                AppSpacing.verticalSpaceMedium,

                // Amount
                BlocBuilder<AddExpenseBloc, AddExpenseState>(
                  buildWhen: (p, c) => p.amount != c.amount,
                  builder: (context, state) {
                    final amountError =
                        context.select((AddExpenseBloc b) => b.state.showErrors)
                            ? ((state.amount.value == null ||
                                    state.amount.value! <= 0)
                                ? 'Please enter a valid amount'
                                : null)
                            : null;
                    return CustomTextField(
                      controller: _amountCtrl,
                      labelText: 'Amount',
                      hintText:
                          context.locale.languageCode.toLowerCase().startsWith(
                                'vi',
                              )
                              ? '0 ₫'
                              : '\$0.00',
                      // keyboardType: const TextInputType.numberWithOptions(
                      //   decimal: true,
                      // ),
                      onChanged: (val) => _onAmountChanged(context, val),
                      errorText: amountError,
                    );
                  },
                ),
                AppSpacing.verticalSpaceMedium,

                // Name
                BlocBuilder<AddExpenseBloc, AddExpenseState>(
                  buildWhen: (p, c) => p.name != c.name,
                  builder: (context, state) {
                    final nameError =
                        context.select((AddExpenseBloc b) => b.state.showErrors)
                            ? (state.name.value.trim().isEmpty
                                ? 'Please enter a name'
                                : null)
                            : null;
                    return CustomTextField(
                      controller: _nameCtrl,
                      labelText: 'Name',
                      hintText: 'e.g., Lunch',
                      onChanged:
                          (val) => BlocProvider.of<AddExpenseBloc>(
                            context,
                          ).add(AddExpenseNameChanged(val)),
                      errorText: nameError,
                    );
                  },
                ),
                AppSpacing.verticalSpaceMedium,

                // Description
                BlocBuilder<AddExpenseBloc, AddExpenseState>(
                  buildWhen: (p, c) => p.note != c.note,
                  builder: (context, state) {
                    return CustomTextField(
                      controller: _descCtrl,
                      labelText: 'Description',
                      hintText: 'Optional details',
                      maxLines: 3,
                      onChanged:
                          (val) => BlocProvider.of<AddExpenseBloc>(
                            context,
                          ).add(AddExpenseNoteChanged(val)),
                    );
                  },
                ),
                AppSpacing.verticalSpaceMedium,

                // Receipt Image (selected from device)
                ImagePickerField(
                  labelText: 'Receipt Image',
                  onChanged: (file, bytes) {
                    setState(() {
                      _imageBytes = bytes;
                    });
                    // No upload here; attachmentUrl remains null for now
                  },
                ),

                AppSpacing.verticalSpaceLarge,
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: BlocBuilder<AddExpenseBloc, AddExpenseState>(
                      buildWhen: (p, c) => p.status != c.status,
                      builder: (context, state) {
                        final isLoading =
                            state.status ==
                            AddExpenseStatus.submissionInProgress;
                        return PrimaryButton(
                          text: 'Save',
                          isLoading: isLoading,
                          onPressed:
                              () => BlocProvider.of<AddExpenseBloc>(
                                context,
                              ).add(const AddExpenseSubmitted()),
                        );
                      },
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

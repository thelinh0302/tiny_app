import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_date_field.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_category_field.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_amount_field.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_name_field.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_description_field.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_receipt_image_field.dart';
import 'package:finly_app/features/categories/presentation/widgets/fields/add_expense_save_button.dart';

class AddExpenseForm extends StatelessWidget {
  final TextEditingController dateCtrl;
  final TextEditingController amountCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;

  const AddExpenseForm({
    super.key,
    required this.dateCtrl,
    required this.amountCtrl,
    required this.nameCtrl,
    required this.descCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.verticalSpaceMedium,
        AddExpenseDateField(controller: dateCtrl),
        AppSpacing.verticalSpaceMedium,
        const AddExpenseCategoryField(),
        AppSpacing.verticalSpaceMedium,
        AddExpenseAmountField(controller: amountCtrl),
        AppSpacing.verticalSpaceMedium,
        AddExpenseNameField(controller: nameCtrl),
        AppSpacing.verticalSpaceMedium,
        AddExpenseDescriptionField(controller: descCtrl),
        AppSpacing.verticalSpaceMedium,
        const AddExpenseReceiptImageField(),
        AppSpacing.verticalSpaceLarge,
        const AddExpenseSaveButton(),
        AppSpacing.verticalSpaceLarge,
      ],
    );
  }
}

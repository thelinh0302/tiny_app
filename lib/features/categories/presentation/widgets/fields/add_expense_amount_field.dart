import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/utils/amount_input_utils.dart';
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';

class AddExpenseAmountField extends StatelessWidget {
  final TextEditingController controller;

  const AddExpenseAmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.amount != c.amount || p.showErrors != c.showErrors,
      builder: (context, state) {
        final amountError =
            context.select((AddExpenseBloc b) => b.state.showErrors)
                ? ((state.amount.value == null || state.amount.value! <= 0)
                    ? 'Please enter a valid amount'
                    : null)
                : null;

        return CustomTextField(
          controller: controller,
          labelText: 'Amount',
          hintText:
              context.locale.languageCode.toLowerCase().startsWith('vi')
                  ? '0 ₫'
                  : '\$0.00',
          onChanged: (val) {
            final r = formatAmountInput(locale: context.locale, rawInput: val);
            controller.value = r.controllerValue;
            context.read<AddExpenseBloc>().add(
              AddExpenseAmountChanged(r.parsedAmount),
            );
          },
          errorText: amountError,
        );
      },
    );
  }
}

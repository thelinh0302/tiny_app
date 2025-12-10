import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';

class AddExpenseDateField extends StatelessWidget {
  final TextEditingController controller;

  const AddExpenseDateField({super.key, required this.controller});

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final state = context.read<AddExpenseBloc>().state;

    final initialDate = state.date.value ?? now;
    final first = DateTime(2000);
    final last = DateTime(2100);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: last,
    );
    if (pickedDate == null) return;

    final TimeOfDay initialTime =
        state.date.value != null
            ? TimeOfDay.fromDateTime(state.date.value!)
            : TimeOfDay.fromDateTime(now);

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final formatter = DateFormat('MM-dd-yyyy HH:mm');
    controller.text = formatter.format(combined);
    context.read<AddExpenseBloc>().add(AddExpenseDateChanged(combined));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.date != c.date,
      builder: (context, state) {
        final dateError =
            context.select((AddExpenseBloc b) => b.state.showErrors)
                ? (state.date.value == null ? 'Please select a date' : null)
                : null;

        return CustomTextField(
          controller: controller,
          labelText: 'Date & Time',
          hintText: 'MM-DD-YYYY HH:mm',
          readOnly: true,
          onTap: () => _pickDate(context),
          errorText: dateError,
        );
      },
    );
  }
}

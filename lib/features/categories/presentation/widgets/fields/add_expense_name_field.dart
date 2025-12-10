import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';

class AddExpenseNameField extends StatelessWidget {
  final TextEditingController controller;

  const AddExpenseNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.name != c.name || p.showErrors != c.showErrors,
      builder: (context, state) {
        final nameError =
            context.select((AddExpenseBloc b) => b.state.showErrors)
                ? (state.name.value.trim().isEmpty
                    ? 'Please enter a name'
                    : null)
                : null;

        return CustomTextField(
          controller: controller,
          labelText: 'Name',
          hintText: 'e.g., Lunch',
          onChanged:
              (val) => context.read<AddExpenseBloc>().add(
                AddExpenseNameChanged(val),
              ),
          errorText: nameError,
        );
      },
    );
  }
}

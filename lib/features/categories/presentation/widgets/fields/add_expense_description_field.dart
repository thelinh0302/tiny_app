import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';

class AddExpenseDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const AddExpenseDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      buildWhen: (p, c) => p.note != c.note,
      builder: (context, state) {
        return CustomTextField(
          controller: controller,
          labelText: 'Description',
          hintText: 'Optional details',
          maxLines: 3,
          onChanged:
              (val) => context.read<AddExpenseBloc>().add(
                AddExpenseNoteChanged(val),
              ),
        );
      },
    );
  }
}

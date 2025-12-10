import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/core/widgets/custom_dropdown_field.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_list_bloc.dart';
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';

class AddExpenseCategoryField extends StatelessWidget {
  const AddExpenseCategoryField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListBloc, CategoryListState>(
      builder: (context, catState) {
        final List<DropdownMenuItem<String>> items =
            <DropdownMenuItem<String>>[];
        if (catState is CategoryListLoadSuccess) {
          final Set<String> seen = <String>{};
          for (final e in catState.items) {
            final String id = e.id;
            if (seen.add(id)) {
              items.add(
                DropdownMenuItem<String>(value: id, child: Text(e.name)),
              );
            }
          }
        }

        return BlocBuilder<AddExpenseBloc, AddExpenseState>(
          buildWhen: (p, c) => p.categoryId != c.categoryId,
          builder: (context, state) {
            final categoryError =
                context.select((AddExpenseBloc b) => b.state.showErrors)
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
                  (String? val) => context.read<AddExpenseBloc>().add(
                    AddExpenseCategoryChanged(val),
                  ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';

class AddExpenseSaveButton extends StatelessWidget {
  const AddExpenseSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: BlocBuilder<AddExpenseBloc, AddExpenseState>(
          buildWhen: (p, c) => p.status != c.status,
          builder: (context, state) {
            final isLoading =
                state.status == AddExpenseStatus.submissionInProgress;
            return PrimaryButton(
              text: 'Save',
              isLoading: isLoading,
              onPressed:
                  () => context.read<AddExpenseBloc>().add(
                    const AddExpenseSubmitted(),
                  ),
            );
          },
        ),
      ),
    );
  }
}

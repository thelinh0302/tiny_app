import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';

import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_list_bloc.dart';

import 'package:intl/intl.dart';

import 'package:finly_app/features/transactions/presentation/bloc/add_expense_bloc.dart';
import 'package:finly_app/features/categories/presentation/widgets/add_expense_form.dart';
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

  @override
  void dispose() {
    _dateCtrl.dispose();
    _amountCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
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
            child: AddExpenseForm(
              dateCtrl: _dateCtrl,
              amountCtrl: _amountCtrl,
              nameCtrl: _nameCtrl,
              descCtrl: _descCtrl,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/features/transactions/domain/usecases/create_transaction.dart';
import 'package:finly_app/features/transactions/presentation/models/transaction_inputs.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final CreateTransaction createTransaction;

  AddExpenseBloc({required this.createTransaction})
    : super(const AddExpenseState()) {
    on<AddExpenseInitialized>(_onInitialized);
    on<AddExpenseNameChanged>(_onNameChanged);
    on<AddExpenseCategoryChanged>(_onCategoryChanged);
    on<AddExpenseAmountChanged>(_onAmountChanged);
    on<AddExpenseDateChanged>(_onDateChanged);
    on<AddExpenseNoteChanged>(_onNoteChanged);
    on<AddExpenseAttachmentUrlChanged>(_onAttachmentUrlChanged);
    on<AddExpenseSubmitted>(_onSubmitted);
  }

  void _onInitialized(AddExpenseInitialized e, Emitter<AddExpenseState> emit) {
    if (e.categoryId != null) {
      emit(state.copyWith(categoryId: TxnCategoryIdInput.dirty(e.categoryId)));
    }
    if (e.initialDate != null) {
      emit(state.copyWith(date: TxnDateInput.dirty(e.initialDate)));
    }
  }

  void _onNameChanged(AddExpenseNameChanged e, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(name: TxnNameInput.dirty(e.name)));
  }

  void _onCategoryChanged(
    AddExpenseCategoryChanged e,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(categoryId: TxnCategoryIdInput.dirty(e.categoryId)));
  }

  void _onAmountChanged(
    AddExpenseAmountChanged e,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(amount: TxnAmountInput.dirty(e.amount)));
  }

  void _onDateChanged(AddExpenseDateChanged e, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(date: TxnDateInput.dirty(e.date)));
  }

  void _onNoteChanged(AddExpenseNoteChanged e, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(note: TxnNoteInput.dirty(e.note)));
  }

  void _onAttachmentUrlChanged(
    AddExpenseAttachmentUrlChanged e,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(attachmentUrl: TxnAttachmentUrlInput.dirty(e.url)));
  }

  Future<void> _onSubmitted(
    AddExpenseSubmitted e,
    Emitter<AddExpenseState> emit,
  ) async {
    final name = TxnNameInput.dirty(state.name.value);
    final categoryId = TxnCategoryIdInput.dirty(state.categoryId.value);
    final amount = TxnAmountInput.dirty(state.amount.value);
    final date = TxnDateInput.dirty(state.date.value);
    final note = TxnNoteInput.dirty(state.note.value);
    final attachmentUrl = TxnAttachmentUrlInput.dirty(
      state.attachmentUrl.value,
    );

    final isValid = Formz.validate([name, categoryId, amount, date]);
    emit(
      state.copyWith(
        name: name,
        categoryId: categoryId,
        amount: amount,
        date: date,
        note: note,
        attachmentUrl: attachmentUrl,
        status: AddExpenseStatus.initial,
        errorMessage: null,
        showErrors: true,
      ),
    );
    if (!isValid) return;

    emit(state.copyWith(status: AddExpenseStatus.submissionInProgress));

    final res = await createTransaction(
      CreateTransactionParams(
        categoryId: categoryId.value!,
        name: name.value.trim(),
        amount: amount.value!,
        date: date.value!,
        note: note.value,
        attachmentUrl: attachmentUrl.value,
      ),
    );

    res.fold(
      (failure) => emit(
        state.copyWith(
          status: AddExpenseStatus.submissionFailure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status:
              success
                  ? AddExpenseStatus.submissionSuccess
                  : AddExpenseStatus.submissionFailure,
        ),
      ),
    );
  }
}

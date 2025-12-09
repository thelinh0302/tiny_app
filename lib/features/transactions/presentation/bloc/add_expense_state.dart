part of 'add_expense_bloc.dart';

enum AddExpenseStatus {
  initial,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class AddExpenseState extends Equatable {
  final TxnNameInput name;
  final TxnCategoryIdInput categoryId;
  final TxnAmountInput amount;
  final TxnDateInput date;
  final TxnNoteInput note;
  final TxnAttachmentUrlInput attachmentUrl;
  final AddExpenseStatus status;
  final String? errorMessage;
  final bool showErrors;

  const AddExpenseState({
    this.name = const TxnNameInput.pure(),
    this.categoryId = const TxnCategoryIdInput.pure(),
    this.amount = const TxnAmountInput.pure(),
    this.date = const TxnDateInput.pure(),
    this.note = const TxnNoteInput.pure(),
    this.attachmentUrl = const TxnAttachmentUrlInput.pure(),
    this.status = AddExpenseStatus.initial,
    this.errorMessage,
    this.showErrors = false,
  });

  AddExpenseState copyWith({
    TxnNameInput? name,
    TxnCategoryIdInput? categoryId,
    TxnAmountInput? amount,
    TxnDateInput? date,
    TxnNoteInput? note,
    TxnAttachmentUrlInput? attachmentUrl,
    AddExpenseStatus? status,
    String? errorMessage,
    bool? showErrors,
  }) {
    return AddExpenseState(
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      status: status ?? this.status,
      errorMessage: errorMessage,
      showErrors: showErrors ?? this.showErrors,
    );
  }

  @override
  List<Object?> get props => [
    name,
    categoryId,
    amount,
    date,
    note,
    attachmentUrl,
    status,
    errorMessage,
    showErrors,
  ];
}

part of 'add_expense_bloc.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AddExpenseInitialized extends AddExpenseEvent {
  final String? categoryId;
  final DateTime? initialDate;

  const AddExpenseInitialized({this.categoryId, this.initialDate});

  @override
  List<Object?> get props => [categoryId, initialDate];
}

class AddExpenseNameChanged extends AddExpenseEvent {
  final String name;
  const AddExpenseNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class AddExpenseCategoryChanged extends AddExpenseEvent {
  final String? categoryId;
  const AddExpenseCategoryChanged(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class AddExpenseAmountChanged extends AddExpenseEvent {
  final double? amount;
  const AddExpenseAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class AddExpenseDateChanged extends AddExpenseEvent {
  final DateTime? date;
  const AddExpenseDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class AddExpenseNoteChanged extends AddExpenseEvent {
  final String? note;
  const AddExpenseNoteChanged(this.note);

  @override
  List<Object?> get props => [note];
}

class AddExpenseAttachmentUrlChanged extends AddExpenseEvent {
  final String? url;
  const AddExpenseAttachmentUrlChanged(this.url);

  @override
  List<Object?> get props => [url];
}

class AddExpenseSubmitted extends AddExpenseEvent {
  const AddExpenseSubmitted();
}

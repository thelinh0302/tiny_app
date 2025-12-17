part of 'delete_transaction_bloc.dart';

abstract class DeleteTransactionEvent extends Equatable {
  const DeleteTransactionEvent();

  @override
  List<Object?> get props => [];
}

class DeleteTransactionRequested extends DeleteTransactionEvent {
  final String id;
  const DeleteTransactionRequested(this.id);

  @override
  List<Object?> get props => [id];
}

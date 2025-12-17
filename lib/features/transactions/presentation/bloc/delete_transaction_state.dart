part of 'delete_transaction_bloc.dart';

enum DeleteTxnStatus { initial, loading, success, failure }

class DeleteTransactionState extends Equatable {
  final DeleteTxnStatus status;
  final String? errorMessage;

  const DeleteTransactionState({
    this.status = DeleteTxnStatus.initial,
    this.errorMessage,
  });

  DeleteTransactionState copyWith({
    DeleteTxnStatus? status,
    String? errorMessage,
  }) {
    return DeleteTransactionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

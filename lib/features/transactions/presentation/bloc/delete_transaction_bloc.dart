import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/features/transactions/domain/usecases/delete_transaction.dart';

part 'delete_transaction_event.dart';
part 'delete_transaction_state.dart';

class DeleteTransactionBloc
    extends Bloc<DeleteTransactionEvent, DeleteTransactionState> {
  final DeleteTransaction deleteTransaction;

  DeleteTransactionBloc({required this.deleteTransaction})
    : super(const DeleteTransactionState()) {
    on<DeleteTransactionRequested>(_onRequested);
  }

  Future<void> _onRequested(
    DeleteTransactionRequested event,
    Emitter<DeleteTransactionState> emit,
  ) async {
    emit(state.copyWith(status: DeleteTxnStatus.loading, errorMessage: null));

    final res = await deleteTransaction(DeleteTransactionParams(event.id));

    res.fold(
      (failure) => emit(
        state.copyWith(
          status: DeleteTxnStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: success ? DeleteTxnStatus.success : DeleteTxnStatus.failure,
        ),
      ),
    );
  }
}

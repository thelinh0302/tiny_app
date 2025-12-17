import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransaction implements UseCase<bool, DeleteTransactionParams> {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteTransactionParams params) {
    return repository.deleteTransaction(id: params.id);
  }
}

class DeleteTransactionParams extends Equatable {
  final String id;

  const DeleteTransactionParams(this.id);

  @override
  List<Object?> get props => [id];
}

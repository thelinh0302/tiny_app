import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';

class CreateTransaction implements UseCase<bool, CreateTransactionParams> {
  final TransactionRepository repository;

  CreateTransaction(this.repository);

  @override
  Future<Either<Failure, bool>> call(CreateTransactionParams params) {
    return repository.createTransaction(
      categoryId: params.categoryId,
      name: params.name,
      amount: params.amount,
      date: params.date,
      note: params.note,
      attachmentUrl: params.attachmentUrl,
    );
  }
}

class CreateTransactionParams extends Equatable {
  final String categoryId;
  final String name;
  final int amount; // minimal unit (VND units or USD cents)
  final DateTime date; // UTC or local converted to UTC by data source
  final String? note;
  final String? attachmentUrl;

  const CreateTransactionParams({
    required this.categoryId,
    required this.name,
    required this.amount,
    required this.date,
    this.note,
    this.attachmentUrl,
  });

  @override
  List<Object?> get props => [
    categoryId,
    name,
    amount,
    date,
    note,
    attachmentUrl,
  ];
}

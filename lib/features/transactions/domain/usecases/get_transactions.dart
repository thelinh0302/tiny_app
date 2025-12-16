import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/transactions/domain/entities/transaction.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';

class GetTransactions
    implements UseCase<TransactionsPageResult, GetTransactionsParams> {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, TransactionsPageResult>> call(
    GetTransactionsParams params,
  ) {
    return repository.getTransactions(
      page: params.page,
      pageSize: params.pageSize,
      period: params.period,
      categoryId: params.categoryId,
      type: params.type,
      dateStart: params.dateStart,
      dateEnd: params.dateEnd,
    );
  }
}

class GetTransactionsParams extends Equatable {
  final int page;
  final int pageSize;
  final String period;
  final String categoryId;
  final String? type; // 'income' | 'expense' | null
  final String? dateStart; // yyyy-MM-dd
  final String? dateEnd; // yyyy-MM-dd

  const GetTransactionsParams({
    required this.page,
    required this.pageSize,
    required this.period,
    required this.categoryId,
    this.type,
    this.dateStart,
    this.dateEnd,
  });

  @override
  List<Object?> get props => [
    page,
    pageSize,
    period,
    categoryId,
    type,
    dateStart,
    dateEnd,
  ];
}

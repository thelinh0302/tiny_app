import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, TransactionsPageResult>> getTransactions({
    required int page,
    required int pageSize,
    required String period,
    required String categoryId,
    String? type,
    String? dateStart,
    String? dateEnd,
  });

  Future<Either<Failure, bool>> createTransaction({
    required String categoryId,
    required String name,
    required double amount,
    required DateTime date,
    String? note,
    String? attachmentUrl,
  });
}

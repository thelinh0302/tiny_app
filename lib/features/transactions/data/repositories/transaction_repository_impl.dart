import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:finly_app/features/transactions/data/models/transaction_model.dart';
import 'package:finly_app/features/transactions/domain/entities/transaction.dart';
import 'package:finly_app/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remote;

  TransactionRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, TransactionsPageResult>> getTransactions({
    required int page,
    required int pageSize,
    required String period,
    required String categoryId,
  }) async {
    try {
      final TransactionsPageResultModel res = await remote.getTransactions(
        page: page,
        pageSize: pageSize,
        period: period,
        categoryId: categoryId,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Unknown error'));
    }
  }
}

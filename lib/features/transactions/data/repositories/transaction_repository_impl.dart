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
  Future<Either<Failure, bool>> deleteTransaction({required String id}) async {
    try {
      final bool success = await remote.deleteTransaction(id: id);
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Unknown error'));
    }
  }

  @override
  Future<Either<Failure, TransactionsPageResult>> getTransactions({
    required int page,
    required int pageSize,
    required String period,
    required String categoryId,
    String? type,
    String? dateStart,
    String? dateEnd,
  }) async {
    try {
      final TransactionsPageResultModel res = await remote.getTransactions(
        page: page,
        pageSize: pageSize,
        period: period,
        categoryId: categoryId,
        type: type,
        dateStart: dateStart,
        dateEnd: dateEnd,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> createTransaction({
    required String categoryId,
    required String name,
    required double amount,
    required DateTime date,
    String? note,
    String? attachmentUrl,
  }) async {
    try {
      final bool success = await remote.createTransaction(
        categoryId: categoryId,
        name: name,
        amount: amount,
        date: date,
        note: note,
        attachmentUrl: attachmentUrl,
      );
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Unknown error'));
    }
  }
}

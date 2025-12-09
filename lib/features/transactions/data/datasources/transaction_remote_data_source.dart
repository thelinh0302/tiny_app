import 'package:dio/dio.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/transactions/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionsPageResultModel> getTransactions({
    required int page,
    required int pageSize,
    required String period,
    required String categoryId,
  });
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final DioClient client;

  TransactionRemoteDataSourceImpl({required this.client});

  @override
  Future<TransactionsPageResultModel> getTransactions({
    required int page,
    required int pageSize,
    required String period,
    required String categoryId,
  }) async {
    try {
      final Response res = await client.get(
        '/transactions',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'period': period,
          'categoryId': categoryId,
        },
      );
      return TransactionsPageResultModel.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch transactions');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

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

  Future<bool> createTransaction({
    required String categoryId,
    required String name,
    required int amount,
    required DateTime date,
    String? note,
    String? attachmentUrl,
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

  @override
  Future<bool> createTransaction({
    required String categoryId,
    required String name,
    required int amount,
    required DateTime date,
    String? note,
    String? attachmentUrl,
  }) async {
    final String payloadDateIso =
        DateTime.utc(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
          date.microsecond,
        ).toIso8601String();
    try {
      final Response res = await client.post(
        '/transactions',
        data: {
          'categoryId': categoryId,
          'name': name,
          'amount': amount,
          'note': note,
          'date': payloadDateIso,
          'attachmentUrl': attachmentUrl,
        },
      );
      final data = res.data as Map<String, dynamic>;
      return (data['success'] as bool?) ?? false;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to create transaction');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

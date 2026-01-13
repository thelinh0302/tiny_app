import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:finly_app/features/analytics/domain/entities/analytics_summary.dart';
import 'package:finly_app/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remote;

  AnalyticsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, AnalyticsSummary>> getSummary({
    bool all = true,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final res = await remote.getSummary(
        all: all,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

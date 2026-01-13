import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/analytics/domain/entities/analytics_summary.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsSummary>> getSummary({
    bool all = true,
    String? startDate,
    String? endDate,
  });
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/analytics/domain/entities/analytics_summary.dart';
import 'package:finly_app/features/analytics/domain/repositories/analytics_repository.dart';

class GetAnalyticsSummary
    implements UseCase<AnalyticsSummary, GetAnalyticsSummaryParams> {
  final AnalyticsRepository repository;

  GetAnalyticsSummary(this.repository);

  @override
  Future<Either<Failure, AnalyticsSummary>> call(
    GetAnalyticsSummaryParams params,
  ) {
    return repository.getSummary(
      all: params.all,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetAnalyticsSummaryParams extends Equatable {
  final bool all;
  final String? startDate; // ISO-8601 string
  final String? endDate; // ISO-8601 string

  const GetAnalyticsSummaryParams({
    this.all = true,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [all, startDate, endDate];
}

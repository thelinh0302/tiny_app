part of 'analytics_summary_bloc.dart';

abstract class AnalyticsSummaryEvent extends Equatable {
  const AnalyticsSummaryEvent();

  @override
  List<Object?> get props => [];
}

class AnalyticsSummaryRequested extends AnalyticsSummaryEvent {
  final bool all;
  final String? startDate;
  final String? endDate;

  const AnalyticsSummaryRequested({
    this.all = true,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [all, startDate, endDate];
}

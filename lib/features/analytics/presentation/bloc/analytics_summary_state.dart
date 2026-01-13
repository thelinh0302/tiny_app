part of 'analytics_summary_bloc.dart';

abstract class AnalyticsSummaryState extends Equatable {
  const AnalyticsSummaryState();

  @override
  List<Object?> get props => [];
}

class AnalyticsSummaryInitial extends AnalyticsSummaryState {
  const AnalyticsSummaryInitial();
}

class AnalyticsSummaryLoadInProgress extends AnalyticsSummaryState {
  const AnalyticsSummaryLoadInProgress();
}

class AnalyticsSummaryLoadSuccess extends AnalyticsSummaryState {
  final AnalyticsSummary summary;
  const AnalyticsSummaryLoadSuccess({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class AnalyticsSummaryLoadFailure extends AnalyticsSummaryState {
  final String message;
  const AnalyticsSummaryLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

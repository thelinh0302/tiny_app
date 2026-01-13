import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/features/analytics/domain/entities/analytics_summary.dart';
import 'package:finly_app/features/analytics/domain/usecases/get_analytics_summary.dart';

part 'analytics_summary_event.dart';
part 'analytics_summary_state.dart';

class AnalyticsSummaryBloc
    extends Bloc<AnalyticsSummaryEvent, AnalyticsSummaryState> {
  final GetAnalyticsSummary getAnalyticsSummary;

  AnalyticsSummaryBloc({required this.getAnalyticsSummary})
    : super(const AnalyticsSummaryInitial()) {
    on<AnalyticsSummaryRequested>(_onRequested);
  }

  Future<void> _onRequested(
    AnalyticsSummaryRequested event,
    Emitter<AnalyticsSummaryState> emit,
  ) async {
    emit(const AnalyticsSummaryLoadInProgress());
    final res = await getAnalyticsSummary(
      GetAnalyticsSummaryParams(
        all: event.all,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    res.fold(
      (failure) => emit(AnalyticsSummaryLoadFailure(failure.message)),
      (data) => emit(AnalyticsSummaryLoadSuccess(summary: data)),
    );
  }
}

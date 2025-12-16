import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/features/transactions/domain/entities/transaction.dart';
import 'package:finly_app/features/transactions/domain/usecases/get_transactions.dart';

part 'category_transactions_event.dart';
part 'category_transactions_state.dart';

class CategoryTransactionsBloc
    extends Bloc<CategoryTransactionsEvent, CategoryTransactionsState> {
  final GetTransactions getTransactions;

  String? _categoryId;
  String _period = 'day';
  String? _dateStart;
  String? _dateEnd;
  int _pageSize = 20;
  bool _isLoadingMore = false;
  String? _type;

  CategoryTransactionsBloc({required this.getTransactions})
    : super(const CategoryTransactionsState()) {
    on<CategoryTransactionsRequested>(_onRequested);
    on<CategoryTransactionsLoadMore>(_onLoadMore);
  }

  Future<void> _onRequested(
    CategoryTransactionsRequested event,
    Emitter<CategoryTransactionsState> emit,
  ) async {
    _categoryId = event.categoryId;
    _period = event.period;
    _pageSize = event.pageSize;
    _type = event.type;
    _dateStart = event.dateStart;
    _dateEnd = event.dateEnd;

    emit(
      state.copyWith(
        status: CategoryTxStatus.loading,
        items: const [],
        page: 1,
        totalPages: 1,
        hasReachedEnd: false,
        errorMessage: null,
      ),
    );

    final res = await getTransactions(
      GetTransactionsParams(
        page: 1,
        pageSize: _pageSize,
        period: _period,
        categoryId: _categoryId!,
        type: _type,
        dateStart: _dateStart,
        dateEnd: _dateEnd,
      ),
    );

    res.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryTxStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: CategoryTxStatus.success,
          items: data.items,
          page: data.page,
          totalPages: data.totalPages,
          hasReachedEnd: data.page >= data.totalPages || data.items.isEmpty,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    CategoryTransactionsLoadMore event,
    Emitter<CategoryTransactionsState> emit,
  ) async {
    if (_isLoadingMore) return;
    if (state.hasReachedEnd) return;
    if (_categoryId == null) return;

    final nextPage = state.page + 1;
    _isLoadingMore = true;

    emit(state.copyWith(status: CategoryTxStatus.loadingMore));

    final res = await getTransactions(
      GetTransactionsParams(
        page: nextPage,
        pageSize: _pageSize,
        period: _period,
        categoryId: _categoryId!,
        type: _type,
        dateStart: _dateStart,
        dateEnd: _dateEnd,
      ),
    );

    res.fold(
      (failure) {
        _isLoadingMore = false;
        emit(state.copyWith(status: CategoryTxStatus.success));
      },
      (data) {
        _isLoadingMore = false;
        final merged = List<TransactionEntity>.from(state.items)
          ..addAll(data.items);
        emit(
          state.copyWith(
            status: CategoryTxStatus.success,
            items: merged,
            page: data.page,
            totalPages: data.totalPages,
            hasReachedEnd: data.page >= data.totalPages || data.items.isEmpty,
          ),
        );
      },
    );
  }
}

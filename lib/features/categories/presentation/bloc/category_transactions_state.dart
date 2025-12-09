part of 'category_transactions_bloc.dart';

enum CategoryTxStatus { initial, loading, success, failure, loadingMore }

class CategoryTransactionsState extends Equatable {
  final CategoryTxStatus status;
  final List<TransactionEntity> items;
  final int page;
  final int totalPages;
  final bool hasReachedEnd;
  final String? errorMessage;

  const CategoryTransactionsState({
    this.status = CategoryTxStatus.initial,
    this.items = const [],
    this.page = 1,
    this.totalPages = 1,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  CategoryTransactionsState copyWith({
    CategoryTxStatus? status,
    List<TransactionEntity>? items,
    int? page,
    int? totalPages,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return CategoryTransactionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    totalPages,
    hasReachedEnd,
    errorMessage,
  ];
}

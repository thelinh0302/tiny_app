part of 'category_transactions_bloc.dart';

abstract class CategoryTransactionsEvent extends Equatable {
  const CategoryTransactionsEvent();

  @override
  List<Object?> get props => [];
}

class CategoryTransactionRemoved extends CategoryTransactionsEvent {
  final String id;
  const CategoryTransactionRemoved(this.id);
  @override
  List<Object?> get props => [id];
}

class CategoryTransactionsRequested extends CategoryTransactionsEvent {
  final String categoryId;
  final String period;
  final int pageSize;
  final String? type;
  final String? dateStart; // yyyy-MM-dd
  final String? dateEnd; // yyyy-MM-dd

  const CategoryTransactionsRequested({
    required this.categoryId,
    this.period = 'day',
    this.pageSize = 20,
    this.type,
    this.dateStart,
    this.dateEnd,
  });

  @override
  List<Object?> get props => [
    categoryId,
    period,
    pageSize,
    type,
    dateStart,
    dateEnd,
  ];
}

class CategoryTransactionsLoadMore extends CategoryTransactionsEvent {}

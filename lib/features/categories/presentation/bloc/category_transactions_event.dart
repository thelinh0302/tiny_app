part of 'category_transactions_bloc.dart';

abstract class CategoryTransactionsEvent extends Equatable {
  const CategoryTransactionsEvent();

  @override
  List<Object?> get props => [];
}

class CategoryTransactionsRequested extends CategoryTransactionsEvent {
  final String categoryId;
  final String period;
  final int pageSize;
  final String? type;

  const CategoryTransactionsRequested({
    required this.categoryId,
    this.period = 'day',
    this.pageSize = 20,
    this.type,
  });

  @override
  List<Object?> get props => [categoryId, period, pageSize, type];
}

class CategoryTransactionsLoadMore extends CategoryTransactionsEvent {}

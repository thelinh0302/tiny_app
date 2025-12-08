part of 'category_list_bloc.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object?> get props => [];
}

class CategoryListInitial extends CategoryListState {
  const CategoryListInitial();
}

class CategoryListLoadInProgress extends CategoryListState {
  const CategoryListLoadInProgress();
}

class CategoryListLoadSuccess extends CategoryListState {
  final List<Category> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const CategoryListLoadSuccess({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [items, total, page, pageSize, totalPages];
}

class CategoryListLoadFailure extends CategoryListState {
  final String message;
  const CategoryListLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

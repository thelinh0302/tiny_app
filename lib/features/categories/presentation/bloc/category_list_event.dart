part of 'category_list_bloc.dart';

abstract class CategoryListEvent extends Equatable {
  const CategoryListEvent();

  @override
  List<Object?> get props => [];
}

class CategoryListRequested extends CategoryListEvent {
  final int page;
  final int pageSize;

  const CategoryListRequested({required this.page, required this.pageSize});

  @override
  List<Object?> get props => [page, pageSize];
}

class CategoryListRefreshed extends CategoryListEvent {
  final int pageSize;
  const CategoryListRefreshed({this.pageSize = 20});
}

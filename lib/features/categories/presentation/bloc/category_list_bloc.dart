import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/features/categories/domain/entities/category.dart';
import 'package:finly_app/features/categories/domain/repositories/category_repository.dart';
import 'package:finly_app/features/categories/domain/usecases/get_categories.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final GetCategories getCategories;

  CategoryListBloc({required this.getCategories})
    : super(const CategoryListInitial()) {
    on<CategoryListRequested>(_onRequested);
    on<CategoryListRefreshed>(_onRefreshed);
  }

  Future<void> _onRequested(
    CategoryListRequested event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(const CategoryListLoadInProgress());
    final res = await getCategories(
      GetCategoriesParams(page: event.page, pageSize: event.pageSize),
    );
    res.fold(
      (failure) => emit(CategoryListLoadFailure(failure.message)),
      (data) => emit(
        CategoryListLoadSuccess(
          items: data.items,
          total: data.total,
          page: data.page,
          pageSize: data.pageSize,
          totalPages: data.totalPages,
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    CategoryListRefreshed event,
    Emitter<CategoryListState> emit,
  ) async {
    // For simplicity, just call requested again with first page
    add(CategoryListRequested(page: 1, pageSize: event.pageSize));
  }
}

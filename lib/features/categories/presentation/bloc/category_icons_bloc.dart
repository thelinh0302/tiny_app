import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/categories/domain/entities/category_icon.dart';
import 'package:finly_app/features/categories/domain/usecases/get_category_icons.dart';

part 'category_icons_event.dart';
part 'category_icons_state.dart';

/// BLoC responsible for loading category icons.
///
/// Depends on the domain use case [GetCategoryIcons], mirroring the
/// clean architecture style of the auth and user features.
class CategoryIconsBloc extends Bloc<CategoryIconsEvent, CategoryIconsState> {
  final GetCategoryIcons getCategoryIcons;

  CategoryIconsBloc({required this.getCategoryIcons})
    : super(const CategoryIconsInitial()) {
    on<CategoryIconsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    CategoryIconsRequested event,
    Emitter<CategoryIconsState> emit,
  ) async {
    emit(const CategoryIconsLoadInProgress());

    final result = await getCategoryIcons(NoParams());
    result.fold(
      (failure) => emit(CategoryIconsLoadFailure(failure.message)),
      (icons) => emit(
        CategoryIconsLoadSuccess(
          // Map domain CategoryIcon entities to a simple view model
          icons.map((e) => e).toList(),
        ),
      ),
    );
  }
}

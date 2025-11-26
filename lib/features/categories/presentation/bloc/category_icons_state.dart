part of 'category_icons_bloc.dart';

/// Base state for [CategoryIconsBloc].
abstract class CategoryIconsState extends Equatable {
  const CategoryIconsState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state before any load is triggered.
class CategoryIconsInitial extends CategoryIconsState {
  const CategoryIconsInitial();
}

/// Loading in progress.
class CategoryIconsLoadInProgress extends CategoryIconsState {
  const CategoryIconsLoadInProgress();
}

/// Successfully loaded icons.
class CategoryIconsLoadSuccess extends CategoryIconsState {
  final List<CategoryIcon> icons;

  const CategoryIconsLoadSuccess(this.icons);

  @override
  List<Object?> get props => <Object?>[icons];
}

/// Failed to load icons.
class CategoryIconsLoadFailure extends CategoryIconsState {
  final String message;

  const CategoryIconsLoadFailure(this.message);

  @override
  List<Object?> get props => <Object?>[message];
}

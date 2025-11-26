part of 'category_icons_bloc.dart';

/// Events for [CategoryIconsBloc].
abstract class CategoryIconsEvent extends Equatable {
  const CategoryIconsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Trigger loading icons from ImageKit.
class CategoryIconsRequested extends CategoryIconsEvent {
  const CategoryIconsRequested();
}

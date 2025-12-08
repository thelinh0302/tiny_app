part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object?> get props => [];
}

class AddCategoryNameChanged extends AddCategoryEvent {
  final String name;
  const AddCategoryNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class AddCategoryTypeChanged extends AddCategoryEvent {
  final String? type; // 'income' | 'expense'
  const AddCategoryTypeChanged(this.type);

  @override
  List<Object?> get props => [type];
}

class AddCategoryIconChanged extends AddCategoryEvent {
  final String? iconUrl;
  const AddCategoryIconChanged(this.iconUrl);

  @override
  List<Object?> get props => [iconUrl];
}

class AddCategorySubmitted extends AddCategoryEvent {
  const AddCategorySubmitted();
}

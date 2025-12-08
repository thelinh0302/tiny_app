part of 'add_category_bloc.dart';

enum AddCategoryStatus {
  initial,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class AddCategoryState extends Equatable {
  final CategoryNameInput name;
  final CategoryTypeInput type;
  final CategoryIconInput icon;
  final AddCategoryStatus status;
  final String? errorMessage;
  final domain.Category? created;

  const AddCategoryState({
    this.name = const CategoryNameInput.pure(),
    this.type = const CategoryTypeInput.pure(),
    this.icon = const CategoryIconInput.pure(),
    this.status = AddCategoryStatus.initial,
    this.errorMessage,
    this.created,
  });

  AddCategoryState copyWith({
    CategoryNameInput? name,
    CategoryTypeInput? type,
    CategoryIconInput? icon,
    AddCategoryStatus? status,
    String? errorMessage,
    domain.Category? created,
  }) {
    return AddCategoryState(
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      errorMessage: errorMessage,
      created: created ?? this.created,
    );
  }

  @override
  List<Object?> get props => [name, type, icon, status, errorMessage, created];
}

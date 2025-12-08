import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/features/categories/domain/entities/category.dart'
    as domain;
import 'package:finly_app/features/categories/domain/usecases/create_category.dart';
import 'package:finly_app/features/categories/presentation/models/category_inputs.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final CreateCategory createCategory;

  AddCategoryBloc({required this.createCategory})
    : super(const AddCategoryState()) {
    on<AddCategoryNameChanged>(_onNameChanged);
    on<AddCategoryTypeChanged>(_onTypeChanged);
    on<AddCategoryIconChanged>(_onIconChanged);
    on<AddCategorySubmitted>(_onSubmitted);
  }

  void _onNameChanged(
    AddCategoryNameChanged e,
    Emitter<AddCategoryState> emit,
  ) {
    final name = CategoryNameInput.dirty(e.name);
    emit(state.copyWith(name: name));
  }

  void _onTypeChanged(
    AddCategoryTypeChanged e,
    Emitter<AddCategoryState> emit,
  ) {
    final type = CategoryTypeInput.dirty(e.type);
    emit(state.copyWith(type: type));
  }

  void _onIconChanged(
    AddCategoryIconChanged e,
    Emitter<AddCategoryState> emit,
  ) {
    final icon = CategoryIconInput.dirty(e.iconUrl);
    emit(state.copyWith(icon: icon));
  }

  Future<void> _onSubmitted(
    AddCategorySubmitted e,
    Emitter<AddCategoryState> emit,
  ) async {
    final name = CategoryNameInput.dirty(state.name.value);
    final type = CategoryTypeInput.dirty(state.type.value);
    final icon = CategoryIconInput.dirty(state.icon.value);

    final isValid = Formz.validate([name, type, icon]);
    emit(state.copyWith(name: name, type: type, icon: icon));
    if (!isValid) return;

    emit(
      state.copyWith(
        status: AddCategoryStatus.submissionInProgress,
        errorMessage: null,
      ),
    );

    final res = await createCategory(
      CreateCategoryParams(
        name: name.value.trim(),
        type: type.value!,
        icon: icon.value!,
      ),
    );
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: AddCategoryStatus.submissionFailure,
          errorMessage: failure.message,
        ),
      ),
      (created) => emit(
        state.copyWith(
          status: AddCategoryStatus.submissionSuccess,
          created: created,
        ),
      ),
    );
  }
}

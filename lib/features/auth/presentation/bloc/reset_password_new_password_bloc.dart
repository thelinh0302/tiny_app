import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/features/auth/domain/usecases/reset_password_with_phone.dart'
    as usecase;
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';
import 'package:finly_app/features/auth/presentation/models/signup_inputs.dart';

part 'reset_password_new_password_event.dart';
part 'reset_password_new_password_state.dart';

/// Handles the final step of reset password flow:
/// - validate new password + confirm
/// - call backend API with phone + firebaseIdToken to update password
class ResetPasswordNewPasswordBloc
    extends Bloc<ResetPasswordNewPasswordEvent, ResetPasswordNewPasswordState> {
  final usecase.ResetPasswordWithPhone resetPasswordWithPhone;

  ResetPasswordNewPasswordBloc({required this.resetPasswordWithPhone})
    : super(const ResetPasswordNewPasswordState()) {
    on<ResetPasswordNewPasswordChanged>(_onPasswordChanged);
    on<ResetPasswordConfirmNewPasswordChanged>(_onConfirmChanged);
    on<ResetPasswordNewPasswordSubmitted>(_onSubmitted);
  }

  void _onPasswordChanged(
    ResetPasswordNewPasswordChanged event,
    Emitter<ResetPasswordNewPasswordState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    final confirm = state.confirmPassword.revalidateWith(
      password: password.value,
    );
    emit(state.copyWith(password: password, confirmPassword: confirm));
  }

  void _onConfirmChanged(
    ResetPasswordConfirmNewPasswordChanged event,
    Emitter<ResetPasswordNewPasswordState> emit,
  ) {
    final confirm = ConfirmedPasswordInput.dirty(
      value: event.confirmPassword,
      password: state.password.value,
    );
    emit(state.copyWith(confirmPassword: confirm));
  }

  Future<void> _onSubmitted(
    ResetPasswordNewPasswordSubmitted event,
    Emitter<ResetPasswordNewPasswordState> emit,
  ) async {
    final password = PasswordInput.dirty(state.password.value);
    final confirm = ConfirmedPasswordInput.dirty(
      value: state.confirmPassword.value,
      password: password.value,
    );

    final isValid = Formz.validate([password, confirm]);

    if (!isValid) {
      emit(
        state.copyWith(
          password: password,
          confirmPassword: confirm,
          status: ResetPasswordNewPasswordStatus.failure,
          errorMessage: 'auth.resetPassword.messages.invalidInputs',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirm,
        status: ResetPasswordNewPasswordStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final result = await resetPasswordWithPhone(
        usecase.ResetPasswordWithPhoneParams(
          phone: event.phone,
          newPassword: password.value,
          firebaseIdToken: event.firebaseIdToken,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ResetPasswordNewPasswordStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(status: ResetPasswordNewPasswordStatus.success),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordNewPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

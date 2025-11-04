import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/features/auth/domain/usecases/login.dart' as usecase;
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final usecase.Login login;

  LoginBloc({required this.login}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginObscureToggled>(_onObscureToggled);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(email: email));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    emit(state.copyWith(password: password));
  }

  void _onObscureToggled(LoginObscureToggled event, Emitter<LoginState> emit) {
    emit(state.copyWith(obscure: !state.obscure));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    final isValid = Formz.validate([email, password]);
    emit(state.copyWith(email: email, password: password));
    if (!isValid) return;

    emit(
      state.copyWith(
        status: LoginStatus.submissionInProgress,
        errorMessage: null,
      ),
    );
    final result = await login(
      usecase.LoginParams(email: email.value.trim(), password: password.value),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.submissionFailure,
          errorMessage: failure.message,
        ),
      ),
      (ok) => emit(state.copyWith(status: LoginStatus.submissionSuccess)),
    );
  }
}

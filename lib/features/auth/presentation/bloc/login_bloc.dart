import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/features/auth/domain/usecases/login.dart' as usecase;
import 'package:finly_app/features/auth/domain/usecases/login_with_google.dart'
    as google_usecase;
import 'package:finly_app/features/auth/domain/usecases/login_with_facebook.dart'
    as facebook_usecase;
import 'package:finly_app/features/auth/domain/usecases/login_with_biometrics.dart'
    as bio_usecase;
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final usecase.Login login;
  final google_usecase.LoginWithGoogle loginWithGoogle;
  final facebook_usecase.LoginWithFacebook loginWithFacebook;
  final bio_usecase.LoginWithBiometrics loginWithBiometrics;

  LoginBloc({
    required this.login,
    required this.loginWithGoogle,
    required this.loginWithFacebook,
    required this.loginWithBiometrics,
  }) : super(const LoginState()) {
    on<LoginPhoneChanged>(_onPhoneChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginObscureToggled>(_onObscureToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginWithGooglePressed>(_onLoginWithGoogle);
    on<LoginWithFacebookPressed>(_onLoginWithFacebook);
    on<LoginWithBiometricsPressed>(_onLoginWithBiometrics);
  }

  void _onPhoneChanged(LoginPhoneChanged event, Emitter<LoginState> emit) {
    final phone = PhoneInput.dirty(event.phone);
    emit(state.copyWith(phone: phone));
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
    final phone = PhoneInput.dirty(state.phone.value);
    final password = PasswordInput.dirty(state.password.value);
    final isValid = Formz.validate([phone, password]);
    emit(state.copyWith(phone: phone, password: password));
    if (!isValid) return;

    emit(
      state.copyWith(
        status: LoginStatus.submissionInProgress,
        errorMessage: null,
      ),
    );
    final result = await login(
      usecase.LoginParams(phone: phone.value.trim(), password: password.value),
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

  Future<void> _onLoginWithGoogle(
    LoginWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoginStatus.submissionInProgress,
        errorMessage: null,
      ),
    );

    final result = await loginWithGoogle(NoParams());
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

  Future<void> _onLoginWithFacebook(
    LoginWithFacebookPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoginStatus.submissionInProgress,
        errorMessage: null,
      ),
    );

    final result = await loginWithFacebook(NoParams());
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

  Future<void> _onLoginWithBiometrics(
    LoginWithBiometricsPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoginStatus.submissionInProgress,
        errorMessage: null,
      ),
    );

    final result = await loginWithBiometrics(NoParams());
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

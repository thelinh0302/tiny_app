import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/features/auth/domain/usecases/signup.dart' as usecase;
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';
import 'package:finly_app/features/auth/presentation/models/signup_inputs.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final usecase.Signup signup;

  SignupBloc({required this.signup}) : super(const SignupState()) {
    on<SignupFullNameChanged>(_onFullNameChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupMobileChanged>(_onMobileChanged);
    on<SignupDobChanged>(_onDobChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupPasswordObscureToggled>(_onPasswordObscureToggled);
    on<SignupConfirmObscureToggled>(_onConfirmObscureToggled);
    on<SignupSubmitted>(_onSubmitted);
  }

  void _onFullNameChanged(
    SignupFullNameChanged event,
    Emitter<SignupState> emit,
  ) {
    final fullName = FullNameInput.dirty(event.fullName);
    emit(state.copyWith(fullName: fullName));
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(email: email));
  }

  void _onMobileChanged(SignupMobileChanged event, Emitter<SignupState> emit) {
    final mobile = MobileInput.dirty(event.mobile);
    emit(state.copyWith(mobile: mobile));
  }

  void _onDobChanged(SignupDobChanged event, Emitter<SignupState> emit) {
    final dob = DobInput.dirty(event.dob);
    emit(state.copyWith(dob: dob));
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    // Revalidate confirm with new password
    final confirm = state.confirmPassword.revalidateWith(
      password: password.value,
    );
    emit(state.copyWith(password: password, confirmPassword: confirm));
  }

  void _onConfirmPasswordChanged(
    SignupConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final confirm = ConfirmedPasswordInput.dirty(
      value: event.confirmPassword,
      password: state.password.value,
    );
    emit(state.copyWith(confirmPassword: confirm));
  }

  void _onPasswordObscureToggled(
    SignupPasswordObscureToggled event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onConfirmObscureToggled(
    SignupConfirmObscureToggled event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    final fullName = FullNameInput.dirty(state.fullName.value);
    final email = EmailInput.dirty(state.email.value);
    final mobile = MobileInput.dirty(state.mobile.value);
    final dob = DobInput.dirty(state.dob.value);
    final password = PasswordInput.dirty(state.password.value);
    final confirm = ConfirmedPasswordInput.dirty(
      value: state.confirmPassword.value,
      password: password.value,
    );

    final isValid = Formz.validate([
      fullName,
      email,
      mobile,
      dob,
      password,
      confirm,
    ]);

    emit(
      state.copyWith(
        fullName: fullName,
        email: email,
        mobile: mobile,
        dob: dob,
        password: password,
        confirmPassword: confirm,
      ),
    );

    if (!isValid) return;

    emit(
      state.copyWith(
        status: SignupStatus.submissionInProgress,
        errorMessage: null,
      ),
    );

    final result = await signup(
      usecase.SignupParams(
        fullName: fullName.value.trim(),
        email: email.value.trim(),
        mobile: mobile.value.trim(),
        dob: dob.value!,
        password: password.value,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignupStatus.submissionFailure,
          errorMessage: failure.message,
        ),
      ),
      (ok) => emit(state.copyWith(status: SignupStatus.submissionSuccess)),
    );
  }
}

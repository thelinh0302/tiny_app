part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupFullNameChanged extends SignupEvent {
  final String fullName;
  const SignupFullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupMobileChanged extends SignupEvent {
  final String mobile;
  const SignupMobileChanged(this.mobile);

  @override
  List<Object?> get props => [mobile];
}

class SignupDobChanged extends SignupEvent {
  final DateTime? dob;
  const SignupDobChanged(this.dob);

  @override
  List<Object?> get props => [dob];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  const SignupConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class SignupPasswordObscureToggled extends SignupEvent {
  const SignupPasswordObscureToggled();
}

class SignupConfirmObscureToggled extends SignupEvent {
  const SignupConfirmObscureToggled();
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginObscureToggled extends LoginEvent {
  const LoginObscureToggled();
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class LoginWithGooglePressed extends LoginEvent {
  const LoginWithGooglePressed();
}

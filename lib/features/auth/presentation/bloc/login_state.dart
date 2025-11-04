part of 'login_bloc.dart';

/// Local submission status enum to avoid direct dependency in part file.
/// We still use Formz for input validation, but track submission state here.
enum LoginStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class LoginState extends Equatable {
  final EmailInput email;
  final PasswordInput password;
  final LoginStatus status;
  final bool obscure;
  final String? errorMessage;

  const LoginState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = LoginStatus.pure,
    this.obscure = true,
    this.errorMessage,
  });

  LoginState copyWith({
    EmailInput? email,
    PasswordInput? password,
    LoginStatus? status,
    bool? obscure,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      obscure: obscure ?? this.obscure,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, obscure, errorMessage];
}

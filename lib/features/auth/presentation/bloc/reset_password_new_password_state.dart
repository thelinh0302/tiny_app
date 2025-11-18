part of 'reset_password_new_password_bloc.dart';

enum ResetPasswordNewPasswordStatus { initial, loading, success, failure }

class ResetPasswordNewPasswordState extends Equatable {
  final PasswordInput password;
  final ConfirmedPasswordInput confirmPassword;
  final ResetPasswordNewPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordNewPasswordState({
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmedPasswordInput.pure(),
    this.status = ResetPasswordNewPasswordStatus.initial,
    this.errorMessage,
  });

  ResetPasswordNewPasswordState copyWith({
    PasswordInput? password,
    ConfirmedPasswordInput? confirmPassword,
    ResetPasswordNewPasswordStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordNewPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [password, confirmPassword, status, errorMessage];
}

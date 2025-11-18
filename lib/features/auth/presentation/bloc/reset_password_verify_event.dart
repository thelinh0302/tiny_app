part of 'reset_password_verify_bloc.dart';

abstract class ResetPasswordVerifyEvent extends Equatable {
  const ResetPasswordVerifyEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordCodeChanged extends ResetPasswordVerifyEvent {
  final String code;

  const ResetPasswordCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class ResetPasswordNewPasswordChanged extends ResetPasswordVerifyEvent {
  final String password;

  const ResetPasswordNewPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ResetPasswordConfirmPasswordChanged extends ResetPasswordVerifyEvent {
  final String confirmPassword;

  const ResetPasswordConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class ResetPasswordVerifySubmitted extends ResetPasswordVerifyEvent {
  final String phone;
  final String verificationId;

  const ResetPasswordVerifySubmitted({
    required this.phone,
    required this.verificationId,
  });

  @override
  List<Object?> get props => [phone, verificationId];
}

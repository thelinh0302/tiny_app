part of 'reset_password_new_password_bloc.dart';

abstract class ResetPasswordNewPasswordEvent extends Equatable {
  const ResetPasswordNewPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordNewPasswordChanged extends ResetPasswordNewPasswordEvent {
  final String password;

  const ResetPasswordNewPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ResetPasswordConfirmNewPasswordChanged
    extends ResetPasswordNewPasswordEvent {
  final String confirmPassword;

  const ResetPasswordConfirmNewPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class ResetPasswordNewPasswordSubmitted extends ResetPasswordNewPasswordEvent {
  final String phone;
  final String firebaseIdToken;

  const ResetPasswordNewPasswordSubmitted({
    required this.phone,
    required this.firebaseIdToken,
  });

  @override
  List<Object?> get props => [phone, firebaseIdToken];
}

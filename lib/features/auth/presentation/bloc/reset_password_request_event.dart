part of 'reset_password_request_bloc.dart';

abstract class ResetPasswordRequestEvent extends Equatable {
  const ResetPasswordRequestEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordPhoneChanged extends ResetPasswordRequestEvent {
  final String phone;

  const ResetPasswordPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class ResetPasswordRequestSubmitted extends ResetPasswordRequestEvent {
  const ResetPasswordRequestSubmitted();
}

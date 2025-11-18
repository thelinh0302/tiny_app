part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpSubmitted extends OtpEvent {
  final String verificationId;
  final String code;
  final String fullName;
  final String email;
  final String mobile;
  final DateTime dob;
  final String password;

  const OtpSubmitted({
    required this.verificationId,
    required this.code,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.password,
  });

  @override
  List<Object?> get props => [
    verificationId,
    code,
    fullName,
    email,
    mobile,
    dob,
    password,
  ];
}

class OtpResendRequested extends OtpEvent {
  final String mobile;

  const OtpResendRequested(this.mobile);

  @override
  List<Object?> get props => [mobile];
}

part of 'reset_password_request_bloc.dart';

enum ResetPasswordRequestStatus { pure, sendingCode, codeSent, failure }

class ResetPasswordRequestState extends Equatable {
  final PhoneInput phone;
  final ResetPasswordRequestStatus status;
  final String? verificationId;
  final String? errorMessage;

  const ResetPasswordRequestState({
    this.phone = const PhoneInput.pure(),
    this.status = ResetPasswordRequestStatus.pure,
    this.verificationId,
    this.errorMessage,
  });

  ResetPasswordRequestState copyWith({
    PhoneInput? phone,
    ResetPasswordRequestStatus? status,
    String? verificationId,
    String? errorMessage,
  }) {
    return ResetPasswordRequestState(
      phone: phone ?? this.phone,
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [phone, status, verificationId, errorMessage];
}

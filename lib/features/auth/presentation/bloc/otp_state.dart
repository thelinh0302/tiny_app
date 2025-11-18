part of 'otp_bloc.dart';

enum OtpStatus {
  initial,
  loading,
  success,
  failure,
  resendInProgress,
  resendSuccess,
}

class OtpState extends Equatable {
  final OtpStatus status;
  final String? errorMessage;
  final String? verificationId; // updated when resend succeeds

  const OtpState({
    required this.status,
    this.errorMessage,
    this.verificationId,
  });

  const OtpState.initial() : this(status: OtpStatus.initial);

  const OtpState.loading() : this(status: OtpStatus.loading);

  const OtpState.success() : this(status: OtpStatus.success);

  const OtpState.failure(String message)
    : this(status: OtpStatus.failure, errorMessage: message);

  const OtpState.resendInProgress() : this(status: OtpStatus.resendInProgress);

  const OtpState.resendSuccess(String newVerificationId)
    : this(status: OtpStatus.resendSuccess, verificationId: newVerificationId);

  @override
  List<Object?> get props => [status, errorMessage, verificationId];
}

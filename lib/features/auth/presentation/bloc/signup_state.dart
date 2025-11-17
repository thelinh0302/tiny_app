part of 'signup_bloc.dart';

enum SignupStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
  otpSending,
  otpSent,
}

class SignupState extends Equatable {
  final FullNameInput fullName;
  final EmailInput email;
  final MobileInput mobile;
  final DobInput dob;
  final PasswordInput password;
  final ConfirmedPasswordInput confirmPassword;

  final SignupStatus status;
  final bool obscurePassword;
  final bool obscureConfirm;
  final String? errorMessage;
  final String? verificationId;

  const SignupState({
    this.fullName = const FullNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.mobile = const MobileInput.pure(),
    this.dob = const DobInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmedPasswordInput.pure(),
    this.status = SignupStatus.pure,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.errorMessage,
    this.verificationId,
  });

  SignupState copyWith({
    FullNameInput? fullName,
    EmailInput? email,
    MobileInput? mobile,
    DobInput? dob,
    PasswordInput? password,
    ConfirmedPasswordInput? confirmPassword,
    SignupStatus? status,
    bool? obscurePassword,
    bool? obscureConfirm,
    String? errorMessage,
    String? verificationId,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      dob: dob ?? this.dob,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      errorMessage: errorMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    mobile,
    dob,
    password,
    confirmPassword,
    status,
    obscurePassword,
    obscureConfirm,
    errorMessage,
    verificationId,
  ];
}

part of 'reset_password_verify_bloc.dart';

enum ResetPasswordVerifyStatus { initial, loading, success, failure }

class ResetPasswordVerifyState extends Equatable {
  final String code;
  final String? firebaseIdToken;
  final ResetPasswordVerifyStatus status;
  final String? errorMessage;

  const ResetPasswordVerifyState({
    this.code = '',
    this.firebaseIdToken,
    this.status = ResetPasswordVerifyStatus.initial,
    this.errorMessage,
  });

  ResetPasswordVerifyState copyWith({
    String? code,
    String? firebaseIdToken,
    ResetPasswordVerifyStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordVerifyState(
      code: code ?? this.code,
      firebaseIdToken: firebaseIdToken ?? this.firebaseIdToken,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [code, firebaseIdToken, status, errorMessage];
}

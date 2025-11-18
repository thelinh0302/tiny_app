import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/core/services/phone_auth_service.dart';

part 'reset_password_verify_event.dart';
part 'reset_password_verify_state.dart';

/// Handles OTP verification for reset password:
/// - verify OTP with Firebase to get ID token
/// - emit success with the Firebase ID token; password is handled on another page
class ResetPasswordVerifyBloc
    extends Bloc<ResetPasswordVerifyEvent, ResetPasswordVerifyState> {
  final PhoneAuthService phoneAuth;

  ResetPasswordVerifyBloc({required this.phoneAuth})
    : super(const ResetPasswordVerifyState()) {
    on<ResetPasswordCodeChanged>(_onCodeChanged);
    on<ResetPasswordVerifySubmitted>(_onSubmitted);
  }

  void _onCodeChanged(
    ResetPasswordCodeChanged event,
    Emitter<ResetPasswordVerifyState> emit,
  ) {
    emit(state.copyWith(code: event.code));
  }

  Future<void> _onSubmitted(
    ResetPasswordVerifySubmitted event,
    Emitter<ResetPasswordVerifyState> emit,
  ) async {
    if (state.code.length != 6) {
      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.failure,
          errorMessage: 'auth.otp.messages.invalidCode',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ResetPasswordVerifyStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final idToken = await phoneAuth.verifyAndGetIdToken(
        verificationId: event.verificationId,
        smsCode: state.code,
      );

      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.success,
          firebaseIdToken: idToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

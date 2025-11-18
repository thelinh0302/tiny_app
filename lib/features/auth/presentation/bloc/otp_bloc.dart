import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/core/services/phone_auth_service.dart';
import 'package:finly_app/features/auth/domain/usecases/signup_with_firebase_token.dart';

part 'otp_event.dart';
part 'otp_state.dart';

/// OtpBloc orchestrates OTP verification and signup using injected
/// services/use cases, keeping the widget layer free of business logic.
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final PhoneAuthService phoneAuth;
  final SignupWithFirebaseToken signupWithFirebaseToken;

  OtpBloc({required this.phoneAuth, required this.signupWithFirebaseToken})
    : super(const OtpState.initial()) {
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResendRequested);
  }

  Future<void> _onSubmitted(OtpSubmitted event, Emitter<OtpState> emit) async {
    // Normalize OTP to digits only; some widgets may add spaces or separators.
    final normalizedCode = event.code.replaceAll(RegExp(r'[^0-9]'), '');

    // Simple input validation at the application/presentation layer.
    if (normalizedCode.length != 6) {
      emit(const OtpState.failure('auth.otp.messages.invalidCode'));
      return;
    }

    emit(const OtpState.loading());

    try {
      final idToken = await phoneAuth.verifyAndGetIdToken(
        verificationId: event.verificationId,
        smsCode: normalizedCode,
      );

      final result = await signupWithFirebaseToken(
        SignupWithFirebaseTokenParams(
          fullName: event.fullName,
          email: event.email,
          mobile: event.mobile,
          dob: event.dob,
          password: event.password,
          firebaseIdToken: idToken,
        ),
      );

      result.fold(
        (failure) => emit(OtpState.failure(failure.message)),
        (_) => emit(const OtpState.success()),
      );
    } catch (e) {
      emit(OtpState.failure(e.toString()));
    }
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(const OtpState.resendInProgress());

    try {
      final newVerificationId = await phoneAuth.sendCode(event.mobile);
      emit(OtpState.resendSuccess(newVerificationId));
    } catch (e) {
      emit(OtpState.failure(e.toString()));
    }
  }
}

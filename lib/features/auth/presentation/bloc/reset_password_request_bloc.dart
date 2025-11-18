import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:finly_app/core/services/phone_auth_service.dart';
import 'package:finly_app/features/auth/domain/usecases/check_user_exists.dart'
    as exists_usecase;
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';

part 'reset_password_request_event.dart';
part 'reset_password_request_state.dart';

/// Handles the first step of the reset password flow:
/// 1) User inputs phone number
/// 2) We send an OTP via Firebase PhoneAuth and expose the verificationId
class ResetPasswordRequestBloc
    extends Bloc<ResetPasswordRequestEvent, ResetPasswordRequestState> {
  final PhoneAuthService phoneAuth;
  final exists_usecase.CheckUserExists checkUserExists;

  ResetPasswordRequestBloc({
    required this.phoneAuth,
    required this.checkUserExists,
  }) : super(const ResetPasswordRequestState()) {
    on<ResetPasswordPhoneChanged>(_onPhoneChanged);
    on<ResetPasswordRequestSubmitted>(_onSubmitted);
  }

  void _onPhoneChanged(
    ResetPasswordPhoneChanged event,
    Emitter<ResetPasswordRequestState> emit,
  ) {
    final phone = PhoneInput.dirty(event.phone);
    emit(state.copyWith(phone: phone));
  }

  Future<void> _onSubmitted(
    ResetPasswordRequestSubmitted event,
    Emitter<ResetPasswordRequestState> emit,
  ) async {
    final phone = PhoneInput.dirty(state.phone.value);
    emit(state.copyWith(phone: phone));

    final isValid = Formz.validate([phone]);
    if (!isValid) return;

    emit(
      state.copyWith(
        status: ResetPasswordRequestStatus.sendingCode,
        errorMessage: null,
      ),
    );

    final trimmedPhone = phone.value.trim();

    // First check if user exists for this phone number via API
    final existsResult = await checkUserExists(
      exists_usecase.CheckUserExistsParams(
        email: '', // Not used in this flow; backend can ignore empty email
        mobile: trimmedPhone,
      ),
    );

    var canProceed = false;
    existsResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ResetPasswordRequestStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (exists) {
        if (exists) {
          canProceed = true;
        } else {
          emit(
            state.copyWith(
              status: ResetPasswordRequestStatus.failure,
              errorMessage: 'auth.resetPassword.messages.userNotFound',
            ),
          );
        }
      },
    );

    if (!canProceed) return;

    try {
      final verificationId = await phoneAuth.sendCode(trimmedPhone);
      emit(
        state.copyWith(
          status: ResetPasswordRequestStatus.codeSent,
          verificationId: verificationId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordRequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

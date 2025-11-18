import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordWithPhone
    implements UseCase<bool, ResetPasswordWithPhoneParams> {
  final AuthRepository repository;

  ResetPasswordWithPhone(this.repository);

  @override
  Future<Either<Failure, bool>> call(ResetPasswordWithPhoneParams params) {
    return repository.resetPasswordWithPhone(
      phone: params.phone,
      newPassword: params.newPassword,
      firebaseIdToken: params.firebaseIdToken,
    );
  }
}

class ResetPasswordWithPhoneParams extends Equatable {
  final String phone;
  final String newPassword;
  final String firebaseIdToken;

  const ResetPasswordWithPhoneParams({
    required this.phone,
    required this.newPassword,
    required this.firebaseIdToken,
  });

  @override
  List<Object?> get props => [phone, newPassword, firebaseIdToken];
}

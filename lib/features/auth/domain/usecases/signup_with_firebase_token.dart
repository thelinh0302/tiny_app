import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class SignupWithFirebaseToken
    implements UseCase<bool, SignupWithFirebaseTokenParams> {
  final AuthRepository repository;

  SignupWithFirebaseToken(this.repository);

  @override
  Future<Either<Failure, bool>> call(SignupWithFirebaseTokenParams params) {
    return repository.signupWithFirebaseToken(
      fullName: params.fullName,
      email: params.email,
      mobile: params.mobile,
      dob: params.dob,
      password: params.password,
      firebaseIdToken: params.firebaseIdToken,
    );
  }
}

class SignupWithFirebaseTokenParams extends Equatable {
  final String fullName;
  final String email;
  final String mobile;
  final DateTime dob;
  final String password;
  final String firebaseIdToken;

  const SignupWithFirebaseTokenParams({
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.password,
    required this.firebaseIdToken,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    mobile,
    dob,
    password,
    firebaseIdToken,
  ];
}

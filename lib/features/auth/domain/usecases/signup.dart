import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class Signup implements UseCase<bool, SignupParams> {
  final AuthRepository repository;

  Signup(this.repository);

  @override
  Future<Either<Failure, bool>> call(SignupParams params) {
    return repository.signup(
      fullName: params.fullName,
      email: params.email,
      mobile: params.mobile,
      dob: params.dob,
      password: params.password,
    );
  }
}

class SignupParams extends Equatable {
  final String fullName;
  final String email;
  final String mobile;
  final DateTime dob;
  final String password;

  const SignupParams({
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, mobile, dob, password];
}

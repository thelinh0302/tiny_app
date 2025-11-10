import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithBiometrics implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  LoginWithBiometrics(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.loginWithBiometrics();
  }
}

class NoParamsBiometrics extends Equatable {
  @override
  List<Object?> get props => [];
}

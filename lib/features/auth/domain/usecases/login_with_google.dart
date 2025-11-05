import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogle implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.loginWithGoogle();
  }
}

class NoParamsGoogle extends Equatable {
  @override
  List<Object?> get props => [];
}

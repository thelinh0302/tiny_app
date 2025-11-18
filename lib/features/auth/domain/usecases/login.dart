import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class Login implements UseCase<bool, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, bool>> call(LoginParams params) async {
    return await repository.login(params.phone, params.password);
  }
}

class LoginParams extends Equatable {
  final String phone;
  final String password;

  const LoginParams({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

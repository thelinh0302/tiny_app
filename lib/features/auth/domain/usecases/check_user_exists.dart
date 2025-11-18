import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/core/usecases/usecase.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class CheckUserExists implements UseCase<bool, CheckUserExistsParams> {
  final AuthRepository repository;

  CheckUserExists(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckUserExistsParams params) async {
    return repository.checkUserExists(params.email, params.mobile);
  }
}

class CheckUserExistsParams extends Equatable {
  final String email;
  final String mobile;

  const CheckUserExistsParams({required this.email, required this.mobile});

  @override
  List<Object?> get props => [email, mobile];
}

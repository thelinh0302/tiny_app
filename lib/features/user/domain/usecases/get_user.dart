import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for getting a single user
/// Following Single Responsibility Principle
class GetUser implements UseCase<User, GetUserParams> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUser(params.userId);
  }
}

class GetUserParams extends Equatable {
  final int userId;

  const GetUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}

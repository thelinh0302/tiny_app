import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:finly_app/core/error/failures.dart';
import 'package:finly_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:finly_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, bool>> login(String email, String password) async {
    try {
      final ok = await remote.login(email, password);
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}

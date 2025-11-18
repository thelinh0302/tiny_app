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

  @override
  Future<Either<Failure, bool>> loginWithGoogle() async {
    try {
      final ok = await remote.loginWithGoogle();
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithFacebook() async {
    try {
      final ok = await remote.loginWithFacebook();
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> loginWithBiometrics() async {
    try {
      final ok = await remote.loginWithBiometrics();
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> signup({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
  }) async {
    try {
      final ok = await remote.signup(
        fullName: fullName,
        email: email,
        mobile: mobile,
        dob: dob,
        password: password,
      );
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> signupWithFirebaseToken({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
    required String firebaseIdToken,
  }) async {
    try {
      final ok = await remote.signupWithFirebaseToken(
        fullName: fullName,
        email: email,
        mobile: mobile,
        dob: dob,
        password: password,
        firebaseIdToken: firebaseIdToken,
      );
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPasswordWithPhone({
    required String phone,
    required String newPassword,
    required String firebaseIdToken,
  }) async {
    try {
      final ok = await remote.resetPasswordWithPhone(
        phone: phone,
        newPassword: newPassword,
        firebaseIdToken: firebaseIdToken,
      );
      return Right(ok);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUserExists(
    String email,
    String mobile,
  ) async {
    try {
      final exists = await remote.checkUserExists(email: email, mobile: mobile);
      return Right(exists);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}

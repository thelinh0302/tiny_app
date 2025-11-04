import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(String email, String password);

  Future<Either<Failure, bool>> signup({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
  });
}

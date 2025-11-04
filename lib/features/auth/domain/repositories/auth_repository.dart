import 'package:dartz/dartz.dart';
import 'package:finly_app/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(String email, String password);
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// User repository interface - Domain layer
/// Following Dependency Inversion Principle (SOLID)
/// Domain layer defines the contract, Data layer implements it
abstract class UserRepository {
  /// Get a single user by ID
  Future<Either<Failure, User>> getUser(int userId);

  /// Get list of all users
  Future<Either<Failure, List<User>>> getUsers();

  /// Create a new user
  Future<Either<Failure, User>> createUser(User user);
}

import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Following the Liskov Substitution Principle (SOLID)
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
    : super(message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
    : super(message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred'])
    : super(message);
}

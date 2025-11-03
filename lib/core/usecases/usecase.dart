import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// Following Interface Segregation Principle (SOLID)
/// Type parameters:
/// - Type: Return type of the use case
/// - Params: Parameters needed for the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case doesn't need parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

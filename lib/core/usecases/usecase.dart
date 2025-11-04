import 'package:dartz/dartz.dart';
import 'package:petapp/core/errors/failures.dart';

/// Base class for all use cases in the application
///
/// A use case represents a single business action
/// Type [Type] is the return type
/// Type [Params] is the input parameters type
abstract class UseCase<Type, Params> {
  /// Execute the use case
  ///
  /// Returns Either<Failure, Type>
  /// - Left: Failure if something went wrong
  /// - Right: Type if successful
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require any parameters
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// Placeholder class for use cases that don't need parameters
class NoParams {
  const NoParams();
}

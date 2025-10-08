import 'failures.dart';

/// Represents a failure that occurs when a user is not authorized to perform an action
class UnauthorizedFailure extends Failure {
  /// Creates an [UnauthorizedFailure] with an optional [message]
  const UnauthorizedFailure({String message = 'Unauthorized access'})
    : super(message: message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'UnauthorizedFailure(message: $message)';
}

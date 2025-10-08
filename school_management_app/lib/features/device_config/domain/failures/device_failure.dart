import 'package:school_management_app/core/errors/failures.dart';

/// Represents a failure related to device operations.
class DeviceFailure extends Failure {
  /// Creates a [DeviceFailure] with the given [message] and optional [code]
  const DeviceFailure({
    String message = 'A device-related error occurred',
    String? code,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'DeviceFailure(message: $message, code: $code)';
}

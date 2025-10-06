import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
  
  @override
  String toString() => message;
}

/// Server failure
class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection',
    super.code,
  }) : super(message: message);
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({
    String message = 'Authentication failed',
    super.code,
  }) : super(message: message);
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  
  const ValidationFailure({
    required super.message,
    super.code,
    this.errors,
  });
  
  @override
  List<Object?> get props => [message, code, errors];
}

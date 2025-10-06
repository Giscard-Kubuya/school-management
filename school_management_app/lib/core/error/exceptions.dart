/// Custom exceptions for the application

/// Base exception class for all application exceptions
class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final String? code;
  final dynamic data;

  AppException({
    required this.message,
    this.stackTrace,
    this.code,
    this.data,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown when there's an issue with the database
class DatabaseException extends AppException {
  DatabaseException({
    required String message,
    StackTrace? stackTrace,
    String? code,
    dynamic data,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

/// Exception thrown when a requested resource is not found
class NotFoundException extends AppException {
  NotFoundException({
    required String resource,
    String? id,
    StackTrace? stackTrace,
  }) : super(
          message: id != null 
              ? 'Resource not found: $resource with ID $id' 
              : 'Resource not found: $resource',
          stackTrace: stackTrace,
          code: 'not_found',
        );
}

/// Exception thrown when there's a validation error
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  ValidationException({
    required this.errors,
    String? message,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Validation failed',
          stackTrace: stackTrace,
          code: 'validation_error',
          data: errors,
        );

  /// Creates a validation exception from a map of field errors
  factory ValidationException.fromMap(Map<String, dynamic> errorMap) {
    final errors = <String, List<String>>{};
    
    errorMap.forEach((key, value) {
      if (value is String) {
        errors[key] = [value];
      } else if (value is List) {
        errors[key] = value.cast<String>();
      }
    });
    
    return ValidationException(errors: errors);
  }
}

/// Exception thrown when there's an authentication or authorization error
class AuthException extends AppException {
  AuthException({
    required String message,
    StackTrace? stackTrace,
    String? code = 'authentication_error',
    dynamic data,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

/// Exception thrown when there's a network-related error
class NetworkException extends AppException {
  final int? statusCode;

  NetworkException({
    required String message,
    this.statusCode,
    StackTrace? stackTrace,
    String? code = 'network_error',
    dynamic data,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

/// Exception thrown when there's a timeout
class TimeoutException extends AppException {
  TimeoutException({
    required String message,
    StackTrace? stackTrace,
    String? code = 'timeout',
    dynamic data,
  }) : super(
          message: message,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

/// Exception thrown when a feature is not implemented
class NotImplementedException extends AppException {
  NotImplementedException({
    String? feature,
    StackTrace? stackTrace,
  }) : super(
          message: feature != null 
              ? 'Feature not implemented: $feature' 
              : 'Not implemented',
          stackTrace: stackTrace,
          code: 'not_implemented',
        );
}

/// Exception thrown when there's a conflict (e.g., duplicate entry)
class ConflictException extends AppException {
  ConflictException({
    required String resource,
    String? field,
    dynamic value,
    StackTrace? stackTrace,
  }) : super(
          message: field != null && value != null
              ? 'Resource conflict: $resource with $field=$value already exists'
              : 'Resource conflict: $resource',
          stackTrace: stackTrace,
          code: 'conflict',
        );
}

/// Exception thrown when a request is not allowed
class ForbiddenException extends AppException {
  ForbiddenException({
    String? message = 'Access denied',
    StackTrace? stackTrace,
    String? code = 'forbidden',
    dynamic data,
  }) : super(
          message: message!,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

/// Exception thrown when a request is not authorized
class UnauthorizedException extends AppException {
  UnauthorizedException({
    String? message = 'Not authorized',
    StackTrace? stackTrace,
    String? code = 'unauthorized',
    dynamic data,
  }) : super(
          message: message!,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

/// Exception thrown when a request is invalid
class BadRequestException extends AppException {
  BadRequestException({
    String? message = 'Invalid request',
    StackTrace? stackTrace,
    String? code = 'bad_request',
    dynamic data,
  }) : super(
          message: message!,
          stackTrace: stackTrace,
          code: code,
          data: data,
        );
}

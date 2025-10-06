/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  final int? statusCode;
  
  const ServerException({
    required super.message,
    super.code,
    this.statusCode,
  });
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({
    String message = 'No internet connection',
    super.code,
  }) : super(message: message);
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
  });
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException({
    String message = 'Authentication failed',
    super.code,
  }) : super(message: message);
}

/// Validation exception
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;
  
  const ValidationException({
    required super.message,
    super.code,
    this.errors,
  });
}

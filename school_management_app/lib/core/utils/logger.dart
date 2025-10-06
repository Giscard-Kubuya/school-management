import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Log levels for consistent logging
abstract class LogLevel {
  static const int verbose = 500;
  static const int debug = 600;
  static const int info = 800;
  static const int warning = 900;
  static const int error = 1200;
  static const int severe = 1500;
}

/// A utility class for application-wide logging
class Logger {
  static const String _tag = 'SchoolManagement';
  static bool _isDebugMode = true;
  
  /// Initialize the logger with debug mode setting
  static void init({bool isDebug = true}) {
    _isDebugMode = isDebug;
  }
  
  /// Log a debug message
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_isDebugMode) return;
    
    final logTag = tag != null ? '$_tag - $tag' : _tag;
    
    if (kDebugMode) {
      developer.log(
        message,
        name: logTag,
        level: LogLevel.debug,
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Log an informational message
  static void info(String message, {String? tag}) {
    final logTag = tag != null ? '$_tag - $tag' : _tag;
    
    if (kDebugMode) {
      developer.log(
        message,
        name: logTag,
        level: LogLevel.info,
        time: DateTime.now(),
      );
    }
  }
  
  /// Log a warning message
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    final logTag = tag != null ? '$_tag - $tag' : _tag;
    
    if (kDebugMode) {
      developer.log(
        message,
        name: logTag,
        level: LogLevel.warning,
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Log an error message
  static void error(
    String message, {
    String? tag, 
    Object? error, 
    StackTrace? stackTrace,
    bool showInProduction = true,
  }) {
    final logTag = tag != null ? '$_tag - $tag' : _tag;
    
    // Always log errors in debug mode
    if (kDebugMode || showInProduction) {
      developer.log(
        message,
        name: logTag,
        level: LogLevel.error,
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Log a severe/critical error message
  static void severe(
    String message, {
    String? tag, 
    Object? error, 
    StackTrace? stackTrace,
  }) {
    final logTag = tag != null ? '$_tag - $tag' : _tag;
    
    // Always log severe errors
    developer.log(
      message,
      name: logTag,
      level: LogLevel.severe,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
    
    // In production, you might want to report this to a crash reporting service
    if (!kDebugMode) {
      // TODO: Implement crash reporting service integration
      // e.g., Firebase Crashlytics, Sentry, etc.
    }
  }
  
  /// Log a network request
  static void network(
    String url, {
    String method = 'GET',
    Map<String, dynamic>? request,
    dynamic response,
    int? statusCode,
    String? tag,
    Duration? duration,
  }) {
    if (!_isDebugMode) return;
    
    final logTag = tag != null ? '$_tag - $tag' : _tag;
    final buffer = StringBuffer();
    
    buffer.writeln('$method $url');
    
    if (statusCode != null) {
      buffer.writeln('Status: $statusCode');
    }
    
    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }
    
    if (request != null) {
      buffer.writeln('Request:');
      buffer.writeln(_formatJson(request));
    }
    
    if (response != null) {
      buffer.writeln('Response:');
      buffer.writeln(_formatJson(response));
    }
    
    developer.log(
      buffer.toString(),
      name: '$logTag - Network',
      level: 800, // INFO level
      time: DateTime.now(),
    );
  }
  
  /// Format JSON for logging
  static String _formatJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      }
      return data.toString();
    } catch (e) {
      return data.toString();
    }
  }
}

/// Extension to log any object
extension ObjectLogger on Object {
  /// Log this object as debug
  void logDebug({String? tag}) => Logger.debug(toString(), tag: tag);
  
  /// Log this object as info
  void logInfo({String? tag}) => Logger.info(toString(), tag: tag);
  
  /// Log this object as warning
  void logWarning({String? tag, Object? error, StackTrace? stackTrace}) => 
      Logger.warning(toString(), tag: tag, error: error, stackTrace: stackTrace);
  
  /// Log this object as error
  void logError({String? tag, Object? error, StackTrace? stackTrace, bool showInProduction = true}) => 
      Logger.error(
        toString(), 
        tag: tag, 
        error: error, 
        stackTrace: stackTrace,
        showInProduction: showInProduction,
      );
  
  /// Log this object as severe error
  void logSevere({String? tag, Object? error, StackTrace? stackTrace}) => 
      Logger.severe(toString(), tag: tag, error: error, stackTrace: stackTrace);
}

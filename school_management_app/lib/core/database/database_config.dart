import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

class DatabaseConfig {
  static const String _databaseName = 'school_management.db';
  static const int _databaseVersion = 1;

  /// Initializes the database with platform-specific configuration
  static Future<Database> initDatabase() async {
    // Initialize FFI for non-mobile platforms
    if (!kIsWeb && _isDesktop()) {
      ffi.sqfliteFfiInit();
      databaseFactory = ffi.databaseFactoryFfi;
    }

    final dbPath = await _getDatabasePath();
    return openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
      onConfigure: _onConfigure,
    );
  }

  /// Configures the database
  static Future<void> _onConfigure(Database db) async {
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Checks if the current platform is desktop (Windows, Linux, or macOS)
  static bool _isDesktop() {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Gets the database path based on the platform
  static Future<String> _getDatabasePath() async {
    if (kIsWeb) {
      // For web, we'll use a different storage mechanism
      throw UnsupportedError('Web platform is not supported for SQLite');
    }

    if (isDesktop()) {
      // For desktop, use the application documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();
      return path.join(documentsDirectory.path, _databaseName);
    } else {
      // For mobile, use the default database path
      final databasesPath = await getDatabasesPath();
      return path.join(databasesPath, _databaseName);
    }
  }

  /// Creates the database schema
  static Future<void> _createDb(Database db, int version) async {
    final batch = db.batch();
    
    // Create your tables here
    // Example:
    // await _createUserTable(batch);
    
    await batch.commit();
  }

  /// Handles database upgrades
  static Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < 2) {
      // Example: Add new tables or columns for version 2
    }
  }

  /// Checks if the current platform is desktop
  static bool isDesktop() {
    return !kIsWeb && (isWindows || isLinux || isMacOS);
  }

  /// Platform detection helpers
  static bool get isWindows => !kIsWeb && (isWindows || Platform.isWindows);
  static bool get isLinux => !kIsWeb && (isLinux || Platform.isLinux);
  static bool get isMacOS => !kIsWeb && (isMacOS || Platform.isMacOS);
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}

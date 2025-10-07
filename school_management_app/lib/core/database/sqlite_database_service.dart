import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:school_management_app/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

class SQLiteDatabaseService implements DatabaseService {
  static const String _databaseName = 'school_management.db';
  static const int _databaseVersion = 1;

  static SQLiteDatabaseService? _instance;
  static Database? _database;

  SQLiteDatabaseService._();

  factory SQLiteDatabaseService() {
    _instance ??= SQLiteDatabaseService._();
    return _instance!;
  }

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
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

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<String> _getDatabasePath() async {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not supported for SQLite');
    }

    if (_isDesktop()) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      return path.join(documentsDirectory.path, _databaseName);
    } else {
      final databasesPath = await getDatabasesPath();
      return path.join(databasesPath, _databaseName);
    }
  }

  Future<void> _createDb(Database db, int version) async {
    final batch = db.batch();

    // Create your tables here using batch operations
    // Example:
    // _createUserTable(batch);

    await batch.commit();
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < 2) {
      // Example: Add new tables or columns for version 2
    }
  }

  @override
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  @override
  Future<void> batchWrite(Function(Batch) operations) async {
    final db = await database;
    final batch = db.batch();
    operations(batch);
    await batch.commit();
  }

  bool _isDesktop() {
    return !kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  }
}

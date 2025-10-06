import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:school_management_app/core/data/database_schema.dart';
import 'package:school_management_app/core/utils/logger.dart';

/// A service class that handles all database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  // Use this getter to access the database instance
  static Database? get database => _database;

  // Private constructor
  DatabaseService._internal();

  // Factory constructor to return the same instance
  factory DatabaseService() => _instance;

  /// Initializes the database connection and runs migrations if needed
  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseSchema.databaseName);

    Logger.info('Initializing database at: $path');

    try {
      _database = await openDatabase(
        path,
        version: DatabaseSchema.version,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );

      // Verify all tables were created successfully
      await _verifyDatabaseSchema();

      return _database!;
    } catch (e) {
      Logger.error('Failed to initialize database: $e');
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  /// Called when the database is first created
  Future<void> _onCreate(Database db, int version) async {
    Logger.info('Creating database schema version $version');
    await _executeBatch(db, DatabaseSchema.initializationStatements);
  }

  /// Called when the database needs to be upgraded
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Logger.info('Upgrading database from version $oldVersion to $newVersion');

    // Handle database migrations based on version changes
    // Add migration logic here as needed

    // For now, we'll just recreate the database
    await _dropAllTables(db);
    await _onCreate(db, newVersion);
  }

  /// Configure database settings
  Future<void> _onConfigure(Database db) async {
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');

    // Enable write-ahead logging for better concurrency
    await db.execute('PRAGMA journal_mode=WAL');

    // Set busy timeout to handle database locks
    await db.execute('PRAGMA busy_timeout = 5000');
  }

  /// Verifies that all required tables exist in the database
  Future<void> _verifyDatabaseSchema() async {
    if (_database == null) {
      throw DatabaseException('Database not initialized');
    }

    final batch = _database!.batch();

    // Queue all table existence checks
    for (final query in DatabaseSchema.tableExistenceQueries.values) {
      batch.rawQuery(query);
    }

    try {
      final results = await batch.commit(noResult: false);

      // Check each table exists
      int index = 0;
      for (final tableName in DatabaseSchema.tableExistenceQueries.keys) {
        final result = results[index++] as List?;
        if (result == null || result.isEmpty) {
          throw DatabaseException(
            'Table $tableName does not exist in database',
          );
        }
      }

      Logger.info('Database schema verification successful');
    } catch (e) {
      Logger.error('Database schema verification failed: $e');
      rethrow;
    }
  }

  /// Drops all tables in the database (for testing/development)
  Future<void> _dropAllTables(Database db) async {
    final batch = db.batch();

    // Get all table names
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT IN ('sqlite_sequence', 'android_metadata')",
    );

    // Drop all tables
    for (final table in tables) {
      batch.execute('DROP TABLE IF EXISTS ${table['name']}');
    }

    await batch.commit(noResult: true);
    Logger.info('Dropped all tables');
  }

  /// Executes a batch of SQL statements
  Future<void> _executeBatch(Database db, List<String> statements) async {
    final batch = db.batch();

    for (final statement in statements) {
      batch.execute(statement);
    }

    await batch.commit(noResult: true);
  }

  // ==================== CRUD Operations ====================

  /// Generic insert operation
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final id = await _database!.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      Logger.error('Error inserting into $table: $e');
      throw DatabaseException('Failed to insert into $table: $e');
    }
  }

  /// Generic update operation
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      return await _database!.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Logger.error('Error updating $table: $e');
      throw DatabaseException('Failed to update $table: $e');
    }
  }

  /// Generic delete operation
  Future<int> delete(
    String table, {
    required String where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      return await _database!.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      Logger.error('Error deleting from $table: $e');
      throw DatabaseException('Failed to delete from $table: $e');
    }
  }

  /// Generic query operation
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
    try {
      return await _database!.query(
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
    } catch (e) {
      Logger.error('Error querying $table: $e');
      throw DatabaseException('Failed to query $table: $e');
    }
  }

  /// Executes a raw query
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    try {
      return await _database!.rawQuery(sql, arguments);
    } catch (e) {
      Logger.error('Error executing raw query: $e\nQuery: $sql');
      throw DatabaseException('Failed to execute raw query: $e');
    }
  }

  /// Executes a raw update/insert/delete query
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    try {
      return await _database!.rawUpdate(sql, arguments);
    } catch (e) {
      Logger.error('Error executing raw update: $e\nQuery: $sql');
      throw DatabaseException('Failed to execute raw update: $e');
    }
  }

  // ==================== Transaction Helpers ====================

  /// Runs the specified operations in a database transaction
  Future<T> runInTransaction<T>(Future<T> Function() action) async {
    return await _database!.transaction((txn) async {
      try {
        return await action();
      } catch (e) {
        Logger.error('Transaction failed: $e');
        rethrow;
      }
    });
  }

  // ==================== Database Maintenance ====================

  /// Closes the database connection
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
      Logger.info('Database connection closed');
    }
  }

  /// Deletes the database file
  Future<void> deleteDatabase() async {
    await close();
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseSchema.databaseName);

    try {
      // Use the database factory to delete the database
      await sqflite.databaseFactory.deleteDatabase(path);
      Logger.info('Database deleted successfully');
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to delete database: $e',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException('Failed to delete database: $e');
    }
  }

  /// Gets the current database version
  Future<int> getDatabaseVersion() async {
    final result = await _database!.rawQuery('PRAGMA user_version');
    return result.first['user_version'] as int;
  }

  /// Sets the database version
  Future<void> setDatabaseVersion(int version) async {
    await _database!.execute('PRAGMA user_version = $version');
  }

  // ==================== Helper Methods ====================

  /// Checks if a record exists in the specified table
  Future<bool> exists(
    String table, {
    required String where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final result = await _database!.query(
        table,
        columns: ['1'],
        where: where,
        whereArgs: whereArgs,
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      Logger.error('Error checking existence in $table: $e');
      throw DatabaseException('Failed to check existence in $table: $e');
    }
  }

  /// Counts the number of records in a table
  Future<int> count(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final result = await _database!.rawQuery(
        'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
        whereArgs,
      );

      return (result.first['count'] as int?) ?? 0;
    } catch (e) {
      Logger.error('Error counting records in $table: $e');
      throw DatabaseException('Failed to count records in $table: $e');
    }
  }

  /// Executes multiple SQL statements in a single transaction
  Future<void> executeBatch(List<String> statements) async {
    if (_database == null) {
      throw DatabaseException('Database not initialized');
    }

    final batch = _database!.batch();

    try {
      for (final statement in statements) {
        batch.execute(statement);
      }

      await batch.commit(noResult: true);
      Logger.info('Executed batch of ${statements.length} statements');
    } catch (e, stackTrace) {
      Logger.error(
        'Error executing batch: $e',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException('Failed to execute batch: $e');
    }
  }

  /// Executes an operation within a transaction that can be rolled back
  /// if an error occurs.
  ///
  /// [action] The operation to execute within the transaction
  /// Returns the result of the [action] if successful
  /// Throws [DatabaseException] if the database is not initialized
  /// or if the transaction fails
  Future<T> withSavepoint<T>(Future<T> Function() action) async {
    if (_database == null) {
      throw DatabaseException('Database not initialized');
    }

    Logger.debug('Starting database transaction');

    // Use the transaction method which handles begin/commit/rollback automatically
    return await _database!.transaction<T>((txn) async {
      try {
        final result = await action();
        Logger.debug('Transaction completed successfully');
        return result;
      } catch (e, stackTrace) {
        Logger.error(
          'Error in database transaction: $e',
          error: e,
          stackTrace: stackTrace,
        );
        // The transaction will be automatically rolled back when an exception is thrown
        rethrow;
      }
    });
  }
}

/// Exception thrown when a database operation fails
class DatabaseException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  DatabaseException(this.message, [this.stackTrace]);

  @override
  String toString() => 'DatabaseException: $message';
}

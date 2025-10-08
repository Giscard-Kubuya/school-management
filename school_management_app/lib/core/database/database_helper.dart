import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_tables.dart';
import 'schemas/index.dart';
import 'migrations/migration.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Add a flag to prevent concurrent initializations
  static bool _isInitializing = false;

  // Track if FFI has been initialized
  static bool _ffiInitialized = false;

  // Development flag - set to false in production
  static const bool _deleteDbOnInit = true; // Change to false for production

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      print(
        '🔍 Database instance already exists in DatabaseHelper, returning cached instance',
      );
      return _database!;
    }

    // Prevent concurrent initialization
    if (_isInitializing) {
      print('⏳ Database initialization already in progress, waiting...');
      // Wait for initialization to complete
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // After waiting, check if database is now available
      if (_database != null) {
        print('✅ Database ready after waiting');
        return _database!;
      }
    }

    _isInitializing = true;
    try {
      print('🔄 DatabaseHelper: Initializing new database...');
      _database = await _initDatabase();
      print('✅ DatabaseHelper: Database initialized successfully');
      return _database!;
    } finally {
      _isInitializing = false;
    }
  }

  Future<Database> _initDatabase() async {
    print('🔄 DatabaseHelper: Initializing database...');

    // Initialize FFI for non-Android/iOS platforms (only once)
    if (!_ffiInitialized &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      print(
        '🖥️  Initializing FFI for desktop platform (${Platform.operatingSystem})',
      );
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      _ffiInitialized = true;
    } else if (_ffiInitialized) {
      print('✅ FFI already initialized');
    } else {
      print(
        '📱 Using default SQLite implementation for ${Platform.operatingSystem}',
      );
    }

    // Database version - increment this when schema changes
    const currentDbVersion = 2;

    // Set up database directory
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbDirectory = Directory('${documentsDirectory.path}/school_man_core');

    // Create directory if it doesn't exist
    if (!await dbDirectory.exists()) {
      await dbDirectory.create(recursive: true);
      print('📁 Created database directory at: ${dbDirectory.path}');
    }

    final dbPath = '${dbDirectory.path}/school_management.db';
    print('📂 Database path: $dbPath');

    // Close any existing database connection
    if (_database != null) {
      print('🔒 Closing existing database connection...');
      await _database!.close();
      _database = null;
    }

    // In production, you might want to implement proper migrations instead of deleting
    // For development, we'll delete and recreate the database
    final dbFile = File(dbPath);
    if (_deleteDbOnInit && await dbFile.exists()) {
      print('⚠️  Database exists. Attempting to close and delete...');
      try {
        // First, try to close any existing connections
        try {
          final existingDb = await databaseFactory.openDatabase(dbPath);
          await existingDb.close();
          print('🔒 Closed existing database connection');
        } catch (e) {
          print('ℹ️  No existing connection to close or already closed');
        }

        // Wait a moment for the file handle to be released
        await Future.delayed(const Duration(milliseconds: 300));

        // Now try to delete
        await dbFile.delete();
        print('🗑️  Deleted existing database file');
      } catch (e) {
        print('❌ Error deleting database file: $e');
        print('ℹ️  Attempting to continue with existing database...');
        // Don't rethrow - try to work with existing database
      }
    } else if (!_deleteDbOnInit && await dbFile.exists()) {
      print('ℹ️  Database exists. Using existing database (delete disabled)');
    }

    // Open the database with error handling
    try {
      print('🔑 Opening database...');
      final db = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: currentDbVersion,
          onCreate: _createDb,
          onUpgrade: _upgradeDb,
          onConfigure: (db) async {
            await db.execute('PRAGMA foreign_keys = ON');
            print('🔑 Foreign keys enabled');
          },
        ),
      );

      print('✅ Database opened successfully');
      return db;
    } catch (e) {
      print('❌ Error opening database: $e');
      rethrow;
    }
  }

  Future<void> _createDb(Database db, int version) async {
    print('🏗️  Creating database tables...');
    final stopwatch = Stopwatch()..start();

    try {
      // Enable foreign keys
      await db.execute('PRAGMA foreign_keys = ON');

      // Create all tables in a transaction
      await db.transaction((txn) async {
        print('🔄 Starting table creation in transaction...');
        await _createUserTables(txn);
        await _createAcademicTables(txn);
        await _createAttendanceTables(txn);
        await _createAssignmentTables(txn);
        await _createGradeTables(txn);
        await _createFinancialTables(txn);
        await _createCommunicationTables(txn);
        await _createDocumentTables(txn);
        await _createSystemTables(txn);

        // Create indexes after all tables are created
        await _createIndexes(txn);
      });

      stopwatch.stop();
      print(
        '✅ Database tables created successfully in ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e) {
      stopwatch.stop();
      print('❌ Error creating database tables: $e');
      rethrow;
    }
  }

  Future<void> _createUserTables(dynamic db) async {
    await db.execute(UserSchemas.users);
    await db.execute(UserSchemas.userSessions);
    await db.execute(UserSchemas.administrators);
    await db.execute(UserSchemas.teachers);
    await db.execute(UserSchemas.students);
    await db.execute(UserSchemas.userRoles);
    await db.execute(UserSchemas.permissions);
    await db.execute(UserSchemas.userPermissions);
    await db.execute(UserSchemas.rolePermissions);
    await db.execute(UserSchemas.auditLogs);
    await db.execute(UserSchemas.passwordResetTokens);
    await db.execute(UserSchemas.userPreferences);
  }

  Future<void> _createAcademicTables(dynamic db) async {
    // Academic structure tables
    await db.execute(AcademicSchemas.universities);
    await db.execute(AcademicSchemas.faculties);
    await db.execute(AcademicSchemas.departments);
    await db.execute(AcademicSchemas.programs);
    await db.execute(AcademicSchemas.courses);
    await db.execute(AcademicSchemas.courseOfferings);
    await db.execute(AcademicSchemas.courseEnrollments);
    await db.execute(AcademicSchemas.coursePrerequisites);

    // Academic structure - physical locations
    await db.execute(AcademicSchemas.campuses);
    await db.execute(AcademicSchemas.buildings);
    await db.execute(AcademicSchemas.rooms);

    // Academic time-related tables
    await db.execute(AcademicSchemas.academicYears);
    await db.execute(AcademicSchemas.semesters);
  }

  Future<void> _createAttendanceTables(dynamic db) async {
    await db.execute(AttendanceSchemas.classSessions);
    await db.execute(AttendanceSchemas.attendanceRecords);
    await db.execute(AttendanceSchemas.attendanceExcuses);
  }

  Future<void> _createAssignmentTables(dynamic db) async {
    // Assignment related tables
    await db.execute(AssignmentSchemas.assignments);
    await db.execute(AssignmentSchemas.assignmentQuestions);
    await db.execute(AssignmentSchemas.assignmentRubrics);
    await db.execute(AssignmentSchemas.assignmentSubmissions);
    await db.execute(AssignmentSchemas.submissionFiles);
    await db.execute(AssignmentSchemas.rubricEvaluations);
  }

  Future<void> _createGradeTables(dynamic db) async {
    // Grade related tables
    await db.execute(GradeSchemas.gradeCategories);
    await db.execute(GradeSchemas.grades);
    await db.execute(GradeSchemas.gradeScales);
  }

  Future<void> _createFinancialTables(dynamic db) async {
    // Financial related tables
    await db.execute(FinancialSchemas.financialAccounts);
    await db.execute(FinancialSchemas.transactionCategories);
    await db.execute(FinancialSchemas.transactions);
    await db.execute(FinancialSchemas.tuitionFees);
    await db.execute(FinancialSchemas.paymentPlans);
    await db.execute(FinancialSchemas.paymentPlanInstallments);
    await db.execute(FinancialSchemas.paymentMethods);
    await db.execute(FinancialSchemas.feePayments);
    await db.execute(FinancialSchemas.documentPayments);
    await db.execute(FinancialSchemas.financialHistory);
    await db.execute(FinancialSchemas.withdrawalRequests);
  }

  Future<void> _createCommunicationTables(dynamic db) async {
    // Create only tables, not indexes (indexes are created separately in _createIndexes)
    for (final schema in CommunicationSchemas.all) {
      await db.execute(schema);
    }
  }

  Future<void> _createDocumentTables(dynamic db) async {
    // Document related tables
    await db.execute(DocumentSchemas.documentFolders);
    await db.execute(DocumentSchemas.documents);
    await db.execute(DocumentSchemas.courseMaterials);
    await db.execute(DocumentSchemas.documentDownloads);
    await db.execute(DocumentSchemas.documentPermissions);
    await db.execute(DocumentSchemas.documentVersions);
  }

  Future<void> _createSystemTables(dynamic db) async {
    // System related tables only
    await db.execute(SystemSchemas.deviceConfigurations);
    await db.execute(SystemSchemas.deviceRegistrations);
    await db.execute(SystemSchemas.pendingAccounts);
  }

  Future<void> _createIndexes(dynamic db) async {
    print('📊 Creating indexes for better query performance...');

    // Execute all schema indexes with IF NOT EXISTS handling
    await _executeSchemaIndexes(db, AcademicSchemas.indexes, 'Academic');
    await _executeSchemaIndexes(db, UserSchemas.additionalIndexes, 'User');
    await _executeSchemaIndexes(db, AttendanceSchemas.indexes, 'Attendance');
    await _executeSchemaIndexes(db, AssignmentSchemas.indexes, 'Assignment');
    await _executeSchemaIndexes(db, FinancialSchemas.indexes, 'Financial');
    await _executeSchemaIndexes(
      db,
      CommunicationSchemas.indexes,
      'Communication',
    );
    await _executeSchemaIndexes(db, DocumentSchemas.indexes, 'Document');
    await _executeSchemaIndexes(db, SystemSchemas.indexes, 'System');

    print('✅ All indexes created successfully');
  }

  Future<void> _executeSchemaIndexes(
    dynamic db,
    List<String> indexes,
    String schemaName,
  ) async {
    if (indexes.isNotEmpty) {
      print('📊 Creating $schemaName schema indexes...');
      for (final index in indexes) {
        try {
          // Add IF NOT EXISTS to prevent duplicate index errors
          String modifiedIndex = index;
          if (!index.toUpperCase().contains('IF NOT EXISTS')) {
            modifiedIndex = index.replaceFirst(
              RegExp(r'CREATE\s+INDEX\s+', caseSensitive: false),
              'CREATE INDEX IF NOT EXISTS ',
            );
          }
          await db.execute(modifiedIndex);
        } catch (e) {
          // Only log as warning, don't stop execution
          print(
            '⚠️  Could not create index (may already exist): ${e.toString().split('\n').first}',
          );
        }
      }
    }
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    print('🔄 Upgrading database from version $oldVersion to $newVersion');
    final stopwatch = Stopwatch()..start();
    try {
      // Use our migration system to handle the upgrade
      await MigrationHelper.runMigrations(db, oldVersion, newVersion);
      stopwatch.stop();
      print('✅ Database upgraded in ${stopwatch.elapsedMilliseconds}ms');
      if (oldVersion < 2 && newVersion >= 2) {
        // Example: Add new tables or columns for version 2
        print(
          'ℹ️  No migration needed from version $oldVersion to $newVersion',
        );
      }

      if (oldVersion < 3 && newVersion >= 3) {
        // Example: Add more changes for version 3
        print(
          'ℹ️  No migration needed from version $oldVersion to $newVersion',
        );
      }

      stopwatch.stop();
      print(
        '✅ Database upgraded to version $newVersion in ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e) {
      stopwatch.stop();
      print('❌ Error upgrading database: $e');
      rethrow;
    }
  }

  // Helper methods for common database operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

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

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> count(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
      print('🔒 Database closed');
    }
  }

  // Get the database path
  Future<String> getDatabasePath() async {
    final db = await database;
    return db.path;
  }

  // Check if database exists
  Future<bool> databaseExists() async {
    try {
      final path = await getDatabasePath();
      return await databaseFactory.databaseExists(path);
    } catch (e) {
      return false;
    }
  }

  // Reset database (for development/testing)
  Future<void> resetDatabase() async {
    print('🔄 Resetting database...');
    await close();
    _isInitializing = false; // Reset the flag

    // Wait for file handles to be released
    await Future.delayed(const Duration(milliseconds: 500));

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath =
        '${documentsDirectory.path}/school_man_core/school_management.db';
    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      try {
        await dbFile.delete();
        print('✅ Database reset complete');
      } catch (e) {
        print('❌ Error deleting database: $e');
        print('💡 Try stopping the app completely and running again');
        rethrow;
      }
    }
  }

  // Force delete database file (use with caution)
  Future<void> forceDeleteDatabase() async {
    print('🔄 Force deleting database...');

    // Close database
    await close();
    _isInitializing = false;

    // Wait longer for file handles
    await Future.delayed(const Duration(seconds: 2));

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath =
        '${documentsDirectory.path}/school_man_core/school_management.db';
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      try {
        await dbFile.delete();
        print('✅ Database force deleted successfully');
      } catch (e) {
        print('❌ Cannot force delete: $e');
        print('💡 The database file is locked by another process');
        print('💡 Close all app instances and try again');
        rethrow;
      }
    } else {
      print('ℹ️  Database file does not exist');
    }
  }
}

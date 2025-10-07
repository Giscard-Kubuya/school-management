import 'package:school_management_app/core/database/dao/user_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'database_service.dart';
import 'sqlite_database_service.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static Database? _database;

  // DAO instances
  late final UserDao userDao;
  late final DatabaseService _databaseService;

  factory DatabaseProvider() {
    return _instance;
  }

  DatabaseProvider._internal();

  Future<Database> get database async {
    if (_database != null) {
      print('✅ Database instance already exists, returning cached instance');
      return _database!;
    }
    print('🔄 Initializing new database instance...');
    _database = await DatabaseHelper().database;
    print('✅ Database instance created successfully');
    return _database!;
  }

  Future<void> init() async {
    print('🔄 Initializing DatabaseProvider...');
    await database; // Initialize database connection
    
    // Initialize database service
    print('🔄 Initializing DatabaseService...');
    _databaseService = SQLiteDatabaseService() as DatabaseService;

    // Initialize all DAOs
    print('🔄 Initializing UserDao...');
    userDao = UserDao(_databaseService);
    print('✅ DatabaseProvider initialization complete');

    // Initialize other DAOs here
    // courseDao = CourseDao();
    // enrollmentDao = EnrollmentDao();
    // etc.
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    final batch = db.batch();

    // Get all table names from the database
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name!='android_metadata' AND name!='sqlite_sequence'",
    );

    // Delete all data from each table
    for (final table in tables) {
      batch.delete(table['name'] as String);
    }

    await batch.commit();
  }

  Future<void> resetDatabase() async {
    final db = await database;
    final dbPath = db.path;
    await db.close();
    await deleteDatabase(dbPath);
    _database = null;
    await init();
  }
}

// Global database provider instance
final databaseProvider = DatabaseProvider();

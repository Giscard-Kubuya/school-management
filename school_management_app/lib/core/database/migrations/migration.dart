import 'package:school_management_app/core/database/database_tables.dart';
import 'package:sqflite/sqflite.dart';

abstract class Migration {
  /// The version this migration applies to
  int get version;

  /// The SQL statements to run when upgrading to this version
  Future<void> up(Database db, Transaction txn);

  /// The SQL statements to run when downgrading from this version
  Future<void> down(Database db, Transaction txn) async {}
}

class MigrationHelper {
  static Future<void> runMigrations(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < newVersion) {
      await db.transaction((txn) async {
        for (var version = oldVersion + 1; version <= newVersion; version++) {
          final migration = _getMigrationForVersion(version);
          if (migration != null) {
            print('🔄 Running migration to version $version');
            await migration.up(db, txn);
          }
        }
      });
    }
  }

  static Migration? _getMigrationForVersion(int version) {
    switch (version) {
      case 1:
        return MigrationV1();
      // Add more version migrations here as needed
      default:
        return null;
    }
  }
}

/// Initial database schema (version 1)
class MigrationV1 implements Migration {
  @override
  int get version => 1;

  @override
  Future<void> up(Database db, Transaction txn) async {
    // This is the initial schema creation which is handled by _createDb
    // No need to implement anything here as it's already handled in DatabaseHelper._createDb
  }

  @override
  Future<void> down(Database db, Transaction txn) async {
    // This would drop all tables if we need to rollback from version 1
    await txn.execute(
      'DROP TABLE IF EXISTS ${DatabaseTables.rubricEvaluations}',
    );
    await txn.execute('DROP TABLE IF EXISTS ${DatabaseTables.submissionFiles}');
    await txn.execute(
      'DROP TABLE IF EXISTS ${DatabaseTables.assignmentSubmissions}',
    );
    await txn.execute(
      'DROP TABLE IF EXISTS ${DatabaseTables.assignmentRubrics}',
    );
    await txn.execute(
      'DROP TABLE IF EXISTS ${DatabaseTables.assignmentQuestions}',
    );
    await txn.execute('DROP TABLE IF EXISTS ${DatabaseTables.assignments}');
  }
}

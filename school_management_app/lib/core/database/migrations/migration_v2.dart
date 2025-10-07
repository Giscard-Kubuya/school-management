import 'package:sqflite/sqflite.dart';
import 'package:school_management_app/core/database/database_tables.dart';
import 'package:school_management_app/core/database/migrations/migration.dart';
import 'data_migrations/assignment_data_migration.dart';

class MigrationV2 implements Migration {
  @override
  int get version => 2;

  @override
  Future<void> up(Database db, Transaction txn) async {
    // Run schema migrations first
    await _runSchemaMigrations(txn);

    // Then run data migrations
    await _runDataMigrations(db, txn);
  }

  Future<void> _runSchemaMigrations(Transaction txn) async {
    // Add new columns to assignments table
    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN university_id TEXT REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN teacher_id TEXT REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN instructions TEXT
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN weight_percentage REAL DEFAULT 10.00
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN available_from TEXT
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN available_until TEXT
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN late_submission_allowed INTEGER DEFAULT 0
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN late_penalty_percentage REAL DEFAULT 0.00
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN max_attempts INTEGER DEFAULT 1
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN time_limit_minutes INTEGER
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN allow_file_upload INTEGER DEFAULT 1
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN max_file_size_mb INTEGER DEFAULT 10
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN allowed_file_types TEXT
    ''');

    await txn.execute('''
      ALTER TABLE ${DatabaseTables.assignments}
      ADD COLUMN published_at TEXT
    ''');

    // Add sync metadata columns to all assignment-related tables
    for (final table in [
      DatabaseTables.assignments,
      DatabaseTables.assignmentQuestions,
      DatabaseTables.assignmentRubrics,
      DatabaseTables.assignmentSubmissions,
      DatabaseTables.submissionFiles,
    ]) {
      await _addSyncMetadataColumns(txn, table);
    }

    // Create the new rubric_evaluations table
    await txn.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTables.rubricEvaluations} (
        id TEXT PRIMARY KEY,
        university_id TEXT NOT NULL,
        submission_id TEXT NOT NULL,
        rubric_id TEXT NOT NULL,
        evaluator_id TEXT NOT NULL,
        score REAL NOT NULL,
        feedback TEXT,
        evaluated_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status TEXT DEFAULT 'synced',
        sync_version INTEGER DEFAULT 1,
        is_dirty INTEGER DEFAULT 0,
        last_synced_at TEXT,
        conflict_data TEXT,
        FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
        FOREIGN KEY (submission_id) REFERENCES ${DatabaseTables.assignmentSubmissions} (id) ON DELETE CASCADE,
        FOREIGN KEY (rubric_id) REFERENCES ${DatabaseTables.assignmentRubrics} (id) ON DELETE CASCADE,
        FOREIGN KEY (evaluator_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
      )
    ''');
    // Create indexes for better performance
    await txn.execute('''
      CREATE INDEX IF NOT EXISTS idx_assignments_university 
      ON ${DatabaseTables.assignments}(university_id)
    ''');

    await txn.execute('''
      CREATE INDEX IF NOT EXISTS idx_assignments_teacher 
      ON ${DatabaseTables.assignments}(teacher_id)
    ''');

    await txn.execute('''
      CREATE INDEX IF NOT EXISTS idx_rubric_evaluations_submission 
      ON ${DatabaseTables.rubricEvaluations}(submission_id)
    ''');

    await txn.execute('''
      CREATE INDEX IF NOT EXISTS idx_rubric_evaluations_rubric 
      ON ${DatabaseTables.rubricEvaluations}(rubric_id)
    ''');
  }

  Future<void> _runDataMigrations(Database db, Transaction txn) async {
    // Run assignment data migrations
    await AssignmentDataMigration.migrateAssignments(db);
  }

  Future<void> _addSyncMetadataColumns(Transaction txn, String table) async {
    // Check if sync_status column exists
    final result = await txn.rawQuery('PRAGMA table_info($table)');
    final hasSyncStatus = result.any(
      (column) => (column['name'] as String).toLowerCase() == 'sync_status',
    );

    if (!hasSyncStatus) {
      await txn.execute('''
        ALTER TABLE $table
        ADD COLUMN sync_status TEXT DEFAULT 'synced'
      ''');

      await txn.execute('''
        ALTER TABLE $table
        ADD COLUMN sync_version INTEGER DEFAULT 1
      ''');

      await txn.execute('''
        ALTER TABLE $table
        ADD COLUMN is_dirty INTEGER DEFAULT 0
      ''');

      await txn.execute('''
        ALTER TABLE $table
        ADD COLUMN last_synced_at TEXT
      ''');

      await txn.execute('''
        ALTER TABLE $table
        ADD COLUMN conflict_data TEXT
      ''');
    }
  }

  @override
  Future<void> down(Database db, Transaction txn) async {
    // Drop the new table
    await txn.execute(
      'DROP TABLE IF EXISTS ${DatabaseTables.rubricEvaluations}',
    );

    // Remove indexes
    await txn.execute('DROP INDEX IF EXISTS idx_assignments_university');
    await txn.execute('DROP INDEX IF EXISTS idx_assignments_teacher');
    await txn.execute('DROP INDEX IF EXISTS idx_rubric_evaluations_submission');
    await txn.execute('DROP INDEX IF EXISTS idx_rubric_evaluations_rubric');

    // Note: In SQLite, we can't easily remove columns, so we'll just document the changes
    // In a real production environment, you would need to create a new table and migrate data
  }
}

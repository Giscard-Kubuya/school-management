import 'package:sqflite/sqflite.dart';
import 'package:school_management_app/core/database/database_tables.dart';

class AssignmentDataMigration {
  /// Migrates existing assignment data to the new schema
  /// This should be called after the schema migration is complete
  static Future<void> migrateAssignments(Database db) async {
    await db.transaction((txn) async {
      // 1. Update existing assignments with default values for new columns
      await _migrateAssignmentsTable(txn);
      
      // 2. Add sync metadata to existing records
      await _addSyncMetadata(txn);
      
      // 3. Migrate any other related data as needed
      await _migrateRelatedData(txn);
    });
  }
  
  static Future<void> _migrateAssignmentsTable(Transaction txn) async {
    // For each assignment, set default values for new columns
    await txn.execute('''
      UPDATE ${DatabaseTables.assignments}
      SET 
        university_id = (
          SELECT university_id 
          FROM ${DatabaseTables.courseOfferings} 
          WHERE ${DatabaseTables.courseOfferings}.id = ${DatabaseTables.assignments}.course_offering_id
          LIMIT 1
        ),
        teacher_id = created_by,  // Default to creator as teacher
        weight_percentage = 10.0,  // Default weight
        late_submission_allowed = 0,  // Default to not allowing late submissions
        max_attempts = 1,  // Default to single attempt
        allow_file_upload = 1  // Default to allowing file uploads
      WHERE university_id IS NULL  // Only update if not already set
    ''');
  }
  
  static Future<void> _addSyncMetadata(Transaction txn) async {
    // Add sync metadata to all relevant tables
    final tables = [
      DatabaseTables.assignments,
      DatabaseTables.assignmentQuestions,
      DatabaseTables.assignmentRubrics,
      DatabaseTables.assignmentSubmissions,
      DatabaseTables.submissionFiles,
    ];
    
    for (final table in tables) {
      await txn.execute('''
        UPDATE $table 
        SET 
          sync_status = 'synced',
          sync_version = 1,
          is_dirty = 0,
          last_synced_at = datetime('now')
        WHERE sync_status IS NULL
      ''');
    }
  }
  
  static Future<void> _migrateRelatedData(Transaction txn) async {
    // Migrate any existing submission statuses to the new format if needed
    await txn.execute('''
      UPDATE ${DatabaseTables.assignmentSubmissions}
      SET submission_status = 
        CASE 
          WHEN status = 'submitted' THEN 'submitted'
          WHEN status = 'graded' THEN 'graded'
          WHEN status = 'returned' THEN 'returned'
          ELSE 'draft'
        END
      WHERE submission_status IS NULL
    ''');
    
    // Set is_late flag for existing late submissions
    await txn.execute('''
      UPDATE ${DatabaseTables.assignmentSubmissions} s
      SET is_late = 1
      FROM ${DatabaseTables.assignments} a
      WHERE s.assignment_id = a.id
        AND s.submitted_at > a.due_date
        AND s.submission_status = 'submitted'
        AND s.is_late = 0
    ''');
    
    // Set percentage for existing grades
    await txn.execute('''
      UPDATE ${DatabaseTables.assignmentSubmissions} s
      SET percentage = (s.grade * 100.0) / a.total_points
      FROM ${DatabaseTables.assignments} a
      WHERE s.assignment_id = a.id
        AND s.grade IS NOT NULL
        AND s.percentage IS NULL
    ''');
  }
}

/// Assignments Schema
/// 
/// Contains table definitions for assignment management:
/// - assignments
/// - assignment_questions
/// - assignment_rubrics
/// - assignment_submissions
/// - submission_files

class AssignmentsSchema {
  static const List<String> createTableStatements = [
    _createAssignmentsTable,
    _createAssignmentQuestionsTable,
    _createAssignmentRubricsTable,
    _createAssignmentSubmissionsTable,
    _createSubmissionFilesTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_assignments_course ON assignments(course_offering_id)',
    'CREATE INDEX idx_assignments_created_by ON assignments(created_by)',
    'CREATE INDEX idx_assignment_questions_assignment ON assignment_questions(assignment_id)',
    'CREATE INDEX idx_assignment_rubrics_assignment ON assignment_rubrics(assignment_id)',
    'CREATE INDEX idx_assignment_submissions_assignment ON assignment_submissions(assignment_id)',
    'CREATE INDEX idx_assignment_submissions_student ON assignment_submissions(student_id)',
    'CREATE INDEX idx_submission_files_submission ON submission_files(submission_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createAssignmentsTable = '''
    CREATE TABLE assignments (
      id TEXT PRIMARY KEY,
      course_offering_id TEXT NOT NULL,
      created_by TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      assignment_type TEXT NOT NULL, -- 'homework', 'project', 'essay', 'quiz', 'exam', etc.
      total_points REAL NOT NULL,
      due_date TEXT NOT NULL,
      submission_type TEXT NOT NULL, -- 'individual', 'group', 'both'
      max_attempts INTEGER DEFAULT 1,
      allow_late_submission INTEGER DEFAULT 0,
      late_submission_penalty REAL DEFAULT 0,
      is_published INTEGER DEFAULT 0,
      is_graded INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';

  static const String _createAssignmentQuestionsTable = '''
    CREATE TABLE assignment_questions (
      id TEXT PRIMARY KEY,
      assignment_id TEXT NOT NULL,
      question_text TEXT NOT NULL,
      question_type TEXT NOT NULL, -- 'multiple_choice', 'short_answer', 'essay', 'file_upload', 'code'
      points REAL NOT NULL,
      order_position INTEGER NOT NULL,
      correct_answer TEXT,
      options TEXT, -- JSON array for multiple choice options
      is_required INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
    )
  ''';

  static const String _createAssignmentRubricsTable = '''
    CREATE TABLE assignment_rubrics (
      id TEXT PRIMARY KEY,
      assignment_id TEXT NOT NULL,
      criteria TEXT NOT NULL,
      description TEXT,
      points_possible REAL NOT NULL,
      order_position INTEGER NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
    )
  ''';

  static const String _createAssignmentSubmissionsTable = '''
    CREATE TABLE assignment_submissions (
      id TEXT PRIMARY KEY,
      assignment_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      submission_text TEXT,
      submitted_at TEXT NOT NULL,
      submission_status TEXT NOT NULL, -- 'draft', 'submitted', 'late', 'graded', 'resubmitted'
      grade REAL,
      feedback TEXT,
      graded_by TEXT,
      graded_at TEXT,
      attempt_number INTEGER DEFAULT 1,
      is_plagiarized INTEGER DEFAULT 0,
      similarity_score REAL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (graded_by) REFERENCES users(id) ON DELETE SET NULL
    )
  ''';

  static const String _createSubmissionFilesTable = '''
    CREATE TABLE submission_files (
      id TEXT PRIMARY KEY,
      submission_id TEXT NOT NULL,
      file_name TEXT NOT NULL,
      file_path TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      file_type TEXT NOT NULL,
      upload_date TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (submission_id) REFERENCES assignment_submissions(id) ON DELETE CASCADE
    )
  ''';

  // Prevent instantiation
  AssignmentsSchema._();
}

import 'package:school_management_app/core/database/database_tables.dart';

class AssignmentSchemas {
  // Assignments table
  static const String assignments = '''
    CREATE TABLE ${DatabaseTables.assignments} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      teacher_id TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      instructions TEXT,
      assignment_type TEXT CHECK(assignment_type IN ('homework', 'quiz', 'exam', 'project', 'lab', 'essay')) DEFAULT 'homework',
      total_points REAL NOT NULL DEFAULT 100.00,
      weight_percentage REAL DEFAULT 10.00,
      due_date TEXT NOT NULL,
      available_from TEXT,
      available_until TEXT,
      late_submission_allowed INTEGER DEFAULT 0,
      late_penalty_percentage REAL DEFAULT 0.00,
      max_attempts INTEGER DEFAULT 1,
      time_limit_minutes INTEGER,
      allow_file_upload INTEGER DEFAULT 1,
      max_file_size_mb INTEGER DEFAULT 10,
      allowed_file_types TEXT,
      grading_type TEXT CHECK(grading_type IN ('manual', 'automatic', 'rubric')) DEFAULT 'manual',
      status TEXT CHECK(status IN ('draft', 'published', 'closed', 'grading', 'graded')) DEFAULT 'draft',
      published_at TEXT,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES ${DatabaseTables.courseOfferings} (id) ON DELETE CASCADE,
      FOREIGN KEY (teacher_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Assignment Questions table
  static const String assignmentQuestions = '''
    CREATE TABLE ${DatabaseTables.assignmentQuestions} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      assignment_id TEXT NOT NULL,
      question_text TEXT NOT NULL,
      question_type TEXT CHECK(question_type IN ('multiple_choice', 'true_false', 'short_answer', 'essay', 'matching', 'fill_blank')) NOT NULL,
      question_data TEXT, -- JSON string for question options, correct answers, etc.
      points REAL NOT NULL,
      order_number INTEGER NOT NULL,
      hint TEXT,
      explanation TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (assignment_id) REFERENCES ${DatabaseTables.assignments} (id) ON DELETE CASCADE
    )
  ''';

  // Assignment Rubrics table
  static const String assignmentRubrics = '''
    CREATE TABLE ${DatabaseTables.assignmentRubrics} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      assignment_id TEXT NOT NULL,
      criteria TEXT NOT NULL,
      criteria_type TEXT CHECK(criteria_type IN ('points', 'percentage', 'scale')) DEFAULT 'points',
      description TEXT,
      points_possible REAL NOT NULL,
      levels TEXT, -- JSON string for rubric levels (e.g., Excellent, Good, Fair, Poor)
      order_number INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (assignment_id) REFERENCES ${DatabaseTables.assignments} (id) ON DELETE CASCADE
    )
  ''';

  // Assignment Submissions table
  static const String assignmentSubmissions = '''
    CREATE TABLE ${DatabaseTables.assignmentSubmissions} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      assignment_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      attempt_number INTEGER DEFAULT 1,
      submission_text TEXT,
      submission_data TEXT, -- JSON string for structured data (quiz answers, etc.)
      submitted_at TEXT,
      submission_status TEXT CHECK(submission_status IN ('draft', 'submitted', 'late', 'graded', 'returned')) DEFAULT 'draft',
      is_late INTEGER DEFAULT 0,
      late_penalty_applied REAL DEFAULT 0.00,
      score REAL,
      percentage REAL,
      feedback TEXT,
      graded_by TEXT,
      graded_at TEXT,
      started_at TEXT,
      time_spent_minutes INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (assignment_id) REFERENCES ${DatabaseTables.assignments} (id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (graded_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL,
      UNIQUE(assignment_id, student_id, attempt_number)
    )
  ''';

  // Submission Files table
  static const String submissionFiles = '''
    CREATE TABLE ${DatabaseTables.submissionFiles} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      submission_id TEXT NOT NULL,
      file_name TEXT NOT NULL,
      file_url TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      file_type TEXT NOT NULL,
      mime_type TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (submission_id) REFERENCES ${DatabaseTables.assignmentSubmissions} (id) ON DELETE CASCADE
    )
  ''';

  // Rubric Evaluations table
  static const String rubricEvaluations = '''
    CREATE TABLE rubric_evaluations (
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
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_assignments_university ON ${DatabaseTables.assignments}(university_id)',
    'CREATE INDEX idx_assignments_offering ON ${DatabaseTables.assignments}(course_offering_id)',
    'CREATE INDEX idx_assignments_teacher ON ${DatabaseTables.assignments}(teacher_id)',
    'CREATE INDEX idx_assignments_status ON ${DatabaseTables.assignments}(status)',
    'CREATE INDEX idx_assignments_due_date ON ${DatabaseTables.assignments}(due_date)',
    'CREATE INDEX idx_assignment_questions_assignment ON ${DatabaseTables.assignmentQuestions}(assignment_id)',
    'CREATE INDEX idx_assignment_rubrics_assignment ON ${DatabaseTables.assignmentRubrics}(assignment_id)',
    'CREATE INDEX idx_assignment_submissions_assignment ON ${DatabaseTables.assignmentSubmissions}(assignment_id)',
    'CREATE INDEX idx_assignment_submissions_student ON ${DatabaseTables.assignmentSubmissions}(student_id)',
    'CREATE INDEX idx_submission_files_submission ON ${DatabaseTables.submissionFiles}(submission_id)',
    'CREATE INDEX idx_rubric_evaluations_submission ON rubric_evaluations(submission_id)',
    'CREATE INDEX idx_rubric_evaluations_rubric ON rubric_evaluations(rubric_id)',
  ];

  // All schema definitions
  static const List<String> all = [
    assignments,
    assignmentQuestions,
    assignmentRubrics,
    assignmentSubmissions,
    submissionFiles,
    rubricEvaluations,
    ...indexes,
  ];
}

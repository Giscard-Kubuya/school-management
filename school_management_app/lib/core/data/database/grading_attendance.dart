/// Grading and Attendance Schema
/// 
/// Contains table definitions for:
/// - grade_scales
/// - grade_categories
/// - grades
/// - attendance
/// - attendance_codes

class GradingAttendanceSchema {
  static const List<String> createTableStatements = [
    _createGradeScalesTable,
    _createGradeCategoriesTable,
    _createGradesTable,
    _createAttendanceTable,
    _createAttendanceCodesTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_grade_scales_university ON grade_scales(university_id)',
    'CREATE INDEX idx_grade_categories_scale ON grade_categories(grade_scale_id)',
    'CREATE INDEX idx_grades_student ON grades(student_id)',
    'CREATE INDEX idx_grades_course ON grades(course_offering_id)',
    'CREATE INDEX idx_attendance_student ON attendance(student_id)',
    'CREATE INDEX idx_attendance_course ON attendance(course_offering_id)',
    'CREATE INDEX idx_attendance_codes_university ON attendance_codes(university_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createGradeScalesTable = '''
    CREATE TABLE grade_scales (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      is_default INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(university_id, name)
    )
  ''';

  static const String _createGradeCategoriesTable = '''
    CREATE TABLE grade_categories (
      id TEXT PRIMARY KEY,
      grade_scale_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      weight REAL NOT NULL,
      is_final_grade INTEGER DEFAULT 0,
      order_position INTEGER NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (grade_scale_id) REFERENCES grade_scales(id) ON DELETE CASCADE,
      UNIQUE(grade_scale_id, name)
    )
  ''';

  static const String _createGradesTable = '''
    CREATE TABLE grades (
      id TEXT PRIMARY KEY,
      student_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      grade_category_id TEXT,
      assignment_id TEXT,
      grade REAL NOT NULL,
      max_grade REAL NOT NULL,
      is_exempt INTEGER DEFAULT 0,
      is_dropped INTEGER DEFAULT 0,
      is_extra_credit INTEGER DEFAULT 0,
      notes TEXT,
      entered_by TEXT NOT NULL,
      entered_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
      FOREIGN KEY (grade_category_id) REFERENCES grade_categories(id) ON DELETE SET NULL,
      FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
      FOREIGN KEY (entered_by) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';

  static const String _createAttendanceTable = '''
    CREATE TABLE attendance (
      id TEXT PRIMARY KEY,
      student_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      session_id TEXT,
      attendance_date TEXT NOT NULL,
      status_code TEXT NOT NULL, -- 'present', 'absent', 'late', 'excused', 'tardy'
      minutes_late INTEGER DEFAULT 0,
      notes TEXT,
      recorded_by TEXT NOT NULL,
      recorded_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
      FOREIGN KEY (session_id) REFERENCES course_sessions(id) ON DELETE SET NULL,
      FOREIGN KEY (recorded_by) REFERENCES users(id) ON DELETE CASCADE,
      UNIQUE(student_id, course_offering_id, session_id, attendance_date)
    )
  ''';

  static const String _createAttendanceCodesTable = '''
    CREATE TABLE attendance_codes (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      code TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      is_present INTEGER DEFAULT 0,
      is_absent INTEGER DEFAULT 0,
      is_tardy INTEGER DEFAULT 0,
      is_excused INTEGER DEFAULT 0,
      affects_grade INTEGER DEFAULT 0,
      is_default INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(university_id, code)
    )
  ''';

  // Prevent instantiation
  GradingAttendanceSchema._();
}

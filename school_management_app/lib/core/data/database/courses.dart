/// Courses Schema
/// 
/// Contains table definitions for course management:
/// - courses
/// - course_prerequisites
/// - course_offerings
/// - course_enrollments
/// - course_sessions

class CoursesSchema {
  static const List<String> createTableStatements = [
    _createCoursesTable,
    _createCoursePrerequisitesTable,
    _createCourseOfferingsTable,
    _createCourseEnrollmentsTable,
    _createCourseSessionsTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_courses_department ON courses(department_id)',
    'CREATE INDEX idx_courses_code ON courses(code)',
    'CREATE INDEX idx_course_prereqs_course ON course_prerequisites(course_id)',
    'CREATE INDEX idx_course_offerings_course ON course_offerings(course_id)',
    'CREATE INDEX idx_course_offerings_semester ON course_offerings(semester_id)',
    'CREATE INDEX idx_course_enrollments_offering ON course_enrollments(course_offering_id)',
    'CREATE INDEX idx_course_enrollments_student ON course_enrollments(student_id)',
    'CREATE INDEX idx_course_sessions_offering ON course_sessions(course_offering_id)',
    'CREATE INDEX idx_course_sessions_teacher ON course_sessions(teacher_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createCoursesTable = '''
    CREATE TABLE courses (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      department_id TEXT NOT NULL,
      code TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      credit_hours INTEGER NOT NULL,
      lecture_hours INTEGER DEFAULT 0,
      lab_hours INTEGER DEFAULT 0,
      tutorial_hours INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
      UNIQUE(university_id, code)
    )
  ''';

  static const String _createCoursePrerequisitesTable = '''
    CREATE TABLE course_prerequisites (
      id TEXT PRIMARY KEY,
      course_id TEXT NOT NULL,
      prerequisite_course_id TEXT NOT NULL,
      is_mandatory INTEGER DEFAULT 1,
      minimum_grade TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
      FOREIGN KEY (prerequisite_course_id) REFERENCES courses(id) ON DELETE CASCADE,
      UNIQUE(course_id, prerequisite_course_id)
    )
  ''';

  static const String _createCourseOfferingsTable = '''
    CREATE TABLE course_offerings (
      id TEXT PRIMARY KEY,
      course_id TEXT NOT NULL,
      semester_id TEXT NOT NULL,
      section TEXT NOT NULL,
      capacity INTEGER NOT NULL,
      enrolled_count INTEGER DEFAULT 0,
      waitlist_capacity INTEGER DEFAULT 0,
      waitlist_count INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      registration_start_date TEXT,
      registration_end_date TEXT,
      withdrawal_deadline TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
      FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE,
      UNIQUE(course_id, semester_id, section)
    )
  ''';

  static const String _createCourseEnrollmentsTable = '''
    CREATE TABLE course_enrollments (
      id TEXT PRIMARY KEY,
      course_offering_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      enrollment_type TEXT NOT NULL, -- 'regular', 'audit', 'credit'
      enrollment_status TEXT NOT NULL, -- 'enrolled', 'waitlisted', 'dropped', 'completed'
      enrollment_date TEXT NOT NULL,
      withdrawal_date TEXT,
      final_grade TEXT,
      grade_points REAL,
      is_grade_posted INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
      UNIQUE(course_offering_id, student_id)
    )
  ''';

  static const String _createCourseSessionsTable = '''
    CREATE TABLE course_sessions (
      id TEXT PRIMARY KEY,
      course_offering_id TEXT NOT NULL,
      teacher_id TEXT NOT NULL,
      session_type TEXT NOT NULL, -- 'lecture', 'lab', 'tutorial', 'exam'
      title TEXT,
      description TEXT,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      location TEXT,
      is_cancelled INTEGER DEFAULT 0,
      cancellation_reason TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
      FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';

  // Prevent instantiation
  CoursesSchema._();
}

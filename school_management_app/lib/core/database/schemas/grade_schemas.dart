import 'package:school_management_app/core/database/database_tables.dart';

class GradeSchemas {
  // Grade Categories table
  static const String gradeCategories = '''
    CREATE TABLE ${DatabaseTables.gradeCategories} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      weight DECIMAL(5,2) NOT NULL,
      drop_lowest INTEGER DEFAULT 0,
      is_extra_credit INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
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
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL
    )
  ''';

  // Grades table
  static const String grades = '''
    CREATE TABLE ${DatabaseTables.grades} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      course_enrollment_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      teacher_id TEXT NOT NULL,
      grade_category_id TEXT,
      grade_item_name TEXT,
      grade_item_type TEXT CHECK(grade_item_type IN ('assignment', 'quiz', 'exam', 'participation', 'project', 'other')) DEFAULT 'other',
      points_earned DECIMAL(5,2),
      points_possible DECIMAL(5,2) NOT NULL,
      percentage DECIMAL(5,2),
      letter_grade TEXT,
      grade_points DECIMAL(3,2),
      weight DECIMAL(5,2) DEFAULT 1.00,
      comments TEXT,
      grade_status TEXT CHECK(grade_status IN ('draft', 'posted', 'final')) DEFAULT 'draft',
      graded_at TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (course_enrollment_id) REFERENCES ${DatabaseTables.courseEnrollments} (id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (teacher_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (grade_category_id) REFERENCES ${DatabaseTables.gradeCategories} (id) ON DELETE SET NULL
    )
  ''';

  // Grade Scales table
  static const String gradeScales = '''
    CREATE TABLE ${DatabaseTables.gradeScales} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      is_default INTEGER DEFAULT 0,
      scale_data TEXT NOT NULL, -- JSON string containing grade scale data
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_grades_student_id ON ${DatabaseTables.grades}(student_id)',
    'CREATE INDEX idx_grades_course_enrollment_id ON ${DatabaseTables.grades}(course_enrollment_id)',
    'CREATE INDEX idx_grades_grade_status ON ${DatabaseTables.grades}(grade_status)',
    'CREATE INDEX idx_grade_categories_course_offering_id ON ${DatabaseTables.gradeCategories}(course_offering_id)',
    'CREATE INDEX idx_grade_scales_university_id ON ${DatabaseTables.gradeScales}(university_id)',
  ];

  // All schema definitions
  static const List<String> all = [
    gradeCategories,
    grades,
    gradeScales,
    ...indexes,
  ];
}

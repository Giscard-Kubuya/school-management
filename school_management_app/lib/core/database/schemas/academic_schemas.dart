import 'package:school_management_app/core/database/database_tables.dart';

class AcademicSchemas {
  // Universities table
  static const String universities =
      '''
    CREATE TABLE ${DatabaseTables.universities} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      code TEXT NOT NULL UNIQUE,
      country TEXT NOT NULL,
      state TEXT,
      city TEXT NOT NULL,
      address TEXT,
      postal_code TEXT,
      phone TEXT,
      email TEXT,
      website TEXT,
      type TEXT DEFAULT 'public',
      established_year INTEGER,
      accreditation TEXT,
      logo_url TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  // Faculties table
  static const String faculties =
      '''
    CREATE TABLE ${DatabaseTables.faculties} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      dean_name TEXT,
      dean_email TEXT,
      dean_phone TEXT,
      description TEXT,
      established_year INTEGER,
      building_location TEXT,
      office_number TEXT,
      phone TEXT,
      email TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      UNIQUE(university_id, code)
    )
  ''';

  // Departments table
  static const String departments =
      '''
    CREATE TABLE ${DatabaseTables.departments} (
      id TEXT PRIMARY KEY,
      faculty_id TEXT NOT NULL,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      head_teacher_id TEXT,
      description TEXT,
      phone TEXT,
      email TEXT,
      office_location TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (faculty_id) REFERENCES ${DatabaseTables.faculties} (id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (head_teacher_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL,
      UNIQUE(faculty_id, code)
    )
  ''';

  // Programs table
  static const String programs =
      '''
    CREATE TABLE ${DatabaseTables.programs} (
      id TEXT PRIMARY KEY,
      department_id TEXT NOT NULL,
      faculty_id TEXT NOT NULL,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      level TEXT NOT NULL,
      duration_years REAL DEFAULT 4.0,
      duration_semesters INTEGER DEFAULT 8,
      total_credits_required REAL DEFAULT 120.0,
      description TEXT,
      requirements TEXT,
      entrance_requirements TEXT,
      career_prospects TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (department_id) REFERENCES ${DatabaseTables.departments} (id) ON DELETE CASCADE,
      FOREIGN KEY (faculty_id) REFERENCES ${DatabaseTables.faculties} (id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      UNIQUE(department_id, code)
    )
  ''';

  // Courses table
  static const String courses =
      '''
    CREATE TABLE ${DatabaseTables.courses} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      department_id TEXT NOT NULL,
      program_id TEXT,
      course_code TEXT NOT NULL,
      course_name TEXT NOT NULL,
      description TEXT,
      objectives TEXT,
      learning_outcomes TEXT,
      credits INTEGER NOT NULL DEFAULT 3,
      lecture_hours INTEGER DEFAULT 3,
      lab_hours INTEGER DEFAULT 0,
      tutorial_hours INTEGER DEFAULT 0,
      course_level TEXT DEFAULT 'undergraduate',
      year_level INTEGER,
      course_type TEXT DEFAULT 'core',
      syllabus_file TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (department_id) REFERENCES ${DatabaseTables.departments}(id) ON DELETE CASCADE,
      FOREIGN KEY (program_id) REFERENCES ${DatabaseTables.programs}(id) ON DELETE SET NULL,
      UNIQUE(university_id, course_code)
    )
  ''';

  // Course Offerings table
  static const String courseOfferings =
      '''
    CREATE TABLE ${DatabaseTables.courseOfferings} (
      id TEXT PRIMARY KEY,
      course_id TEXT NOT NULL,
      academic_year_id TEXT NOT NULL,
      semester_id TEXT NOT NULL,
      instructor_id TEXT NOT NULL,
      section TEXT NOT NULL,
      capacity INTEGER NOT NULL,
      enrolled_count INTEGER DEFAULT 0,
      status TEXT NOT NULL CHECK(status IN ('draft', 'scheduled', 'in_progress', 'completed', 'cancelled')),
      room_id TEXT,
      schedule_json TEXT,
      min_students INTEGER DEFAULT 5,
      max_students INTEGER,
      teaching_method TEXT,
      assessment_methods TEXT,
      is_online INTEGER DEFAULT 0,
      online_platform TEXT,
      online_meeting_url TEXT,
      notes TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_by TEXT,
      updated_by TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_id) REFERENCES ${DatabaseTables.courses} (id) ON DELETE CASCADE,
      FOREIGN KEY (academic_year_id) REFERENCES ${DatabaseTables.academicYears} (id) ON DELETE CASCADE,
      FOREIGN KEY (semester_id) REFERENCES ${DatabaseTables.semesters} (id) ON DELETE CASCADE,
      FOREIGN KEY (instructor_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE RESTRICT,
      FOREIGN KEY (room_id) REFERENCES ${DatabaseTables.rooms} (id) ON DELETE SET NULL,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL,
      FOREIGN KEY (updated_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL,
      UNIQUE(course_id, academic_year_id, semester_id, section)
    )
  ''';

  // Course Enrollments table
  static const String courseEnrollments =
      '''
    CREATE TABLE ${DatabaseTables.courseEnrollments} (
      id TEXT PRIMARY KEY,
      course_offering_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      enrollment_date TEXT NOT NULL,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (course_offering_id) REFERENCES ${DatabaseTables.courseOfferings} (id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      UNIQUE(course_offering_id, student_id)
    )
  ''';

  // Course Prerequisites table
  static const String coursePrerequisites =
      '''
    CREATE TABLE ${DatabaseTables.coursePrerequisites} (
      id TEXT PRIMARY KEY,
      course_id TEXT NOT NULL,
      prerequisite_course_id TEXT NOT NULL,
      is_mandatory INTEGER DEFAULT 1,
      minimum_grade TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (course_id) REFERENCES ${DatabaseTables.courses} (id) ON DELETE CASCADE,
      FOREIGN KEY (prerequisite_course_id) REFERENCES ${DatabaseTables.courses} (id) ON DELETE CASCADE,
      UNIQUE(course_id, prerequisite_course_id)
    )
  ''';

  // Campuses table
  static const String campuses =
      '''
    CREATE TABLE ${DatabaseTables.campuses} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT,
      address TEXT,
      city TEXT,
      state TEXT,
      country TEXT,
      postal_code TEXT,
      phone_number TEXT,
      email TEXT,
      website TEXT,
      is_main_campus INTEGER DEFAULT 0,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE
    )
  ''';

  // Buildings table
  static const String buildings =
      '''
    CREATE TABLE ${DatabaseTables.buildings} (
      id TEXT PRIMARY KEY,
      campus_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT,
      address TEXT,
      floors INTEGER,
      has_elevator INTEGER DEFAULT 0,
      is_accessible INTEGER DEFAULT 1,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (campus_id) REFERENCES ${DatabaseTables.campuses} (id) ON DELETE CASCADE
    )
  ''';

  // Rooms table
  static const String rooms =
      '''
    CREATE TABLE ${DatabaseTables.rooms} (
      id TEXT PRIMARY KEY,
      building_id TEXT NOT NULL,
      room_number TEXT NOT NULL,
      floor INTEGER,
      capacity INTEGER,
      room_type TEXT NOT NULL,
      has_projector INTEGER DEFAULT 0,
      has_whiteboard INTEGER DEFAULT 1,
      has_air_conditioning INTEGER DEFAULT 0,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (building_id) REFERENCES ${DatabaseTables.buildings} (id) ON DELETE CASCADE,
      UNIQUE(building_id, room_number)
    )
  ''';

  static const String academicYears =
      '''
    CREATE TABLE ${DatabaseTables.academicYears} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL,
      status TEXT DEFAULT 'upcoming' CHECK(status IN ('upcoming', 'active', 'completed', 'archived')),
      is_current INTEGER DEFAULT 0,
      description TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      UNIQUE(university_id, name)
    )
  ''';

  static const String semesters =
      '''
    CREATE TABLE ${DatabaseTables.semesters} (
      id TEXT PRIMARY KEY,
      academic_year_id TEXT NOT NULL,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      semester_number INTEGER NOT NULL,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL,
      registration_start_date TEXT,
      registration_end_date TEXT,
      add_drop_deadline TEXT,
      withdrawal_deadline TEXT,
      status TEXT DEFAULT 'upcoming' CHECK(status IN ('upcoming', 'registration', 'active', 'completed', 'archived')),
      is_current INTEGER DEFAULT 0,
      description TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (academic_year_id) REFERENCES ${DatabaseTables.academicYears} (id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      UNIQUE(academic_year_id, semester_number)
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX IF NOT EXISTS idx_courses_department_id ON ${DatabaseTables.courses}(department_id)',
    'CREATE INDEX IF NOT EXISTS idx_course_offerings_course_id ON ${DatabaseTables.courseOfferings}(course_id)',
    'CREATE INDEX IF NOT EXISTS idx_course_offerings_academic_year_id ON ${DatabaseTables.courseOfferings}(academic_year_id)',
    'CREATE INDEX IF NOT EXISTS idx_course_offerings_semester_id ON ${DatabaseTables.courseOfferings}(semester_id)',
    'CREATE INDEX IF NOT EXISTS idx_course_enrollments_course_offering_id ON ${DatabaseTables.courseEnrollments}(course_offering_id)',
    'CREATE INDEX IF NOT EXISTS idx_course_enrollments_student_id ON ${DatabaseTables.courseEnrollments}(student_id)',
  ];

  static const List<String> all = [
    campuses,
    buildings,
    rooms,
    academicYears,
    semesters,
  ];
  
  // Combine all SQL statements including indexes
  static List<String> get allWithIndexes => [...all, ...indexes];
}

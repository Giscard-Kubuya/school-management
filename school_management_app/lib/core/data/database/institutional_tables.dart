/// Institutional Tables Schema
///
/// Contains table definitions for the institutional hierarchy:
/// - universities (root entity)
/// - faculties
/// - departments
/// - programs

class InstitutionalTablesSchema {
  static const List<String> createTableStatements = [
    _createUniversitiesTable,
    _createFacultiesTable,
    _createDepartmentsTable,
    _createProgramsTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_universities_active ON universities(is_active)',
    'CREATE INDEX idx_universities_code ON universities(code)',
    'CREATE INDEX idx_faculties_university ON faculties(university_id)',
    'CREATE INDEX idx_faculties_active ON faculties(is_active)',
    'CREATE INDEX idx_departments_faculty ON departments(faculty_id)',
    'CREATE INDEX idx_departments_university ON departments(university_id)',
    'CREATE INDEX idx_programs_department ON programs(department_id)',
    'CREATE INDEX idx_programs_faculty ON programs(faculty_id)',
    'CREATE INDEX idx_programs_university ON programs(university_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createUniversitiesTable = '''
    CREATE TABLE universities (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      code TEXT UNIQUE NOT NULL,
      description TEXT,
      address TEXT,
      phone TEXT,
      email TEXT,
      website TEXT,
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

  static const String _createFacultiesTable = '''
    CREATE TABLE faculties (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      description TEXT,
      dean_id TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (dean_id) REFERENCES users(id) ON DELETE SET NULL
    )
  ''';

  static const String _createDepartmentsTable = '''
    CREATE TABLE departments (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      faculty_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      description TEXT,
      head_id TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
      FOREIGN KEY (head_id) REFERENCES users(id) ON DELETE SET NULL
    )
  ''';

  static const String _createProgramsTable = '''
    CREATE TABLE programs (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      faculty_id TEXT NOT NULL,
      department_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      description TEXT,
      degree_type TEXT NOT NULL,
      duration_years INTEGER NOT NULL,
      credit_hours INTEGER NOT NULL,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
      FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE
    )
  ''';

  // Prevent instantiation
  InstitutionalTablesSchema._();
}

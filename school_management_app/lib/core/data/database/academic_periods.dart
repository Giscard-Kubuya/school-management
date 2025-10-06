/// Academic Periods Schema
/// 
/// Contains table definitions for academic time organization:
/// - academic_years
/// - semesters
/// - terms
/// - academic_breaks

class AcademicPeriodsSchema {
  static const List<String> createTableStatements = [
    _createAcademicYearsTable,
    _createSemestersTable,
    _createTermsTable,
    _createAcademicBreaksTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_academic_years_university ON academic_years(university_id)',
    'CREATE INDEX idx_academic_years_current ON academic_years(is_current)',
    'CREATE INDEX idx_semesters_academic_year ON semesters(academic_year_id)',
    'CREATE INDEX idx_semesters_current ON semesters(is_current)',
    'CREATE INDEX idx_terms_semester ON terms(semester_id)',
    'CREATE INDEX idx_terms_current ON terms(is_current)',
    'CREATE INDEX idx_academic_breaks_academic_year ON academic_breaks(academic_year_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createAcademicYearsTable = '''
    CREATE TABLE academic_years (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL,
      is_current INTEGER DEFAULT 0,
      registration_deadline TEXT,
      withdrawal_deadline TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE
    )
  ''';

  static const String _createSemestersTable = '''
    CREATE TABLE semesters (
      id TEXT PRIMARY KEY,
      academic_year_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL,
      is_current INTEGER DEFAULT 0,
      registration_deadline TEXT,
      withdrawal_deadline TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE
    )
  ''';

  static const String _createTermsTable = '''
    CREATE TABLE terms (
      id TEXT PRIMARY KEY,
      semester_id TEXT NOT NULL,
      name TEXT NOT NULL,
      code TEXT NOT NULL,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL,
      is_current INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE
    )
  ''';

  static const String _createAcademicBreaksTable = '''
    CREATE TABLE academic_breaks (
      id TEXT PRIMARY KEY,
      academic_year_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL,
      is_holiday INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE
    )
  ''';

  // Prevent instantiation
  AcademicPeriodsSchema._();
}

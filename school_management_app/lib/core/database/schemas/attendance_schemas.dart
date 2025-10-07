import 'package:school_management_app/core/database/database_tables.dart';

class AttendanceSchemas {
  // Class Sessions table
  static const String classSessions = '''
    CREATE TABLE ${DatabaseTables.classSessions} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      room_id TEXT,
      title TEXT NOT NULL,
      description TEXT,
      session_date TEXT NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      session_type TEXT CHECK(session_type IN ('lecture', 'lab', 'seminar', 'exam', 'makeup', 'other')) DEFAULT 'lecture',
      status TEXT CHECK(status IN ('scheduled', 'completed', 'cancelled', 'postponed')) DEFAULT 'scheduled',
      is_online INTEGER DEFAULT 0,
      online_meeting_url TEXT,
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
      FOREIGN KEY (room_id) REFERENCES ${DatabaseTables.rooms} (id) ON DELETE SET NULL,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL
    )
  ''';

  // Attendance Records table
  static const String attendanceRecords = '''
    CREATE TABLE ${DatabaseTables.attendanceRecords} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      class_session_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      date TEXT NOT NULL,
      status TEXT CHECK(status IN ('present', 'absent', 'late', 'excused', 'tardy')) NOT NULL,
      is_excused INTEGER DEFAULT 0,
      recorded_by TEXT NOT NULL,
      notes TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (class_session_id) REFERENCES ${DatabaseTables.classSessions} (id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES ${DatabaseTables.courseOfferings} (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (recorded_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL
    )
  ''';

  // Attendance Excuses table
  static const String attendanceExcuses = '''
    CREATE TABLE ${DatabaseTables.attendanceExcuses} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      attendance_record_id TEXT NOT NULL,
      reason TEXT NOT NULL,
      supporting_document_url TEXT,
      status TEXT CHECK(status IN ('pending', 'approved', 'rejected', 'cancelled')) DEFAULT 'pending',
      reviewed_by TEXT,
      reviewed_at TEXT,
      response TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (attendance_record_id) REFERENCES ${DatabaseTables.attendanceRecords} (id) ON DELETE CASCADE,
      FOREIGN KEY (reviewed_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_class_sessions_course_offering_id ON ${DatabaseTables.classSessions}(course_offering_id)',
    'CREATE INDEX idx_class_sessions_date ON ${DatabaseTables.classSessions}(session_date)',
    'CREATE INDEX idx_attendance_records_user_id ON ${DatabaseTables.attendanceRecords}(user_id)',
    'CREATE INDEX idx_attendance_records_date ON ${DatabaseTables.attendanceRecords}(date)',
    'CREATE INDEX idx_attendance_records_status ON ${DatabaseTables.attendanceRecords}(status)',
    'CREATE INDEX idx_attendance_excuses_attendance_record_id ON ${DatabaseTables.attendanceExcuses}(attendance_record_id)',
    'CREATE INDEX idx_attendance_excuses_status ON ${DatabaseTables.attendanceExcuses}(status)',
  ];

  // All schema definitions
  static const List<String> all = [
    classSessions,
    attendanceRecords,
    attendanceExcuses,
    ...indexes,
  ];
}

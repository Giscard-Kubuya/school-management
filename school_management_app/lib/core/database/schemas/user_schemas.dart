import 'package:school_management_app/core/database/database_tables.dart';

class UserSchemas {
  // Users table
  static const String users =
      '''
    CREATE TABLE ${DatabaseTables.users} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      username TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      user_type TEXT NOT NULL CHECK(user_type IN ('admin', 'teacher', 'student')),
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      middle_name TEXT,
      phone TEXT,
      date_of_birth TEXT,
      gender TEXT CHECK(gender IN ('male', 'female', 'other')),
      profile_photo TEXT,
      status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'active', 'suspended', 'inactive')),
      is_approved INTEGER DEFAULT 0,
      approved_by TEXT,
      approved_at TEXT,
      last_login_at TEXT,
      email_verified_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (approved_by) REFERENCES ${DatabaseTables.users}(id) ON DELETE SET NULL,
      UNIQUE(university_id, username),
      UNIQUE(university_id, email)
    )
  ''';

  // Administrators table
  static const String administrators =
      '''
    CREATE TABLE ${DatabaseTables.administrators} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL UNIQUE,
      university_id TEXT NOT NULL,
      admin_level TEXT DEFAULT 'admin' CHECK(admin_level IN ('super_admin', 'admin', 'moderator')),
      department_id TEXT,
      faculty_id TEXT,
      permissions TEXT,
      can_approve_users INTEGER DEFAULT 1,
      can_manage_courses INTEGER DEFAULT 1,
      can_manage_finances INTEGER DEFAULT 0,
      can_view_reports INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (department_id) REFERENCES ${DatabaseTables.departments}(id) ON DELETE SET NULL,
      FOREIGN KEY (faculty_id) REFERENCES ${DatabaseTables.faculties}(id) ON DELETE SET NULL
    )
  ''';

  // Teachers table
  static const String teachers =
      '''
    CREATE TABLE ${DatabaseTables.teachers} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL UNIQUE,
      university_id TEXT NOT NULL,
      department_id TEXT NOT NULL,
      employee_id TEXT UNIQUE,
      title TEXT DEFAULT 'lecturer' CHECK(title IN ('professor', 'associate_professor', 'assistant_professor', 'lecturer', 'instructor')),
      specialization TEXT,
      qualification TEXT,
      office_location TEXT,
      office_hours TEXT,
      hire_date TEXT,
      employment_status TEXT DEFAULT 'full_time' CHECK(employment_status IN ('full_time', 'part_time', 'contract', 'visiting')),
      bio TEXT,
      research_interests TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (department_id) REFERENCES ${DatabaseTables.departments}(id) ON DELETE CASCADE
    )
  ''';

  // Students table
  static const String students =
      '''
    CREATE TABLE ${DatabaseTables.students} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL UNIQUE,
      university_id TEXT NOT NULL,
      program_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      enrollment_year INTEGER NOT NULL,
      current_semester INTEGER DEFAULT 1,
      current_year_level INTEGER DEFAULT 1,
      academic_status TEXT DEFAULT 'active' CHECK(academic_status IN ('active', 'on_leave', 'suspended', 'graduated', 'withdrawn')),
      gpa REAL DEFAULT 0.00,
      credits_earned INTEGER DEFAULT 0,
      credits_required INTEGER,
      enrollment_type TEXT DEFAULT 'full_time' CHECK(enrollment_type IN ('full_time', 'part_time')),
      guardian_name TEXT,
      guardian_phone TEXT,
      guardian_email TEXT,
      emergency_contact TEXT,
      emergency_phone TEXT,
      address TEXT,
      city TEXT,
      country TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (program_id) REFERENCES ${DatabaseTables.programs}(id) ON DELETE CASCADE,
      UNIQUE(university_id, student_id)
    )
  ''';

  // User Sessions table
  static const String userSessions =
      '''
    CREATE TABLE ${DatabaseTables.userSessions} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      device_id TEXT,
      token TEXT NOT NULL,
      refresh_token TEXT,
      ip_address TEXT,
      user_agent TEXT,
      login_at TEXT NOT NULL,
      last_activity_at TEXT NOT NULL,
      expires_at TEXT NOT NULL,
      is_active INTEGER DEFAULT 1,
      logout_at TEXT,
      logout_reason TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_users_university ON ${DatabaseTables.users}(university_id)',
    'CREATE INDEX idx_users_type ON ${DatabaseTables.users}(user_type)',
    'CREATE INDEX idx_users_status ON ${DatabaseTables.users}(status)',
    'CREATE INDEX idx_users_approved ON ${DatabaseTables.users}(is_approved)',
    'CREATE INDEX idx_administrators_user ON ${DatabaseTables.administrators}(user_id)',
    'CREATE INDEX idx_administrators_university ON ${DatabaseTables.administrators}(university_id)',
    'CREATE INDEX idx_administrators_level ON ${DatabaseTables.administrators}(admin_level)',
    'CREATE INDEX idx_teachers_user ON ${DatabaseTables.teachers}(user_id)',
    'CREATE INDEX idx_teachers_university ON ${DatabaseTables.teachers}(university_id)',
    'CREATE INDEX idx_teachers_department ON ${DatabaseTables.teachers}(department_id)',
    'CREATE INDEX idx_teachers_employee_id ON ${DatabaseTables.teachers}(employee_id)',
    'CREATE INDEX idx_students_user ON ${DatabaseTables.students}(user_id)',
    'CREATE INDEX idx_students_university ON ${DatabaseTables.students}(university_id)',
    'CREATE INDEX idx_students_program ON ${DatabaseTables.students}(program_id)',
    'CREATE INDEX idx_students_status ON ${DatabaseTables.students}(academic_status)',
  ];

  // User Roles table
  static const String userRoles =
      '''
    CREATE TABLE ${DatabaseTables.userRoles} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      description TEXT,
      is_system_role INTEGER DEFAULT 0,
      permissions TEXT, -- JSON array of permission keys
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  // Permissions table
  static const String permissions =
      '''
    CREATE TABLE ${DatabaseTables.permissions} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      description TEXT,
      category TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  // User Permissions table
  static const String userPermissions =
      '''
    CREATE TABLE ${DatabaseTables.userPermissions} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      permission_id TEXT NOT NULL,
      is_granted INTEGER DEFAULT 1,
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      FOREIGN KEY (permission_id) REFERENCES ${DatabaseTables.permissions}(id) ON DELETE CASCADE,
      UNIQUE(user_id, permission_id)
    )
  ''';

  // Role Permissions table
  static const String rolePermissions =
      '''
    CREATE TABLE ${DatabaseTables.rolePermissions} (
      id TEXT PRIMARY KEY,
      role_id TEXT NOT NULL,
      permission_id TEXT NOT NULL,
      is_granted INTEGER DEFAULT 1,
      created_at TEXT NOT NULL,
      FOREIGN KEY (role_id) REFERENCES ${DatabaseTables.userRoles}(id) ON DELETE CASCADE,
      FOREIGN KEY (permission_id) REFERENCES ${DatabaseTables.permissions}(id) ON DELETE CASCADE,
      UNIQUE(role_id, permission_id)
    )
  ''';

  // Password Reset Tokens table
  static const String passwordResetTokens =
      '''
    CREATE TABLE ${DatabaseTables.passwordResetTokens} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      token TEXT NOT NULL,
      expires_at TEXT NOT NULL,
      is_used INTEGER DEFAULT 0,
      used_at TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      UNIQUE(token)
    )
  ''';

  // User Preferences table
  static const String userPreferences =
      '''
    CREATE TABLE ${DatabaseTables.userPreferences} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      preference_key TEXT NOT NULL,
      preference_value TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      UNIQUE(user_id, preference_key)
    )
  ''';

  // Audit Logs table
  static const String auditLogs =
      '''
    CREATE TABLE ${DatabaseTables.auditLogs} (
      id TEXT PRIMARY KEY,
      user_id TEXT,
      action TEXT NOT NULL,
      table_name TEXT NOT NULL,
      record_id TEXT,
      old_values TEXT,
      new_values TEXT,
      ip_address TEXT,
      user_agent TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE SET NULL
    )
  ''';

  // All schema definitions
  static const List<String> all = [
    users,
    administrators,
    teachers,
    students,
    userSessions,
    userRoles,
    permissions,
    userPermissions,
    rolePermissions,
    passwordResetTokens,
    userPreferences,
    auditLogs,
    ...indexes,
  ];

  // Additional indexes
  static const List<String> additionalIndexes = [
    'CREATE INDEX idx_user_roles_name ON ${DatabaseTables.userRoles}(name)',
    'CREATE INDEX idx_permissions_name ON ${DatabaseTables.permissions}(name)',
    'CREATE INDEX idx_user_permissions_user ON ${DatabaseTables.userPermissions}(user_id)',
    'CREATE INDEX idx_user_permissions_permission ON ${DatabaseTables.userPermissions}(permission_id)',
    'CREATE INDEX idx_role_permissions_role ON ${DatabaseTables.rolePermissions}(role_id)',
    'CREATE INDEX idx_role_permissions_permission ON ${DatabaseTables.rolePermissions}(permission_id)',
    'CREATE INDEX idx_password_reset_tokens_user ON ${DatabaseTables.passwordResetTokens}(user_id)',
    'CREATE INDEX idx_password_reset_tokens_token ON ${DatabaseTables.passwordResetTokens}(token)',
    'CREATE INDEX idx_user_preferences_user ON ${DatabaseTables.userPreferences}(user_id)',
    'CREATE INDEX idx_audit_logs_user ON ${DatabaseTables.auditLogs}(user_id)',
    'CREATE INDEX idx_audit_logs_action ON ${DatabaseTables.auditLogs}(action)',
    'CREATE INDEX idx_audit_logs_table ON ${DatabaseTables.auditLogs}(table_name)',
  ];

  // Get all schema definitions including additional indexes
  static List<String> get allWithIndexes => [...all, ...additionalIndexes];
}

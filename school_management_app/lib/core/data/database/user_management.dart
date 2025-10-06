/// User Management Schema
/// 
/// Contains table definitions for user management:
/// - users (base user table)
/// - user_roles (junction table for role assignment)
/// - user_permissions (junction table for direct permissions)
/// - user_sessions (authentication sessions)
/// - user_preferences (user-specific settings)

class UserManagementSchema {
  static const List<String> createTableStatements = [
    _createUsersTable,
    _createUserRolesTable,
    _createUserPermissionsTable,
    _createUserSessionsTable,
    _createUserPreferencesTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_users_email ON users(email)',
    'CREATE INDEX idx_users_phone ON users(phone)',
    'CREATE INDEX idx_users_status ON users(account_status)',
    'CREATE INDEX idx_user_roles_user ON user_roles(user_id)',
    'CREATE INDEX idx_user_roles_role ON user_roles(role_id)',
    'CREATE INDEX idx_user_permissions_user ON user_permissions(user_id)',
    'CREATE INDEX idx_user_sessions_user ON user_sessions(user_id)',
    'CREATE INDEX idx_user_sessions_token ON user_sessions(token)',
    'CREATE INDEX idx_user_sessions_expiry ON user_sessions(expires_at)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createUsersTable = '''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      phone TEXT,
      username TEXT UNIQUE,
      password_hash TEXT NOT NULL,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      middle_name TEXT,
      date_of_birth TEXT,
      gender TEXT,
      profile_picture_url TEXT,
      account_status TEXT NOT NULL DEFAULT 'pending_verification',
      last_login_at TEXT,
      last_login_ip TEXT,
      email_verified_at TEXT,
      phone_verified_at TEXT,
      verification_token TEXT,
      password_reset_token TEXT,
      password_reset_expires_at TEXT,
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

  static const String _createUserRolesTable = '''
    CREATE TABLE user_roles (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      role_id TEXT NOT NULL,
      university_id TEXT NOT NULL,
      created_by TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(user_id, role_id, university_id)
    )
  ''';

  static const String _createUserPermissionsTable = '''
    CREATE TABLE user_permissions (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      permission_id TEXT NOT NULL,
      university_id TEXT NOT NULL,
      granted_by TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(user_id, permission_id, university_id)
    )
  ''';

  static const String _createUserSessionsTable = '''
    CREATE TABLE user_sessions (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      token TEXT UNIQUE NOT NULL,
      refresh_token TEXT UNIQUE,
      device_id TEXT,
      device_name TEXT,
      device_type TEXT,
      ip_address TEXT,
      user_agent TEXT,
      expires_at TEXT NOT NULL,
      is_revoked INTEGER DEFAULT 0,
      revoked_at TEXT,
      last_activity_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';

  static const String _createUserPreferencesTable = '''
    CREATE TABLE user_preferences (
      id TEXT PRIMARY KEY,
      user_id TEXT UNIQUE NOT NULL,
      language_code TEXT DEFAULT 'en',
      theme_mode TEXT DEFAULT 'system',
      notifications_enabled INTEGER DEFAULT 1,
      email_notifications_enabled INTEGER DEFAULT 1,
      push_notifications_enabled INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';

  // Prevent instantiation
  UserManagementSchema._();
}

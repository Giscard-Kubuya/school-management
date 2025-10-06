/// Device Authentication Schema
/// 
/// Contains table definitions for device authentication and configuration:
/// - device_configurations
/// - device_registrations
/// - pending_accounts
/// - device_blacklist

class DeviceAuthSchema {
  static const List<String> createTableStatements = [
    _createDeviceConfigurationsTable,
    _createDeviceRegistrationsTable,
    _createPendingAccountsTable,
    _createDeviceBlacklistTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_device_config_university ON device_configurations(university_id)',
    'CREATE INDEX idx_device_registrations_device_id ON device_registrations(device_id)',
    'CREATE INDEX idx_device_registrations_user ON device_registrations(user_id)',
    'CREATE INDEX idx_pending_accounts_email ON pending_accounts(email)',
    'CREATE INDEX idx_pending_accounts_verification ON pending_accounts(verification_token)',
    'CREATE INDEX idx_device_blacklist_device_id ON device_blacklist(device_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createDeviceConfigurationsTable = '''
    CREATE TABLE device_configurations (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      config_key TEXT NOT NULL,
      config_value TEXT NOT NULL,
      description TEXT,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(university_id, config_key)
    )
  ''';

  static const String _createDeviceRegistrationsTable = '''
    CREATE TABLE device_registrations (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      user_id TEXT,
      device_id TEXT NOT NULL,
      device_name TEXT,
      device_model TEXT,
      device_os TEXT,
      device_os_version TEXT,
      app_version TEXT,
      fcm_token TEXT,
      last_active_at TEXT NOT NULL,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      UNIQUE(device_id, university_id)
    )
  ''';

  static const String _createPendingAccountsTable = '''
    CREATE TABLE pending_accounts (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      password_hash TEXT NOT NULL,
      verification_token TEXT NOT NULL,
      verification_expires_at TEXT NOT NULL,
      verification_attempts INTEGER DEFAULT 0,
      is_verified INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'pending',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 1,  // Starts as dirty until verified
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(email, university_id)
    )
  ''';

  static const String _createDeviceBlacklistTable = '''
    CREATE TABLE device_blacklist (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      device_id TEXT NOT NULL,
      reason TEXT,
      blacklisted_by TEXT,
      is_permanent INTEGER DEFAULT 0,
      expires_at TEXT,
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

  // Prevent instantiation
  DeviceAuthSchema._();
}

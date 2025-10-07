import 'package:school_management_app/core/database/database_tables.dart';

class SystemSchemas {
  // Device Configurations table
  static const String deviceConfigurations = '''
    CREATE TABLE ${DatabaseTables.deviceConfigurations} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      device_uuid TEXT NOT NULL UNIQUE,
      device_name TEXT,
      device_type TEXT DEFAULT 'mobile' CHECK(device_type IN ('mobile', 'tablet', 'desktop', 'web')),
      platform TEXT,
      platform_version TEXT,
      app_version TEXT,
      is_configured INTEGER DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      configuration_token TEXT UNIQUE,
      token_expires_at TEXT,
      configured_at TEXT,
      configured_by TEXT,
      last_used_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (configured_by) REFERENCES ${DatabaseTables.users}(id) ON DELETE SET NULL
    )
  ''';

  // Device Registrations table
  static const String deviceRegistrations = '''
    CREATE TABLE ${DatabaseTables.deviceRegistrations} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      user_id TEXT,
      device_uuid TEXT NOT NULL,
      device_name TEXT,
      registration_code TEXT NOT NULL UNIQUE,
      code_expires_at TEXT NOT NULL,
      status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'verified', 'expired', 'rejected')),
      verification_method TEXT DEFAULT 'code' CHECK(verification_method IN ('code', 'email', 'admin_approval')),
      verified_at TEXT,
      verified_by TEXT,
      ip_address TEXT,
      user_agent TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      FOREIGN KEY (verified_by) REFERENCES ${DatabaseTables.users}(id) ON DELETE SET NULL
    )
  ''';

  // Pending Accounts table
  static const String pendingAccounts = '''
    CREATE TABLE ${DatabaseTables.pendingAccounts} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      device_id TEXT,
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
      registration_data TEXT,
      status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'approved', 'rejected', 'expired')),
      approved_by TEXT,
      approved_at TEXT,
      rejection_reason TEXT,
      expires_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities}(id) ON DELETE CASCADE,
      FOREIGN KEY (device_id) REFERENCES ${DatabaseTables.deviceConfigurations}(id) ON DELETE SET NULL,
      FOREIGN KEY (approved_by) REFERENCES ${DatabaseTables.users}(id) ON DELETE SET NULL,
      UNIQUE(university_id, email)
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_device_configurations_university ON ${DatabaseTables.deviceConfigurations}(university_id)',
    'CREATE INDEX idx_device_configurations_uuid ON ${DatabaseTables.deviceConfigurations}(device_uuid)',
    'CREATE INDEX idx_device_configurations_active ON ${DatabaseTables.deviceConfigurations}(is_active)',
    'CREATE INDEX idx_device_configurations_configured ON ${DatabaseTables.deviceConfigurations}(is_configured)',
    'CREATE INDEX idx_device_registrations_university ON ${DatabaseTables.deviceRegistrations}(university_id)',
    'CREATE INDEX idx_device_registrations_user ON ${DatabaseTables.deviceRegistrations}(user_id)',
    'CREATE INDEX idx_device_registrations_code ON ${DatabaseTables.deviceRegistrations}(registration_code)',
    'CREATE INDEX idx_device_registrations_status ON ${DatabaseTables.deviceRegistrations}(status)',
    'CREATE INDEX idx_pending_accounts_university ON ${DatabaseTables.pendingAccounts}(university_id)',
    'CREATE INDEX idx_pending_accounts_status ON ${DatabaseTables.pendingAccounts}(status)',
    'CREATE INDEX idx_pending_accounts_email ON ${DatabaseTables.pendingAccounts}(email)',
    'CREATE INDEX idx_pending_accounts_expires ON ${DatabaseTables.pendingAccounts}(expires_at)',
  ];

  // All schema definitions
  static const List<String> all = [
    deviceConfigurations,
    deviceRegistrations,
    pendingAccounts,
    ...indexes,
  ];
}

# Device & Authentication Tables - Complete Schema

## Tables in this file:
1. device_configurations
2. device_registrations
3. pending_accounts

---

## 1. device_configurations

### MySQL (Laravel)
```sql
CREATE TABLE device_configurations (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  device_uuid VARCHAR(255) NOT NULL UNIQUE, -- Hardware device identifier
  device_name VARCHAR(255), -- User-friendly name
  device_type ENUM('mobile', 'tablet', 'desktop', 'web') DEFAULT 'mobile',

  platform VARCHAR(50), -- iOS, Android, Windows, MacOS, Web
  platform_version VARCHAR(50),
  app_version VARCHAR(50),

  is_configured BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,

  configuration_token VARCHAR(255) UNIQUE, -- Token used during setup
  token_expires_at TIMESTAMP,

  configured_at TIMESTAMP NULL,
  configured_by VARCHAR(36), -- user_id who configured the device

  last_used_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (configured_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_device_configurations_university (university_id),
  INDEX idx_device_configurations_uuid (device_uuid),
  INDEX idx_device_configurations_active (is_active),
  INDEX idx_device_configurations_configured (is_configured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE device_configurations (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  device_uuid TEXT NOT NULL UNIQUE,
  device_name TEXT,
  device_type TEXT DEFAULT 'mobile',
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
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (configured_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_device_configurations_university ON device_configurations(university_id);
CREATE INDEX idx_device_configurations_uuid ON device_configurations(device_uuid);
CREATE INDEX idx_device_configurations_active ON device_configurations(is_active);
CREATE INDEX idx_device_configurations_configured ON device_configurations(is_configured);
```

---

## 2. device_registrations

### MySQL (Laravel)
```sql
CREATE TABLE device_registrations (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  user_id VARCHAR(36),

  device_uuid VARCHAR(255) NOT NULL,
  device_name VARCHAR(255),

  registration_code VARCHAR(10) NOT NULL UNIQUE, -- 6-10 digit code for verification
  code_expires_at TIMESTAMP NOT NULL,

  status ENUM('pending', 'verified', 'expired', 'rejected') DEFAULT 'pending',

  verification_method ENUM('code', 'email', 'admin_approval') DEFAULT 'code',
  verified_at TIMESTAMP NULL,
  verified_by VARCHAR(36), -- admin user_id if admin verified

  ip_address VARCHAR(45),
  user_agent TEXT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_device_registrations_university (university_id),
  INDEX idx_device_registrations_user (user_id),
  INDEX idx_device_registrations_code (registration_code),
  INDEX idx_device_registrations_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE device_registrations (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  user_id TEXT,
  device_uuid TEXT NOT NULL,
  device_name TEXT,
  registration_code TEXT NOT NULL UNIQUE,
  code_expires_at TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  verification_method TEXT DEFAULT 'code',
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
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_device_registrations_university ON device_registrations(university_id);
CREATE INDEX idx_device_registrations_user ON device_registrations(user_id);
CREATE INDEX idx_device_registrations_code ON device_registrations(registration_code);
CREATE INDEX idx_device_registrations_status ON device_registrations(status);
```

---

## 3. pending_accounts

### MySQL (Laravel)
```sql
CREATE TABLE pending_accounts (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  device_id VARCHAR(36),

  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL, -- Hashed password

  user_type ENUM('admin', 'teacher', 'student') NOT NULL,

  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  middle_name VARCHAR(100),

  phone VARCHAR(20),
  date_of_birth DATE,
  gender ENUM('male', 'female', 'other'),

  -- Additional registration data (JSON)
  registration_data JSON, -- Stores department_id, program_id, etc.

  status ENUM('pending', 'approved', 'rejected', 'expired') DEFAULT 'pending',

  approved_by VARCHAR(36), -- admin user_id
  approved_at TIMESTAMP NULL,
  rejection_reason TEXT,

  expires_at TIMESTAMP NOT NULL, -- Pending accounts expire after X days

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (device_id) REFERENCES device_configurations(id) ON DELETE SET NULL,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_pending_accounts_university (university_id),
  INDEX idx_pending_accounts_status (status),
  INDEX idx_pending_accounts_email (email),
  INDEX idx_pending_accounts_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE pending_accounts (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  device_id TEXT,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password TEXT NOT NULL,
  user_type TEXT NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  middle_name TEXT,
  phone TEXT,
  date_of_birth TEXT,
  gender TEXT,
  registration_data TEXT,
  status TEXT DEFAULT 'pending',
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
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (device_id) REFERENCES device_configurations(id) ON DELETE SET NULL,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_pending_accounts_university ON pending_accounts(university_id);
CREATE INDEX idx_pending_accounts_status ON pending_accounts(status);
CREATE INDEX idx_pending_accounts_email ON pending_accounts(email);
CREATE INDEX idx_pending_accounts_expires ON pending_accounts(expires_at);
```

---

**File 4 of 8 - Device & Authentication Tables Complete**

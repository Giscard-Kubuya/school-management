# User Management Tables - Complete Schema

## Tables in this file:

1. users
2. administrators
3. teachers
4. students
5. user_sessions

---

## 1. users

### MySQL (Laravel)

```sql
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,

  user_type ENUM('admin', 'teacher', 'student') NOT NULL,

  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  middle_name VARCHAR(100),

  phone VARCHAR(20),
  date_of_birth DATE,
  gender ENUM('male', 'female', 'other'),

  profile_photo VARCHAR(255),

  status ENUM('pending', 'active', 'suspended', 'inactive') DEFAULT 'pending',
  is_approved BOOLEAN DEFAULT FALSE,
  approved_by VARCHAR(36),
  approved_at TIMESTAMP NULL,

  last_login_at TIMESTAMP NULL,
  email_verified_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY unique_username_university (university_id, username),
  UNIQUE KEY unique_email_university (university_id, email),
  INDEX idx_users_university (university_id),
  INDEX idx_users_type (user_type),
  INDEX idx_users_status (status),
  INDEX idx_users_approved (is_approved)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
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
  profile_photo TEXT,
  status TEXT DEFAULT 'pending',
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
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE(university_id, username),
  UNIQUE(university_id, email)
);

CREATE INDEX idx_users_university ON users(university_id);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_approved ON users(is_approved);
```

---

## 2. administrators

### MySQL (Laravel)

```sql
CREATE TABLE administrators (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL UNIQUE,
  university_id VARCHAR(36) NOT NULL,

  admin_level ENUM('super_admin', 'admin', 'moderator') DEFAULT 'admin',

  department_id VARCHAR(36), -- If admin is department-specific
  faculty_id VARCHAR(36), -- If admin is faculty-specific

  permissions JSON, -- Array of specific permissions

  can_approve_users BOOLEAN DEFAULT TRUE,
  can_manage_courses BOOLEAN DEFAULT TRUE,
  can_manage_finances BOOLEAN DEFAULT FALSE,
  can_view_reports BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE SET NULL,
  INDEX idx_administrators_user (user_id),
  INDEX idx_administrators_university (university_id),
  INDEX idx_administrators_level (admin_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE administrators (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  university_id TEXT NOT NULL,
  admin_level TEXT DEFAULT 'admin',
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
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE SET NULL
);

CREATE INDEX idx_administrators_user ON administrators(user_id);
CREATE INDEX idx_administrators_university ON administrators(university_id);
CREATE INDEX idx_administrators_level ON administrators(admin_level);
```

---

## 3. teachers

### MySQL (Laravel)

```sql
CREATE TABLE teachers (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL UNIQUE,
  university_id VARCHAR(36) NOT NULL,
  department_id VARCHAR(36) NOT NULL,

  employee_id VARCHAR(50) UNIQUE,

  title ENUM('professor', 'associate_professor', 'assistant_professor', 'lecturer', 'instructor') DEFAULT 'lecturer',

  specialization VARCHAR(255),
  qualification VARCHAR(255), -- Highest degree

  office_location VARCHAR(255),
  office_hours TEXT, -- JSON format for office hours

  hire_date DATE,
  employment_status ENUM('full_time', 'part_time', 'contract', 'visiting') DEFAULT 'full_time',

  bio TEXT,
  research_interests TEXT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  INDEX idx_teachers_user (user_id),
  INDEX idx_teachers_university (university_id),
  INDEX idx_teachers_department (department_id),
  INDEX idx_teachers_employee_id (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE teachers (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  university_id TEXT NOT NULL,
  department_id TEXT NOT NULL,
  employee_id TEXT UNIQUE,
  title TEXT DEFAULT 'lecturer',
  specialization TEXT,
  qualification TEXT,
  office_location TEXT,
  office_hours TEXT,
  hire_date TEXT,
  employment_status TEXT DEFAULT 'full_time',
  bio TEXT,
  research_interests TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE
);

CREATE INDEX idx_teachers_user ON teachers(user_id);
CREATE INDEX idx_teachers_university ON teachers(university_id);
CREATE INDEX idx_teachers_department ON teachers(department_id);
CREATE INDEX idx_teachers_employee_id ON teachers(employee_id);
```

---

## 4. students

### MySQL (Laravel)

```sql
CREATE TABLE students (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL UNIQUE,
  university_id VARCHAR(36) NOT NULL,
  program_id VARCHAR(36) NOT NULL,

  student_id VARCHAR(50) NOT NULL,

  enrollment_year INT NOT NULL,
  current_semester INT DEFAULT 1,
  current_year_level INT DEFAULT 1, -- 1st year, 2nd year, etc.

  academic_status ENUM('active', 'on_leave', 'suspended', 'graduated', 'withdrawn') DEFAULT 'active',

  gpa DECIMAL(3,2) DEFAULT 0.00,
  credits_earned INT DEFAULT 0,
  credits_required INT,

  enrollment_type ENUM('full_time', 'part_time') DEFAULT 'full_time',

  guardian_name VARCHAR(255),
  guardian_phone VARCHAR(20),
  guardian_email VARCHAR(255),

  emergency_contact VARCHAR(255),
  emergency_phone VARCHAR(20),

  address TEXT,
  city VARCHAR(100),
  country VARCHAR(100),

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
  UNIQUE KEY unique_student_id (university_id, student_id),
  INDEX idx_students_user (user_id),
  INDEX idx_students_university (university_id),
  INDEX idx_students_program (program_id),
  INDEX idx_students_status (academic_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE students (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  university_id TEXT NOT NULL,
  program_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  enrollment_year INTEGER NOT NULL,
  current_semester INTEGER DEFAULT 1,
  current_year_level INTEGER DEFAULT 1,
  academic_status TEXT DEFAULT 'active',
  gpa REAL DEFAULT 0.00,
  credits_earned INTEGER DEFAULT 0,
  credits_required INTEGER,
  enrollment_type TEXT DEFAULT 'full_time',
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
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
  UNIQUE(university_id, student_id)
);

CREATE INDEX idx_students_user ON students(user_id);
CREATE INDEX idx_students_university ON students(university_id);
CREATE INDEX idx_students_program ON students(program_id);
CREATE INDEX idx_students_status ON students(academic_status);
```

---

## 5. user_sessions

### MySQL (Laravel)

```sql
CREATE TABLE user_sessions (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  device_id VARCHAR(36), -- Reference to device_configurations

  token TEXT NOT NULL, -- Session/JWT token
  refresh_token TEXT,

  ip_address VARCHAR(45),
  user_agent TEXT,

  login_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL,

  is_active BOOLEAN DEFAULT TRUE,

  logout_at TIMESTAMP NULL,
  logout_reason VARCHAR(100), -- manual, timeout, forced

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (device_id) REFERENCES device_configurations(id) ON DELETE SET NULL,
  INDEX idx_user_sessions_user (user_id),
  INDEX idx_user_sessions_device (device_id),
  INDEX idx_user_sessions_active (is_active),
  INDEX idx_user_sessions_token (token(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE user_sessions (
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
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (device_id) REFERENCES device_configurations(id) ON DELETE SET NULL
);

CREATE INDEX idx_user_sessions_user ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_device ON user_sessions(device_id);
CREATE INDEX idx_user_sessions_active ON user_sessions(is_active);
```

---

**File 3 of 8 - User Management Tables Complete**

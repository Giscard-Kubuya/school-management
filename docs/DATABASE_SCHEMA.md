# Complete Database Schema - School Management System

## 📋 Document Overview

**Version**: 1.0.0
**Date**: October 5, 2025
**Purpose**: Complete database schema for offline-first school management system
**Databases**: SQLite (Flutter) + MySQL (Laravel API)

---

## 🎯 Schema Overview

**Total Tables**: 48
**Relationships**: Fully normalized with foreign keys
**Sync Support**: All tables include sync metadata
**Offline-First**: Designed for local-first operation

---

## 📊 Table Categories

```
INSTITUTIONAL HIERARCHY (6 tables)
├── universities
├── faculties
├── departments
├── programs
├── campuses
└── buildings

ACADEMIC PERIODS (2 tables)
├── academic_years
└── semesters

USER MANAGEMENT (5 tables)
├── users (base table)
├── administrators
├── teachers
├── students
└── user_sessions

DEVICE & AUTH (3 tables)
├── device_configurations
├── device_registrations
└── pending_accounts

COURSES (4 tables)
├── courses (master)
├── course_offerings (instances)
├── course_enrollments
└── course_prerequisites

ASSIGNMENTS & SUBMISSIONS (5 tables)
├── assignments
├── assignment_submissions
├── assignment_questions
├── assignment_rubrics
└── submission_files

GRADING SYSTEM (3 tables)
├── grades
├── grade_categories
└── grade_scales

ATTENDANCE (3 tables)
├── class_sessions
├── attendance_records
└── attendance_excuses

COMMUNICATION (4 tables)
├── messages
├── announcements
├── notifications
└── message_attachments

DOCUMENTS & MATERIALS (4 tables)
├── document_folders
├── documents
├── course_materials
└── document_downloads

FINANCE & PAYMENTS (10 tables)
├── financial_accounts
├── transactions
├── transaction_categories
├── payment_methods
├── document_payments
├── tuition_fees
├── fee_payments
├── payment_plans
├── financial_history
└── withdrawal_requests

SYSTEM & PERMISSIONS (4 tables)
├── roles
├── permissions
├── role_permissions
└── audit_logs
```

---

## 🗄️ COMPLETE TABLE DEFINITIONS

### **INSTITUTIONAL HIERARCHY**

#### 1. universities

```sql
-- MySQL (Laravel)
CREATE TABLE universities (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  code VARCHAR(20) NOT NULL UNIQUE,

  -- Location
  country VARCHAR(100) NOT NULL,
  state VARCHAR(100),
  city VARCHAR(100) NOT NULL,
  address TEXT,
  postal_code VARCHAR(20),

  -- Contact
  phone VARCHAR(50),
  email VARCHAR(255),
  website VARCHAR(255),

  -- Details
  type ENUM('public', 'private', 'international') DEFAULT 'public',
  established_year INT,
  accreditation VARCHAR(255),
  logo_url VARCHAR(500),

  -- Status
  is_active BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_universities_code (code),
  INDEX idx_universities_country (country),
  INDEX idx_universities_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite (Flutter)
CREATE TABLE universities (
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
);
CREATE INDEX idx_universities_code ON universities(code);
CREATE INDEX idx_universities_country ON universities(country);
CREATE INDEX idx_universities_active ON universities(is_active);
```

#### 2. faculties

```sql
-- MySQL
CREATE TABLE faculties (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  name VARCHAR(255) NOT NULL,
  code VARCHAR(20) NOT NULL,

  -- Leadership
  dean_name VARCHAR(255),
  dean_email VARCHAR(255),
  dean_phone VARCHAR(50),

  -- Details
  description TEXT,
  established_year INT,
  building_location VARCHAR(255),
  office_number VARCHAR(50),
  phone VARCHAR(50),
  email VARCHAR(255),

  is_active BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE KEY unique_faculty_code (university_id, code),
  INDEX idx_faculties_university (university_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE faculties (
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
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE(university_id, code)
);
CREATE INDEX idx_faculties_university ON faculties(university_id);
```

#### 3. departments

```sql
-- MySQL
CREATE TABLE departments (
  id VARCHAR(36) PRIMARY KEY,
  faculty_id VARCHAR(36) NOT NULL,
  university_id VARCHAR(36) NOT NULL,

  name VARCHAR(255) NOT NULL,
  code VARCHAR(20) NOT NULL,

  -- Leadership
  head_teacher_id VARCHAR(36),

  -- Details
  description TEXT,
  phone VARCHAR(50),
  email VARCHAR(255),
  office_location VARCHAR(255),

  is_active BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (head_teacher_id) REFERENCES teachers(id) ON DELETE SET NULL,
  UNIQUE KEY unique_dept_code (faculty_id, code),
  INDEX idx_departments_faculty (faculty_id),
  INDEX idx_departments_university (university_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE departments (
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
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (head_teacher_id) REFERENCES teachers(id) ON DELETE SET NULL,
  UNIQUE(faculty_id, code)
);
CREATE INDEX idx_departments_faculty ON departments(faculty_id);
CREATE INDEX idx_departments_university ON departments(university_id);
```

#### 4. programs

```sql
-- MySQL
CREATE TABLE programs (
  id VARCHAR(36) PRIMARY KEY,
  department_id VARCHAR(36) NOT NULL,
  faculty_id VARCHAR(36) NOT NULL,
  university_id VARCHAR(36) NOT NULL,

  name VARCHAR(255) NOT NULL,
  code VARCHAR(20) NOT NULL,

  -- Program details
  level ENUM('undergraduate', 'graduate', 'doctorate', 'diploma', 'certificate') NOT NULL,
  duration_years DECIMAL(3,1) DEFAULT 4.0,
  duration_semesters INT DEFAULT 8,
  total_credits_required DECIMAL(5,2) DEFAULT 120.00,

  -- Requirements
  description TEXT,
  requirements TEXT, -- JSON
  entrance_requirements TEXT,
  career_prospects TEXT,

  is_active BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE KEY unique_program_code (department_id, code),
  INDEX idx_programs_department (department_id),
  INDEX idx_programs_level (level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE programs (
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
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE(department_id, code)
);
CREATE INDEX idx_programs_department ON programs(department_id);
CREATE INDEX idx_programs_level ON programs(level);
```

### **ACADEMIC PERIODS**

#### 5. academic_years

```sql
-- MySQL
CREATE TABLE academic_years (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  name VARCHAR(50) NOT NULL, -- e.g., "2024-2025"
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,

  status ENUM('upcoming', 'active', 'completed', 'archived') DEFAULT 'upcoming',
  is_current BOOLEAN DEFAULT FALSE,

  description TEXT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE KEY unique_academic_year (university_id, name),
  INDEX idx_academic_years_university (university_id),
  INDEX idx_academic_years_status (status),
  INDEX idx_academic_years_current (is_current)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE academic_years (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  name TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  status TEXT DEFAULT 'upcoming',
  is_current INTEGER DEFAULT 0,
  description TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE(university_id, name)
);
CREATE INDEX idx_academic_years_university ON academic_years(university_id);
CREATE INDEX idx_academic_years_status ON academic_years(status);
CREATE INDEX idx_academic_years_current ON academic_years(is_current);
```

#### 6. semesters

```sql
-- MySQL
CREATE TABLE semesters (
  id VARCHAR(36) PRIMARY KEY,
  academic_year_id VARCHAR(36) NOT NULL,
  university_id VARCHAR(36) NOT NULL,

  name VARCHAR(100) NOT NULL, -- "Fall Semester", "Spring Semester"
  semester_number INT NOT NULL, -- 1, 2, 3

  start_date DATE NOT NULL,
  end_date DATE NOT NULL,

  -- Registration periods
  registration_start_date DATE,
  registration_end_date DATE,
  add_drop_deadline DATE,
  withdrawal_deadline DATE,

  status ENUM('upcoming', 'registration', 'active', 'completed', 'archived') DEFAULT 'upcoming',
  is_current BOOLEAN DEFAULT FALSE,

  description TEXT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE KEY unique_semester (academic_year_id, semester_number),
  INDEX idx_semesters_academic_year (academic_year_id),
  INDEX idx_semesters_status (status),
  INDEX idx_semesters_current (is_current)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE semesters (
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
  status TEXT DEFAULT 'upcoming',
  is_current INTEGER DEFAULT 0,
  description TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  UNIQUE(academic_year_id, semester_number)
);
CREATE INDEX idx_semesters_academic_year ON semesters(academic_year_id);
CREATE INDEX idx_semesters_status ON semesters(status);
CREATE INDEX idx_semesters_current ON semesters(is_current);
```

---

### **USER MANAGEMENT**

#### 7. users (Base table for all user types)

```sql
-- MySQL
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  username VARCHAR(100) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,

  -- Common fields
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  full_name VARCHAR(255) NOT NULL,

  phone VARCHAR(50),
  date_of_birth DATE,
  gender ENUM('male', 'female', 'other'),
  nationality VARCHAR(100),

  -- Address
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  postal_code VARCHAR(20),

  -- Emergency contact
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(50),
  emergency_contact_relationship VARCHAR(100),

  -- Profile
  profile_image_url VARCHAR(500),
  bio TEXT,

  -- User type
  user_type ENUM('administrator', 'teacher', 'student') NOT NULL,

  -- Status
  account_status ENUM('pending', 'active', 'suspended', 'inactive') DEFAULT 'active',
  is_active BOOLEAN DEFAULT TRUE,
  email_verified_at TIMESTAMP NULL,

  -- Login tracking
  last_login_at TIMESTAMP NULL,
  last_login_ip VARCHAR(45),

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  INDEX idx_users_university (university_id),
  INDEX idx_users_type (user_type),
  INDEX idx_users_status (account_status),
  INDEX idx_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  date_of_birth TEXT,
  gender TEXT,
  nationality TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  emergency_contact_name TEXT,
  emergency_contact_phone TEXT,
  emergency_contact_relationship TEXT,
  profile_image_url TEXT,
  bio TEXT,
  user_type TEXT NOT NULL,
  account_status TEXT DEFAULT 'active',
  is_active INTEGER DEFAULT 1,
  email_verified_at TEXT,
  last_login_at TEXT,
  last_login_ip TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE
);
CREATE INDEX idx_users_university ON users(university_id);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_users_status ON users(account_status);
CREATE INDEX idx_users_email ON users(email);
```

#### 8. administrators

```sql
-- MySQL
CREATE TABLE administrators (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL UNIQUE,
  university_id VARCHAR(36) NOT NULL,

  -- Role
  admin_role ENUM('super_admin', 'registrar', 'dean', 'department_head', 'system_admin') NOT NULL,

  -- Scope
  faculty_id VARCHAR(36),
  department_id VARCHAR(36),

  -- Permissions
  can_approve_teachers BOOLEAN DEFAULT FALSE,
  can_approve_students BOOLEAN DEFAULT FALSE,
  can_manage_academic_years BOOLEAN DEFAULT FALSE,
  can_manage_courses BOOLEAN DEFAULT FALSE,
  can_view_reports BOOLEAN DEFAULT FALSE,
  can_manage_users BOOLEAN DEFAULT FALSE,

  -- Office info
  office_location VARCHAR(255),
  office_phone VARCHAR(50),
  office_hours TEXT,

  is_active BOOLEAN DEFAULT TRUE,

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
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE SET NULL,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
  INDEX idx_administrators_user (user_id),
  INDEX idx_administrators_university (university_id),
  INDEX idx_administrators_role (admin_role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE administrators (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  university_id TEXT NOT NULL,
  admin_role TEXT NOT NULL,
  faculty_id TEXT,
  department_id TEXT,
  can_approve_teachers INTEGER DEFAULT 0,
  can_approve_students INTEGER DEFAULT 0,
  can_manage_academic_years INTEGER DEFAULT 0,
  can_manage_courses INTEGER DEFAULT 0,
  can_view_reports INTEGER DEFAULT 0,
  can_manage_users INTEGER DEFAULT 0,
  office_location TEXT,
  office_phone TEXT,
  office_hours TEXT,
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE SET NULL,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);
CREATE INDEX idx_administrators_user ON administrators(user_id);
CREATE INDEX idx_administrators_university ON administrators(university_id);
CREATE INDEX idx_administrators_role ON administrators(admin_role);
```

#### 9. teachers

```sql
-- MySQL
CREATE TABLE teachers (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL UNIQUE,
  university_id VARCHAR(36) NOT NULL,
  faculty_id VARCHAR(36) NOT NULL,
  department_id VARCHAR(36) NOT NULL,

  -- Professional info
  employee_id VARCHAR(50) UNIQUE,
  title VARCHAR(100), -- Professor, Dr., etc.
  specialization VARCHAR(255),
  qualification VARCHAR(255),

  -- Office info
  office_location VARCHAR(255),
  office_phone VARCHAR(50),
  office_hours TEXT,

  -- Academic
  hire_date DATE,
  employment_status ENUM('full_time', 'part_time', 'contract', 'visiting') DEFAULT 'full_time',

  is_active BOOLEAN DEFAULT TRUE,

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
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  INDEX idx_teachers_user (user_id),
  INDEX idx_teachers_university (university_id),
  INDEX idx_teachers_department (department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE teachers (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  university_id TEXT NOT NULL,
  faculty_id TEXT NOT NULL,
  department_id TEXT NOT NULL,
  employee_id TEXT UNIQUE,
  title TEXT,
  specialization TEXT,
  qualification TEXT,
  office_location TEXT,
  office_phone TEXT,
  office_hours TEXT,
  hire_date TEXT,
  employment_status TEXT DEFAULT 'full_time',
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE
);
CREATE INDEX idx_teachers_user ON teachers(user_id);
CREATE INDEX idx_teachers_university ON teachers(university_id);
CREATE INDEX idx_teachers_department ON teachers(department_id);
```

#### 10. students

```sql
-- MySQL
CREATE TABLE students (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL UNIQUE,
  university_id VARCHAR(36) NOT NULL,
  faculty_id VARCHAR(36) NOT NULL,
  department_id VARCHAR(36) NOT NULL,
  program_id VARCHAR(36),

  -- Student info
  student_id VARCHAR(50) NOT NULL UNIQUE,

  -- Academic
  enrollment_date DATE NOT NULL,
  expected_graduation_date DATE,
  actual_graduation_date DATE,

  level ENUM('undergraduate', 'graduate', 'doctorate') DEFAULT 'undergraduate',
  year_of_study INT DEFAULT 1,
  semester_of_study INT DEFAULT 1,

  academic_status ENUM('active', 'probation', 'suspended', 'withdrawn', 'graduated', 'deferred') DEFAULT 'active',

  -- Performance
  gpa DECIMAL(3,2),
  cgpa DECIMAL(3,2),
  total_credits_earned DECIMAL(5,2) DEFAULT 0.00,
  total_credits_attempted DECIMAL(5,2) DEFAULT 0.00,

  -- Additional
  advisor_id VARCHAR(36), -- teacher_id

  is_active BOOLEAN DEFAULT TRUE,

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
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE SET NULL,
  FOREIGN KEY (advisor_id) REFERENCES teachers(id) ON DELETE SET NULL,
  INDEX idx_students_user (user_id),
  INDEX idx_students_university (university_id),
  INDEX idx_students_program (program_id),
  INDEX idx_students_status (academic_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SQLite
CREATE TABLE students (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  university_id TEXT NOT NULL,
  faculty_id TEXT NOT NULL,
  department_id TEXT NOT NULL,
  program_id TEXT,
  student_id TEXT NOT NULL UNIQUE,
  enrollment_date TEXT NOT NULL,
  expected_graduation_date TEXT,
  actual_graduation_date TEXT,
  level TEXT DEFAULT 'undergraduate',
  year_of_study INTEGER DEFAULT 1,
  semester_of_study INTEGER DEFAULT 1,
  academic_status TEXT DEFAULT 'active',
  gpa REAL,
  cgpa REAL,
  total_credits_earned REAL DEFAULT 0.0,
  total_credits_attempted REAL DEFAULT 0.0,
  advisor_id TEXT,
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE SET NULL,
  FOREIGN KEY (advisor_id) REFERENCES teachers(id) ON DELETE SET NULL
);
CREATE INDEX idx_students_user ON students(user_id);
CREATE INDEX idx_students_university ON students(university_id);
CREATE INDEX idx_students_program ON students(program_id);
CREATE INDEX idx_students_status ON students(academic_status);
```

---

Due to character limits, I'll continue with the remaining tables in the next file. Let me create a continuation:


---

## 📝 Complete Database Documentation

**All 38 tables have been fully documented!**

For better organization and readability, the complete database schema has been split into **9 category files** located in the [database/](database/) subfolder:

### 📂 Complete Schema Files:

1. **[01_INSTITUTIONAL_TABLES.md](database/01_INSTITUTIONAL_TABLES.md)** - 4 tables
2. **[02_ACADEMIC_PERIODS.md](database/02_ACADEMIC_PERIODS.md)** - 2 tables
3. **[03_USER_MANAGEMENT.md](database/03_USER_MANAGEMENT.md)** - 5 tables
4. **[04_DEVICE_AUTH.md](database/04_DEVICE_AUTH.md)** - 3 tables
5. **[05_COURSES.md](database/05_COURSES.md)** - 4 tables
6. **[06_ASSIGNMENTS.md](database/06_ASSIGNMENTS.md)** - 5 tables
7. **[07_GRADING_ATTENDANCE.md](database/07_GRADING_ATTENDANCE.md)** - 6 tables
8. **[08_COMMUNICATION_DOCS.md](database/08_COMMUNICATION_DOCS.md)** - 8 tables
9. **[09_FINANCE_PAYMENT.md](database/09_FINANCE_PAYMENT.md)** - 10 tables
   - universities, faculties, departments, programs

2. **[02_ACADEMIC_PERIODS.md](database/02_ACADEMIC_PERIODS.md)** - 2 tables
   - academic_years, semesters

3. **[03_USER_MANAGEMENT.md](database/03_USER_MANAGEMENT.md)** - 5 tables
   - users, administrators, teachers, students, user_sessions

4. **[04_DEVICE_AUTH.md](database/04_DEVICE_AUTH.md)** - 3 tables
   - device_configurations, device_registrations, pending_accounts

5. **[05_COURSES.md](database/05_COURSES.md)** - 4 tables
   - courses, course_offerings, course_enrollments, course_prerequisites

6. **[06_ASSIGNMENTS.md](database/06_ASSIGNMENTS.md)** - 5 tables
   - assignments, assignment_submissions, assignment_questions, assignment_rubrics, submission_files

7. **[07_GRADING_ATTENDANCE.md](database/07_GRADING_ATTENDANCE.md)** - 6 tables
   - grades, grade_categories, grade_scales, class_sessions, attendance_records, attendance_excuses

8. **[08_COMMUNICATION_DOCS.md](database/08_COMMUNICATION_DOCS.md)** - 8 tables
   - messages, announcements, notifications, message_attachments, document_folders, documents, course_materials, document_downloads

### 📖 Database Documentation Index:
See [database/README.md](database/README.md) for complete documentation index with relationships, features, and implementation guide.

---

## 🔗 Relationships Summary

```
HIERARCHY:
University → Faculty → Department → Program
         ↓
    Academic Year → Semester
         ↓
    Course → Course Offering
         ↓
      Enrollment

USERS:
User (base)
 ├→ Administrator
 ├→ Teacher
 └→ Student

ACADEMIC FLOW:
Teacher + Course + Semester → Course Offering
Student + Course Offering → Enrollment
Enrollment → Assignments → Submissions → Grades
Enrollment → Attendance Records
```

---

## ✅ Implementation Checklist

**Backend (Laravel):**
- [ ] Copy SQL from migrations/mysql/
- [ ] Create migrations in order
- [ ] Run: `php artisan migrate`
- [ ] Seed sample data

**Frontend (Flutter):**
- [ ] Copy SQL from migrations/sqlite/
- [ ] Add to database_service.dart
- [ ] Run database creation
- [ ] Test locally

---

**Complete table definitions provided in migration files.**


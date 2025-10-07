# Institutional Tables - Complete Schema

## Tables in this file:

1. universities
2. faculties
3. departments
4. programs
5. campuses (optional)
6. buildings (optional)

---

## 1. universities

### MySQL (Laravel)

```sql
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
```

### SQLite (Flutter)

```sql
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

---

## 2. faculties

### MySQL (Laravel)

```sql
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
```

### SQLite (Flutter)

```sql
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

---

## 3. departments

### MySQL (Laravel)

```sql
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
```

### SQLite (Flutter)

```sql
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

---

## 4. programs

### MySQL (Laravel)

```sql
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
```

### SQLite (Flutter)

```sql
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

---

**File 1 of 8 - Institutional Tables Complete**

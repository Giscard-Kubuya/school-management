# Academic Period Tables - Complete Schema

## Tables in this file:
1. academic_years
2. semesters

---

## 1. academic_years

### MySQL (Laravel)
```sql
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
```

### SQLite (Flutter)
```sql
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

---

## 2. semesters

### MySQL (Laravel)
```sql
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
```

### SQLite (Flutter)
```sql
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

**File 2 of 8 - Academic Period Tables Complete**

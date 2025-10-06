# Grading & Attendance Tables - Complete Schema

## Tables in this file:
1. grades
2. grade_categories
3. grade_scales
4. class_sessions
5. attendance_records
6. attendance_excuses

---

## 1. grades

### MySQL (Laravel)
```sql
CREATE TABLE grades (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_enrollment_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,
  teacher_id VARCHAR(36) NOT NULL,

  grade_category_id VARCHAR(36), -- Midterm, Final, Assignments, etc.

  grade_item_name VARCHAR(255), -- Name of specific item being graded
  grade_item_type ENUM('assignment', 'quiz', 'exam', 'participation', 'project', 'other') DEFAULT 'other',

  points_earned DECIMAL(5,2),
  points_possible DECIMAL(5,2) NOT NULL,
  percentage DECIMAL(5,2),

  letter_grade VARCHAR(5), -- A, B+, C, etc.
  grade_points DECIMAL(3,2), -- For GPA calculation

  weight DECIMAL(5,2) DEFAULT 1.00, -- Weight in category or final grade

  comments TEXT,

  grade_status ENUM('draft', 'posted', 'final') DEFAULT 'draft',

  graded_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_enrollment_id) REFERENCES course_enrollments(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (grade_category_id) REFERENCES grade_categories(id) ON DELETE SET NULL,
  INDEX idx_grades_university (university_id),
  INDEX idx_grades_enrollment (course_enrollment_id),
  INDEX idx_grades_student (student_id),
  INDEX idx_grades_teacher (teacher_id),
  INDEX idx_grades_status (grade_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE grades (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_enrollment_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  teacher_id TEXT NOT NULL,
  grade_category_id TEXT,
  grade_item_name TEXT,
  grade_item_type TEXT DEFAULT 'other',
  points_earned REAL,
  points_possible REAL NOT NULL,
  percentage REAL,
  letter_grade TEXT,
  grade_points REAL,
  weight REAL DEFAULT 1.00,
  comments TEXT,
  grade_status TEXT DEFAULT 'draft',
  graded_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_enrollment_id) REFERENCES course_enrollments(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (grade_category_id) REFERENCES grade_categories(id) ON DELETE SET NULL
);

CREATE INDEX idx_grades_university ON grades(university_id);
CREATE INDEX idx_grades_enrollment ON grades(course_enrollment_id);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_teacher ON grades(teacher_id);
CREATE INDEX idx_grades_status ON grades(grade_status);
```

---

## 2. grade_categories

### MySQL (Laravel)
```sql
CREATE TABLE grade_categories (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_offering_id VARCHAR(36) NOT NULL,

  category_name VARCHAR(100) NOT NULL, -- Midterm Exams, Final Exam, Assignments, etc.
  description TEXT,

  weight_percentage DECIMAL(5,2) NOT NULL, -- Weight in final grade (e.g., 30%)

  drop_lowest INT DEFAULT 0, -- Number of lowest scores to drop

  category_order INT DEFAULT 1,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  INDEX idx_grade_categories_university (university_id),
  INDEX idx_grade_categories_offering (course_offering_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE grade_categories (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_offering_id TEXT NOT NULL,
  category_name TEXT NOT NULL,
  description TEXT,
  weight_percentage REAL NOT NULL,
  drop_lowest INTEGER DEFAULT 0,
  category_order INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE
);

CREATE INDEX idx_grade_categories_university ON grade_categories(university_id);
CREATE INDEX idx_grade_categories_offering ON grade_categories(course_offering_id);
```

---

## 3. grade_scales

### MySQL (Laravel)
```sql
CREATE TABLE grade_scales (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  scale_name VARCHAR(100) NOT NULL,
  description TEXT,

  scale_type ENUM('letter', 'percentage', 'points', 'pass_fail') DEFAULT 'letter',

  scale_definition JSON NOT NULL, -- [{min: 90, max: 100, grade: 'A', points: 4.0}, ...]

  is_default BOOLEAN DEFAULT FALSE,
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
  INDEX idx_grade_scales_university (university_id),
  INDEX idx_grade_scales_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE grade_scales (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  scale_name TEXT NOT NULL,
  description TEXT,
  scale_type TEXT DEFAULT 'letter',
  scale_definition TEXT NOT NULL,
  is_default INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE
);

CREATE INDEX idx_grade_scales_university ON grade_scales(university_id);
CREATE INDEX idx_grade_scales_active ON grade_scales(is_active);
```

---

## 4. class_sessions

### MySQL (Laravel)
```sql
CREATE TABLE class_sessions (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_offering_id VARCHAR(36) NOT NULL,
  teacher_id VARCHAR(36) NOT NULL,

  session_date DATE NOT NULL,
  session_time_start TIME NOT NULL,
  session_time_end TIME NOT NULL,

  session_type ENUM('lecture', 'lab', 'tutorial', 'exam', 'review') DEFAULT 'lecture',

  topic VARCHAR(255),
  description TEXT,

  classroom VARCHAR(100),

  status ENUM('scheduled', 'ongoing', 'completed', 'cancelled') DEFAULT 'scheduled',

  attendance_taken BOOLEAN DEFAULT FALSE,
  attendance_taken_at TIMESTAMP NULL,

  notes TEXT, -- Session notes/summary

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  INDEX idx_class_sessions_university (university_id),
  INDEX idx_class_sessions_offering (course_offering_id),
  INDEX idx_class_sessions_teacher (teacher_id),
  INDEX idx_class_sessions_date (session_date),
  INDEX idx_class_sessions_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE class_sessions (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_offering_id TEXT NOT NULL,
  teacher_id TEXT NOT NULL,
  session_date TEXT NOT NULL,
  session_time_start TEXT NOT NULL,
  session_time_end TEXT NOT NULL,
  session_type TEXT DEFAULT 'lecture',
  topic TEXT,
  description TEXT,
  classroom TEXT,
  status TEXT DEFAULT 'scheduled',
  attendance_taken INTEGER DEFAULT 0,
  attendance_taken_at TEXT,
  notes TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
);

CREATE INDEX idx_class_sessions_university ON class_sessions(university_id);
CREATE INDEX idx_class_sessions_offering ON class_sessions(course_offering_id);
CREATE INDEX idx_class_sessions_teacher ON class_sessions(teacher_id);
CREATE INDEX idx_class_sessions_date ON class_sessions(session_date);
CREATE INDEX idx_class_sessions_status ON class_sessions(status);
```

---

## 5. attendance_records

### MySQL (Laravel)
```sql
CREATE TABLE attendance_records (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  class_session_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,

  attendance_status ENUM('present', 'absent', 'late', 'excused') DEFAULT 'present',

  check_in_time TIME,
  check_out_time TIME,

  notes TEXT,

  marked_by VARCHAR(36), -- teacher_id or admin_id
  marked_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (class_session_id) REFERENCES class_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (marked_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY unique_attendance (class_session_id, student_id),
  INDEX idx_attendance_records_university (university_id),
  INDEX idx_attendance_records_session (class_session_id),
  INDEX idx_attendance_records_student (student_id),
  INDEX idx_attendance_records_status (attendance_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE attendance_records (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  class_session_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  attendance_status TEXT DEFAULT 'present',
  check_in_time TEXT,
  check_out_time TEXT,
  notes TEXT,
  marked_by TEXT,
  marked_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (class_session_id) REFERENCES class_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (marked_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE(class_session_id, student_id)
);

CREATE INDEX idx_attendance_records_university ON attendance_records(university_id);
CREATE INDEX idx_attendance_records_session ON attendance_records(class_session_id);
CREATE INDEX idx_attendance_records_student ON attendance_records(student_id);
CREATE INDEX idx_attendance_records_status ON attendance_records(attendance_status);
```

---

## 6. attendance_excuses

### MySQL (Laravel)
```sql
CREATE TABLE attendance_excuses (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  attendance_record_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,

  excuse_type ENUM('medical', 'family_emergency', 'official_business', 'other') DEFAULT 'other',
  reason TEXT NOT NULL,

  supporting_document VARCHAR(500), -- File path to uploaded document

  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',

  reviewed_by VARCHAR(36), -- teacher_id or admin_id
  reviewed_at TIMESTAMP NULL,
  review_comments TEXT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (attendance_record_id) REFERENCES attendance_records(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_attendance_excuses_university (university_id),
  INDEX idx_attendance_excuses_record (attendance_record_id),
  INDEX idx_attendance_excuses_student (student_id),
  INDEX idx_attendance_excuses_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE attendance_excuses (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  attendance_record_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  excuse_type TEXT DEFAULT 'other',
  reason TEXT NOT NULL,
  supporting_document TEXT,
  submitted_at TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  reviewed_by TEXT,
  reviewed_at TEXT,
  review_comments TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (attendance_record_id) REFERENCES attendance_records(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_attendance_excuses_university ON attendance_excuses(university_id);
CREATE INDEX idx_attendance_excuses_record ON attendance_excuses(attendance_record_id);
CREATE INDEX idx_attendance_excuses_student ON attendance_excuses(student_id);
CREATE INDEX idx_attendance_excuses_status ON attendance_excuses(status);
```

---

**File 7 of 8 - Grading & Attendance Tables Complete**

# Course Tables - Complete Schema

## Tables in this file:
1. courses
2. course_offerings
3. course_enrollments
4. course_prerequisites

---

## 1. courses

### MySQL (Laravel)
```sql
CREATE TABLE courses (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  department_id VARCHAR(36) NOT NULL,
  program_id VARCHAR(36),

  course_code VARCHAR(20) NOT NULL,
  course_name VARCHAR(255) NOT NULL,

  description TEXT,
  objectives TEXT,
  learning_outcomes TEXT,

  credits INT NOT NULL DEFAULT 3,
  lecture_hours INT DEFAULT 3,
  lab_hours INT DEFAULT 0,
  tutorial_hours INT DEFAULT 0,

  course_level ENUM('undergraduate', 'graduate', 'doctoral') DEFAULT 'undergraduate',
  year_level INT, -- 1st year, 2nd year, etc.

  course_type ENUM('core', 'elective', 'general_education') DEFAULT 'core',

  syllabus_file VARCHAR(255),

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
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE SET NULL,
  UNIQUE KEY unique_course_code (university_id, course_code),
  INDEX idx_courses_university (university_id),
  INDEX idx_courses_department (department_id),
  INDEX idx_courses_program (program_id),
  INDEX idx_courses_code (course_code),
  INDEX idx_courses_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  department_id TEXT NOT NULL,
  program_id TEXT,
  course_code TEXT NOT NULL,
  course_name TEXT NOT NULL,
  description TEXT,
  objectives TEXT,
  learning_outcomes TEXT,
  credits INTEGER NOT NULL DEFAULT 3,
  lecture_hours INTEGER DEFAULT 3,
  lab_hours INTEGER DEFAULT 0,
  tutorial_hours INTEGER DEFAULT 0,
  course_level TEXT DEFAULT 'undergraduate',
  year_level INTEGER,
  course_type TEXT DEFAULT 'core',
  syllabus_file TEXT,
  is_active INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE SET NULL,
  UNIQUE(university_id, course_code)
);

CREATE INDEX idx_courses_university ON courses(university_id);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_courses_program ON courses(program_id);
CREATE INDEX idx_courses_code ON courses(course_code);
CREATE INDEX idx_courses_active ON courses(is_active);
```

---

## 2. course_offerings

### MySQL (Laravel)
```sql
CREATE TABLE course_offerings (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_id VARCHAR(36) NOT NULL,
  semester_id VARCHAR(36) NOT NULL,
  teacher_id VARCHAR(36) NOT NULL,

  section VARCHAR(10), -- Section A, B, C, etc.

  max_students INT DEFAULT 50,
  enrolled_students INT DEFAULT 0,

  schedule JSON, -- Days and times: [{day: 'Monday', start: '09:00', end: '10:30', room: 'A101'}]

  classroom VARCHAR(100),

  status ENUM('draft', 'open', 'closed', 'completed', 'cancelled') DEFAULT 'draft',

  start_date DATE,
  end_date DATE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  UNIQUE KEY unique_offering (course_id, semester_id, section),
  INDEX idx_course_offerings_university (university_id),
  INDEX idx_course_offerings_course (course_id),
  INDEX idx_course_offerings_semester (semester_id),
  INDEX idx_course_offerings_teacher (teacher_id),
  INDEX idx_course_offerings_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE course_offerings (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  semester_id TEXT NOT NULL,
  teacher_id TEXT NOT NULL,
  section TEXT,
  max_students INTEGER DEFAULT 50,
  enrolled_students INTEGER DEFAULT 0,
  schedule TEXT,
  classroom TEXT,
  status TEXT DEFAULT 'draft',
  start_date TEXT,
  end_date TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  UNIQUE(course_id, semester_id, section)
);

CREATE INDEX idx_course_offerings_university ON course_offerings(university_id);
CREATE INDEX idx_course_offerings_course ON course_offerings(course_id);
CREATE INDEX idx_course_offerings_semester ON course_offerings(semester_id);
CREATE INDEX idx_course_offerings_teacher ON course_offerings(teacher_id);
CREATE INDEX idx_course_offerings_status ON course_offerings(status);
```

---

## 3. course_enrollments

### MySQL (Laravel)
```sql
CREATE TABLE course_enrollments (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_offering_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,

  enrollment_status ENUM('pending', 'enrolled', 'dropped', 'withdrawn', 'completed') DEFAULT 'pending',

  enrollment_date DATE NOT NULL,
  drop_date DATE,
  withdrawal_date DATE,

  grade VARCHAR(5), -- Final grade
  grade_points DECIMAL(3,2), -- GPA points
  grade_status ENUM('in_progress', 'graded', 'incomplete', 'pass', 'fail'),

  attendance_percentage DECIMAL(5,2) DEFAULT 0.00,

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
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  UNIQUE KEY unique_enrollment (course_offering_id, student_id),
  INDEX idx_course_enrollments_university (university_id),
  INDEX idx_course_enrollments_offering (course_offering_id),
  INDEX idx_course_enrollments_student (student_id),
  INDEX idx_course_enrollments_status (enrollment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE course_enrollments (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_offering_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  enrollment_status TEXT DEFAULT 'pending',
  enrollment_date TEXT NOT NULL,
  drop_date TEXT,
  withdrawal_date TEXT,
  grade TEXT,
  grade_points REAL,
  grade_status TEXT,
  attendance_percentage REAL DEFAULT 0.00,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  UNIQUE(course_offering_id, student_id)
);

CREATE INDEX idx_course_enrollments_university ON course_enrollments(university_id);
CREATE INDEX idx_course_enrollments_offering ON course_enrollments(course_offering_id);
CREATE INDEX idx_course_enrollments_student ON course_enrollments(student_id);
CREATE INDEX idx_course_enrollments_status ON course_enrollments(enrollment_status);
```

---

## 4. course_prerequisites

### MySQL (Laravel)
```sql
CREATE TABLE course_prerequisites (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  course_id VARCHAR(36) NOT NULL, -- The course that has prerequisites
  prerequisite_course_id VARCHAR(36) NOT NULL, -- The required prerequisite course

  minimum_grade VARCHAR(5), -- Minimum grade required (e.g., 'C', 'B')

  is_mandatory BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (prerequisite_course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_prerequisite (course_id, prerequisite_course_id),
  INDEX idx_course_prerequisites_university (university_id),
  INDEX idx_course_prerequisites_course (course_id),
  INDEX idx_course_prerequisites_prerequisite (prerequisite_course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE course_prerequisites (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  prerequisite_course_id TEXT NOT NULL,
  minimum_grade TEXT,
  is_mandatory INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (prerequisite_course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE(course_id, prerequisite_course_id)
);

CREATE INDEX idx_course_prerequisites_university ON course_prerequisites(university_id);
CREATE INDEX idx_course_prerequisites_course ON course_prerequisites(course_id);
CREATE INDEX idx_course_prerequisites_prerequisite ON course_prerequisites(prerequisite_course_id);
```

---

**File 5 of 8 - Course Tables Complete**

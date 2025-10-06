# Assignment Tables - Complete Schema

## Tables in this file:
1. assignments
2. assignment_submissions
3. assignment_questions
4. assignment_rubrics
5. submission_files

---

## 1. assignments

### MySQL (Laravel)
```sql
CREATE TABLE assignments (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_offering_id VARCHAR(36) NOT NULL,
  teacher_id VARCHAR(36) NOT NULL,

  title VARCHAR(255) NOT NULL,
  description TEXT,
  instructions TEXT,

  assignment_type ENUM('homework', 'quiz', 'exam', 'project', 'lab', 'essay') DEFAULT 'homework',

  total_points DECIMAL(5,2) NOT NULL DEFAULT 100.00,
  weight_percentage DECIMAL(5,2) DEFAULT 10.00, -- Weight in final grade

  due_date TIMESTAMP NOT NULL,
  available_from TIMESTAMP,
  available_until TIMESTAMP,

  late_submission_allowed BOOLEAN DEFAULT FALSE,
  late_penalty_percentage DECIMAL(5,2) DEFAULT 0.00,

  max_attempts INT DEFAULT 1,
  time_limit_minutes INT, -- For timed assignments

  allow_file_upload BOOLEAN DEFAULT TRUE,
  max_file_size_mb INT DEFAULT 10,
  allowed_file_types VARCHAR(255), -- Comma-separated: pdf,doc,docx

  grading_type ENUM('manual', 'automatic', 'rubric') DEFAULT 'manual',

  status ENUM('draft', 'published', 'closed', 'grading', 'graded') DEFAULT 'draft',

  published_at TIMESTAMP NULL,

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
  INDEX idx_assignments_university (university_id),
  INDEX idx_assignments_offering (course_offering_id),
  INDEX idx_assignments_teacher (teacher_id),
  INDEX idx_assignments_status (status),
  INDEX idx_assignments_due_date (due_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE assignments (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_offering_id TEXT NOT NULL,
  teacher_id TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  instructions TEXT,
  assignment_type TEXT DEFAULT 'homework',
  total_points REAL NOT NULL DEFAULT 100.00,
  weight_percentage REAL DEFAULT 10.00,
  due_date TEXT NOT NULL,
  available_from TEXT,
  available_until TEXT,
  late_submission_allowed INTEGER DEFAULT 0,
  late_penalty_percentage REAL DEFAULT 0.00,
  max_attempts INTEGER DEFAULT 1,
  time_limit_minutes INTEGER,
  allow_file_upload INTEGER DEFAULT 1,
  max_file_size_mb INTEGER DEFAULT 10,
  allowed_file_types TEXT,
  grading_type TEXT DEFAULT 'manual',
  status TEXT DEFAULT 'draft',
  published_at TEXT,
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

CREATE INDEX idx_assignments_university ON assignments(university_id);
CREATE INDEX idx_assignments_offering ON assignments(course_offering_id);
CREATE INDEX idx_assignments_teacher ON assignments(teacher_id);
CREATE INDEX idx_assignments_status ON assignments(status);
CREATE INDEX idx_assignments_due_date ON assignments(due_date);
```

---

## 2. assignment_submissions

### MySQL (Laravel)
```sql
CREATE TABLE assignment_submissions (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  assignment_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,

  attempt_number INT DEFAULT 1,

  submission_text TEXT, -- Text answer/response
  submission_data JSON, -- For structured data (quiz answers, etc.)

  submitted_at TIMESTAMP NULL,
  submission_status ENUM('draft', 'submitted', 'late', 'graded', 'returned') DEFAULT 'draft',

  is_late BOOLEAN DEFAULT FALSE,
  late_penalty_applied DECIMAL(5,2) DEFAULT 0.00,

  score DECIMAL(5,2), -- Points earned
  percentage DECIMAL(5,2), -- Percentage score

  feedback TEXT,
  graded_by VARCHAR(36), -- teacher_id
  graded_at TIMESTAMP NULL,

  -- Time tracking
  started_at TIMESTAMP,
  time_spent_minutes INT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (graded_by) REFERENCES teachers(id) ON DELETE SET NULL,
  UNIQUE KEY unique_submission (assignment_id, student_id, attempt_number),
  INDEX idx_submissions_university (university_id),
  INDEX idx_submissions_assignment (assignment_id),
  INDEX idx_submissions_student (student_id),
  INDEX idx_submissions_status (submission_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE assignment_submissions (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  assignment_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  attempt_number INTEGER DEFAULT 1,
  submission_text TEXT,
  submission_data TEXT,
  submitted_at TEXT,
  submission_status TEXT DEFAULT 'draft',
  is_late INTEGER DEFAULT 0,
  late_penalty_applied REAL DEFAULT 0.00,
  score REAL,
  percentage REAL,
  feedback TEXT,
  graded_by TEXT,
  graded_at TEXT,
  started_at TEXT,
  time_spent_minutes INTEGER,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (graded_by) REFERENCES teachers(id) ON DELETE SET NULL,
  UNIQUE(assignment_id, student_id, attempt_number)
);

CREATE INDEX idx_submissions_university ON assignment_submissions(university_id);
CREATE INDEX idx_submissions_assignment ON assignment_submissions(assignment_id);
CREATE INDEX idx_submissions_student ON assignment_submissions(student_id);
CREATE INDEX idx_submissions_status ON assignment_submissions(submission_status);
```

---

## 3. assignment_questions

### MySQL (Laravel)
```sql
CREATE TABLE assignment_questions (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  assignment_id VARCHAR(36) NOT NULL,

  question_order INT NOT NULL,
  question_text TEXT NOT NULL,

  question_type ENUM('multiple_choice', 'true_false', 'short_answer', 'essay', 'file_upload') NOT NULL,

  options JSON, -- For multiple choice: ["Option A", "Option B", ...]
  correct_answer TEXT, -- For auto-grading

  points DECIMAL(5,2) NOT NULL DEFAULT 1.00,

  required BOOLEAN DEFAULT TRUE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
  INDEX idx_assignment_questions_university (university_id),
  INDEX idx_assignment_questions_assignment (assignment_id),
  INDEX idx_assignment_questions_order (question_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE assignment_questions (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  assignment_id TEXT NOT NULL,
  question_order INTEGER NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL,
  options TEXT,
  correct_answer TEXT,
  points REAL NOT NULL DEFAULT 1.00,
  required INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
);

CREATE INDEX idx_assignment_questions_university ON assignment_questions(university_id);
CREATE INDEX idx_assignment_questions_assignment ON assignment_questions(assignment_id);
CREATE INDEX idx_assignment_questions_order ON assignment_questions(question_order);
```

---

## 4. assignment_rubrics

### MySQL (Laravel)
```sql
CREATE TABLE assignment_rubrics (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  assignment_id VARCHAR(36) NOT NULL,

  criteria_name VARCHAR(255) NOT NULL,
  description TEXT,

  max_points DECIMAL(5,2) NOT NULL,

  levels JSON, -- Rubric levels: [{level: 'Excellent', points: 10, description: '...'}, ...]

  criteria_order INT DEFAULT 1,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
  INDEX idx_assignment_rubrics_university (university_id),
  INDEX idx_assignment_rubrics_assignment (assignment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE assignment_rubrics (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  assignment_id TEXT NOT NULL,
  criteria_name TEXT NOT NULL,
  description TEXT,
  max_points REAL NOT NULL,
  levels TEXT,
  criteria_order INTEGER DEFAULT 1,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
);

CREATE INDEX idx_assignment_rubrics_university ON assignment_rubrics(university_id);
CREATE INDEX idx_assignment_rubrics_assignment ON assignment_rubrics(assignment_id);
```

---

## 5. submission_files

### MySQL (Laravel)
```sql
CREATE TABLE submission_files (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  submission_id VARCHAR(36) NOT NULL,

  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size_kb INT,
  file_type VARCHAR(50),
  mime_type VARCHAR(100),

  upload_status ENUM('uploading', 'completed', 'failed') DEFAULT 'completed',

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (submission_id) REFERENCES assignment_submissions(id) ON DELETE CASCADE,
  INDEX idx_submission_files_university (university_id),
  INDEX idx_submission_files_submission (submission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE submission_files (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  submission_id TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_size_kb INTEGER,
  file_type TEXT,
  mime_type TEXT,
  upload_status TEXT DEFAULT 'completed',
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (submission_id) REFERENCES assignment_submissions(id) ON DELETE CASCADE
);

CREATE INDEX idx_submission_files_university ON submission_files(university_id);
CREATE INDEX idx_submission_files_submission ON submission_files(submission_id);
```

---

**File 6 of 8 - Assignment Tables Complete**

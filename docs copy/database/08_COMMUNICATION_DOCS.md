# Communication & Document Tables - Complete Schema

## Tables in this file:
1. messages
2. announcements
3. notifications
4. message_attachments
5. document_folders
6. documents
7. course_materials
8. document_downloads

---

## 1. messages

### MySQL (Laravel)
```sql
CREATE TABLE messages (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  sender_id VARCHAR(36) NOT NULL,
  receiver_id VARCHAR(36) NOT NULL,

  subject VARCHAR(255),
  message_body TEXT NOT NULL,

  message_type ENUM('direct', 'course', 'announcement') DEFAULT 'direct',

  course_offering_id VARCHAR(36), -- If message is course-related

  parent_message_id VARCHAR(36), -- For threaded conversations

  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP NULL,

  priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_message_id) REFERENCES messages(id) ON DELETE SET NULL,
  INDEX idx_messages_university (university_id),
  INDEX idx_messages_sender (sender_id),
  INDEX idx_messages_receiver (receiver_id),
  INDEX idx_messages_course (course_offering_id),
  INDEX idx_messages_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  receiver_id TEXT NOT NULL,
  subject TEXT,
  message_body TEXT NOT NULL,
  message_type TEXT DEFAULT 'direct',
  course_offering_id TEXT,
  parent_message_id TEXT,
  is_read INTEGER DEFAULT 0,
  read_at TEXT,
  priority TEXT DEFAULT 'normal',
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_message_id) REFERENCES messages(id) ON DELETE SET NULL
);

CREATE INDEX idx_messages_university ON messages(university_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_receiver ON messages(receiver_id);
CREATE INDEX idx_messages_course ON messages(course_offering_id);
CREATE INDEX idx_messages_read ON messages(is_read);
```

---

## 2. announcements

### MySQL (Laravel)
```sql
CREATE TABLE announcements (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  author_id VARCHAR(36) NOT NULL,

  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,

  announcement_type ENUM('university', 'faculty', 'department', 'course') DEFAULT 'university',

  target_audience ENUM('all', 'students', 'teachers', 'staff') DEFAULT 'all',

  faculty_id VARCHAR(36),
  department_id VARCHAR(36),
  course_offering_id VARCHAR(36),

  priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',

  is_pinned BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT FALSE,

  published_at TIMESTAMP NULL,
  expires_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  INDEX idx_announcements_university (university_id),
  INDEX idx_announcements_author (author_id),
  INDEX idx_announcements_type (announcement_type),
  INDEX idx_announcements_published (is_published),
  INDEX idx_announcements_pinned (is_pinned)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE announcements (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  author_id TEXT NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  announcement_type TEXT DEFAULT 'university',
  target_audience TEXT DEFAULT 'all',
  faculty_id TEXT,
  department_id TEXT,
  course_offering_id TEXT,
  priority TEXT DEFAULT 'normal',
  is_pinned INTEGER DEFAULT 0,
  is_published INTEGER DEFAULT 0,
  published_at TEXT,
  expires_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE
);

CREATE INDEX idx_announcements_university ON announcements(university_id);
CREATE INDEX idx_announcements_author ON announcements(author_id);
CREATE INDEX idx_announcements_type ON announcements(announcement_type);
CREATE INDEX idx_announcements_published ON announcements(is_published);
CREATE INDEX idx_announcements_pinned ON announcements(is_pinned);
```

---

## 3. notifications

### MySQL (Laravel)
```sql
CREATE TABLE notifications (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  user_id VARCHAR(36) NOT NULL,

  notification_type ENUM('message', 'assignment', 'grade', 'announcement', 'attendance', 'system') NOT NULL,

  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,

  related_entity_type VARCHAR(50), -- e.g., 'assignment', 'message', 'grade'
  related_entity_id VARCHAR(36), -- ID of the related entity

  priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',

  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP NULL,

  action_url VARCHAR(500), -- Deep link or URL to relevant screen

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
  INDEX idx_notifications_university (university_id),
  INDEX idx_notifications_user (user_id),
  INDEX idx_notifications_type (notification_type),
  INDEX idx_notifications_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  notification_type TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  related_entity_type TEXT,
  related_entity_id TEXT,
  priority TEXT DEFAULT 'normal',
  is_read INTEGER DEFAULT 0,
  read_at TEXT,
  action_url TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_notifications_university ON notifications(university_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
CREATE INDEX idx_notifications_read ON notifications(is_read);
```

---

## 4. message_attachments

### MySQL (Laravel)
```sql
CREATE TABLE message_attachments (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  message_id VARCHAR(36) NOT NULL,

  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size_kb INT,
  file_type VARCHAR(50),
  mime_type VARCHAR(100),

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
  INDEX idx_message_attachments_university (university_id),
  INDEX idx_message_attachments_message (message_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE message_attachments (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  message_id TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_size_kb INTEGER,
  file_type TEXT,
  mime_type TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE
);

CREATE INDEX idx_message_attachments_university ON message_attachments(university_id);
CREATE INDEX idx_message_attachments_message ON message_attachments(message_id);
```

---

## 5. document_folders

### MySQL (Laravel)
```sql
CREATE TABLE document_folders (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  folder_name VARCHAR(255) NOT NULL,
  description TEXT,

  parent_folder_id VARCHAR(36), -- For nested folder structure

  folder_type ENUM('personal', 'course', 'department', 'public') DEFAULT 'personal',

  owner_id VARCHAR(36) NOT NULL, -- user_id who owns this folder
  course_offering_id VARCHAR(36), -- If folder is course-specific

  is_shared BOOLEAN DEFAULT FALSE,
  is_public BOOLEAN DEFAULT FALSE,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_folder_id) REFERENCES document_folders(id) ON DELETE CASCADE,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE,
  INDEX idx_document_folders_university (university_id),
  INDEX idx_document_folders_parent (parent_folder_id),
  INDEX idx_document_folders_owner (owner_id),
  INDEX idx_document_folders_course (course_offering_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE document_folders (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  folder_name TEXT NOT NULL,
  description TEXT,
  parent_folder_id TEXT,
  folder_type TEXT DEFAULT 'personal',
  owner_id TEXT NOT NULL,
  course_offering_id TEXT,
  is_shared INTEGER DEFAULT 0,
  is_public INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_folder_id) REFERENCES document_folders(id) ON DELETE CASCADE,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE
);

CREATE INDEX idx_document_folders_university ON document_folders(university_id);
CREATE INDEX idx_document_folders_parent ON document_folders(parent_folder_id);
CREATE INDEX idx_document_folders_owner ON document_folders(owner_id);
CREATE INDEX idx_document_folders_course ON document_folders(course_offering_id);
```

---

## 6. documents

### MySQL (Laravel)
```sql
CREATE TABLE documents (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  folder_id VARCHAR(36),

  document_name VARCHAR(255) NOT NULL,
  description TEXT,

  file_path VARCHAR(500) NOT NULL,
  file_size_kb INT,
  file_type VARCHAR(50),
  mime_type VARCHAR(100),

  owner_id VARCHAR(36) NOT NULL,

  document_type ENUM('syllabus', 'lecture_notes', 'assignment', 'reading', 'other') DEFAULT 'other',

  version INT DEFAULT 1,
  previous_version_id VARCHAR(36), -- Link to previous version

  is_public BOOLEAN DEFAULT FALSE,
  download_count INT DEFAULT 0,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (folder_id) REFERENCES document_folders(id) ON DELETE SET NULL,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (previous_version_id) REFERENCES documents(id) ON DELETE SET NULL,
  INDEX idx_documents_university (university_id),
  INDEX idx_documents_folder (folder_id),
  INDEX idx_documents_owner (owner_id),
  INDEX idx_documents_type (document_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE documents (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  folder_id TEXT,
  document_name TEXT NOT NULL,
  description TEXT,
  file_path TEXT NOT NULL,
  file_size_kb INTEGER,
  file_type TEXT,
  mime_type TEXT,
  owner_id TEXT NOT NULL,
  document_type TEXT DEFAULT 'other',
  version INTEGER DEFAULT 1,
  previous_version_id TEXT,
  is_public INTEGER DEFAULT 0,
  download_count INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (folder_id) REFERENCES document_folders(id) ON DELETE SET NULL,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (previous_version_id) REFERENCES documents(id) ON DELETE SET NULL
);

CREATE INDEX idx_documents_university ON documents(university_id);
CREATE INDEX idx_documents_folder ON documents(folder_id);
CREATE INDEX idx_documents_owner ON documents(owner_id);
CREATE INDEX idx_documents_type ON documents(document_type);
```

---

## 7. course_materials

### MySQL (Laravel)
```sql
CREATE TABLE course_materials (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  course_offering_id VARCHAR(36) NOT NULL,
  document_id VARCHAR(36) NOT NULL,

  material_type ENUM('syllabus', 'lecture', 'reading', 'reference', 'assignment_resource') DEFAULT 'lecture',

  week_number INT,
  topic VARCHAR(255),

  is_required BOOLEAN DEFAULT TRUE,

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
  FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
  INDEX idx_course_materials_university (university_id),
  INDEX idx_course_materials_offering (course_offering_id),
  INDEX idx_course_materials_document (document_id),
  INDEX idx_course_materials_week (week_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE course_materials (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  course_offering_id TEXT NOT NULL,
  document_id TEXT NOT NULL,
  material_type TEXT DEFAULT 'lecture',
  week_number INTEGER,
  topic TEXT,
  is_required INTEGER DEFAULT 1,
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
  FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
);

CREATE INDEX idx_course_materials_university ON course_materials(university_id);
CREATE INDEX idx_course_materials_offering ON course_materials(course_offering_id);
CREATE INDEX idx_course_materials_document ON course_materials(document_id);
CREATE INDEX idx_course_materials_week ON course_materials(week_number);
```

---

## 8. document_downloads

### MySQL (Laravel)
```sql
CREATE TABLE document_downloads (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  document_id VARCHAR(36) NOT NULL,
  user_id VARCHAR(36) NOT NULL,

  download_type ENUM('view', 'download') DEFAULT 'download',

  ip_address VARCHAR(45),
  user_agent TEXT,

  downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_document_downloads_university (university_id),
  INDEX idx_document_downloads_document (document_id),
  INDEX idx_document_downloads_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)
```sql
CREATE TABLE document_downloads (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  document_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  download_type TEXT DEFAULT 'download',
  ip_address TEXT,
  user_agent TEXT,
  downloaded_at TEXT NOT NULL,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_document_downloads_university ON document_downloads(university_id);
CREATE INDEX idx_document_downloads_document ON document_downloads(document_id);
CREATE INDEX idx_document_downloads_user ON document_downloads(user_id);
```

---

**File 8 of 8 - Communication & Document Tables Complete**

## 🎉 DATABASE SCHEMA COMPLETE

All **38 tables** have been created with both **MySQL (Laravel)** and **SQLite (Flutter)** versions:

### Summary by Category:
1. **Institutional Tables (4)**: universities, faculties, departments, programs
2. **Academic Periods (2)**: academic_years, semesters
3. **User Management (5)**: users, administrators, teachers, students, user_sessions
4. **Device & Auth (3)**: device_configurations, device_registrations, pending_accounts
5. **Courses (4)**: courses, course_offerings, course_enrollments, course_prerequisites
6. **Assignments (5)**: assignments, assignment_submissions, assignment_questions, assignment_rubrics, submission_files
7. **Grading & Attendance (6)**: grades, grade_categories, grade_scales, class_sessions, attendance_records, attendance_excuses
8. **Communication & Documents (8)**: messages, announcements, notifications, message_attachments, document_folders, documents, course_materials, document_downloads

**Total: 38 Tables** ✅

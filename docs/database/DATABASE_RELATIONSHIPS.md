# Database Relationships - Visual Guide

## 📊 Complete Entity Relationship Overview

This document visualizes all relationships between the 38 tables in the School Management System.

---

## 🏗️ Hierarchical Structure

### Academic Hierarchy Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     INSTITUTIONAL HIERARCHY                         │
└─────────────────────────────────────────────────────────────────────┘

    universities (1)
         │
         │ 1:N
         ▼
    faculties (N)
         │
         │ 1:N
         ▼
    departments (N)
         │
         │ 1:N
         ▼
    programs (N)

┌─────────────────────────────────────────────────────────────────────┐
│                     ACADEMIC PERIODS                                │
└─────────────────────────────────────────────────────────────────────┘

    universities (1)
         │
         │ 1:N
         ▼
    academic_years (N)
         │
         │ 1:N
         ▼
    semesters (N)

┌─────────────────────────────────────────────────────────────────────┐
│                     COURSE FLOW                                     │
└─────────────────────────────────────────────────────────────────────┘

    departments (1) ──┐
                      │
    semesters (1) ────┼──→ course_offerings (N)
                      │          │
    courses (1) ──────┘          │
                                 │ 1:N
    teachers (1) ────────────────┘
                                 │
                                 │ 1:N
                                 ▼
                        course_enrollments (N)
                                 │
                                 │ N:1
                                 ▼
                            students (1)
```

---

## 👥 User Management Structure

### User Type Hierarchy (Polymorphic)

```
┌─────────────────────────────────────────────────────────────────────┐
│                          USERS (BASE)                               │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │ id, university_id, username, email, password                 │  │
│  │ user_type: 'admin' | 'teacher' | 'student'                   │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                             │
                    ┌────────┴────────┬──────────┐
                    │                 │          │
                    ▼                 ▼          ▼
            ┌───────────────┐  ┌────────────┐  ┌─────────────┐
            │ administrators│  │  teachers  │  │  students   │
            ├───────────────┤  ├────────────┤  ├─────────────┤
            │ - user_id (1:1)│  │ - user_id  │  │ - user_id   │
            │ - admin_level │  │ - dept_id  │  │ - program_id│
            │ - permissions │  │ - emp_id   │  │ - student_id│
            └───────────────┘  └────────────┘  └─────────────┘
```

### User Session Tracking

```
    users (1)
      │
      │ 1:N
      ▼
    user_sessions (N)
      │
      │ N:1
      ▼
    device_configurations (1)
```

---

## 🔐 Device Authentication Flow

### Device Configuration Chain

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DEVICE AUTHENTICATION                            │
└─────────────────────────────────────────────────────────────────────┘

    universities (1)
         │
         │ 1:N
         ▼
    device_configurations (N)
         │
         │ 1:N
         ▼
    device_registrations (N)
         │
         │ N:1
         ▼
    users (1)

    universities (1)
         │
         │ 1:N
         ▼
    pending_accounts (N)
         │
         │ N:1 (approved_by)
         ▼
    users (admin) (1)
```

---

## 📚 Course & Enrollment Flow

### Complete Course Journey

```
┌─────────────────────────────────────────────────────────────────────┐
│                      COURSE LIFECYCLE                               │
└─────────────────────────────────────────────────────────────────────┘

    courses (master definition)
         │
         │ 1:N
         ▼
    course_prerequisites
         │
         │ N:1
         ▼
    courses (prerequisite)

    courses (1) ──┐
                  │
    semesters (1) ├──→ course_offerings (semester instance)
                  │            │
    teachers (1) ─┘            │ 1:N
                               ▼
                      course_enrollments
                               │
                               │ N:1
                               ▼
                          students (1)
```

---

## 📝 Assignment & Grading Flow

### Assignment Lifecycle

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ASSIGNMENT FLOW                                  │
└─────────────────────────────────────────────────────────────────────┘

    course_offerings (1)
         │
         │ 1:N
         ▼
    assignments (N)
         │
         ├─── 1:N ──→ assignment_questions (N)
         │
         ├─── 1:N ──→ assignment_rubrics (N)
         │
         └─── 1:N ──→ assignment_submissions (N)
                           │
                           │ N:1
                           ├──→ students (1)
                           │
                           └─── 1:N ──→ submission_files (N)
```

### Grading System

```
┌─────────────────────────────────────────────────────────────────────┐
│                      GRADING SYSTEM                                 │
└─────────────────────────────────────────────────────────────────────┘

    universities (1)
         │
         │ 1:N
         ▼
    grade_scales (N)

    course_offerings (1)
         │
         │ 1:N
         ▼
    grade_categories (N)
         │
         │ 1:N
         ▼
    grades (N)
         │
         │ N:1
         ├──→ students (1)
         │
         └──→ course_enrollments (1)
```

---

## 📊 Attendance System

### Attendance Tracking Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ATTENDANCE SYSTEM                                │
└─────────────────────────────────────────────────────────────────────┘

    course_offerings (1)
         │
         │ 1:N
         ▼
    class_sessions (N)
         │
         │ 1:N
         ▼
    attendance_records (N)
         │
         │ N:1
         ├──→ students (1)
         │
         └─── 1:N ──→ attendance_excuses (N)
                           │
                           │ N:1 (reviewed_by)
                           └──→ users (1)
```

---

## 💬 Communication System

### Messaging & Announcements

```
┌─────────────────────────────────────────────────────────────────────┐
│                   COMMUNICATION SYSTEM                              │
└─────────────────────────────────────────────────────────────────────┘

    users (sender) (1)
         │
         │ 1:N
         ▼
    messages (N)
         │
         │ N:1
         ├──→ users (receiver) (1)
         │
         ├──→ course_offerings (1) [optional]
         │
         └─── 1:N ──→ message_attachments (N)

    users (author) (1)
         │
         │ 1:N
         ▼
    announcements (N)
         │
         │ N:1
         ├──→ faculties (1) [optional]
         ├──→ departments (1) [optional]
         └──→ course_offerings (1) [optional]

    users (1)
         │
         │ 1:N
         ▼
    notifications (N)
```

---

## 📄 Document Management

### Document Organization

```
┌─────────────────────────────────────────────────────────────────────┐
│                   DOCUMENT MANAGEMENT                               │
└─────────────────────────────────────────────────────────────────────┘

    users (owner) (1)
         │
         │ 1:N
         ▼
    document_folders (N)
         │
         │ 1:N (can be nested)
         ├──→ document_folders (children)
         │
         └─── 1:N ──→ documents (N)
                           │
                           │ 1:N
                           ├──→ course_materials (N)
                           │         │
                           │         │ N:1
                           │         └──→ course_offerings (1)
                           │
                           └─── 1:N ──→ document_downloads (N)
                                         │
                                         │ N:1
                                         └──→ users (1)
```

---

## 🔗 Cross-Table Relationships

### Key Foreign Key Relationships

```
ALL TABLES (38)
    │
    │ N:1 (Multi-tenant)
    ▼
universities (1)

users (base)
    │
    ├── 1:1 → administrators
    ├── 1:1 → teachers
    └── 1:1 → students

departments (1)
    │
    ├── 1:N → teachers
    ├── 1:N → programs
    └── 1:N → courses

students (1)
    │
    ├── N:1 → programs
    ├── 1:N → course_enrollments
    ├── 1:N → assignment_submissions
    ├── 1:N → grades
    └── 1:N → attendance_records

teachers (1)
    │
    ├── 1:N → course_offerings
    ├── 1:N → assignments
    └── 1:N → class_sessions
```

---

## 📊 Relationship Summary Table

| Table | Primary Relations | Foreign Keys |
|-------|------------------|--------------|
| **universities** | Root entity | - |
| **faculties** | universities (1:N) | university_id |
| **departments** | faculties (1:N), universities | faculty_id, university_id |
| **programs** | departments (1:N), faculties, universities | department_id, faculty_id, university_id |
| **academic_years** | universities (1:N) | university_id |
| **semesters** | academic_years (1:N), universities | academic_year_id, university_id |
| **users** | universities (1:N) | university_id |
| **administrators** | users (1:1), universities | user_id, university_id |
| **teachers** | users (1:1), departments (N:1) | user_id, department_id, university_id |
| **students** | users (1:1), programs (N:1) | user_id, program_id, university_id |
| **courses** | departments (1:N), programs | department_id, program_id, university_id |
| **course_offerings** | courses (1:N), semesters (1:N), teachers (1:N) | course_id, semester_id, teacher_id |
| **course_enrollments** | course_offerings (1:N), students (1:N) | course_offering_id, student_id |
| **assignments** | course_offerings (1:N), teachers (1:N) | course_offering_id, teacher_id |
| **assignment_submissions** | assignments (1:N), students (1:N) | assignment_id, student_id |
| **grades** | course_enrollments (1:N), students (1:N) | course_enrollment_id, student_id |
| **class_sessions** | course_offerings (1:N), teachers (1:N) | course_offering_id, teacher_id |
| **attendance_records** | class_sessions (1:N), students (1:N) | class_session_id, student_id |
| **messages** | users (sender) (1:N), users (receiver) | sender_id, receiver_id |
| **documents** | users (owner) (1:N), document_folders | owner_id, folder_id |

---

## 🎯 Data Flow Patterns

### Student Enrollment Journey

```
1. Student Registration
   User → pending_accounts → approval → Student

2. Course Enrollment
   Student → course_offerings → course_enrollments

3. Assignment Submission
   course_enrollments → assignments → assignment_submissions

4. Grading
   assignment_submissions → grades → course_enrollments

5. Attendance
   course_offerings → class_sessions → attendance_records

6. Final Grade
   All grades → course_enrollments.grade → Student.gpa
```

### Teacher Workflow

```
1. Teacher Setup
   User → Teacher → Department assignment

2. Course Assignment
   Teacher + Course + Semester → course_offering

3. Assignment Creation
   course_offering → assignments → questions/rubrics

4. Student Management
   course_offering → course_enrollments → students

5. Grading
   assignment_submissions → grades
   attendance_records → attendance grading

6. Communication
   Teacher → messages/announcements → Students
```

---

## 📈 Cascade Delete Behavior

### Delete Cascades

```
universities (DELETE)
    ↓ CASCADE
    All related records deleted

users (DELETE)
    ↓ CASCADE
    administrators/teachers/students deleted
    user_sessions deleted
    ↓ SET NULL
    approved_by references set to NULL

course_offerings (DELETE)
    ↓ CASCADE
    course_enrollments deleted
    assignments deleted
    class_sessions deleted
    ↓ CASCADE (chain)
    assignment_submissions deleted
    grades deleted
    attendance_records deleted
```

---

## 🔍 Indexing Strategy

### Primary Indexes

All tables have indexes on:
- `id` (Primary Key)
- `university_id` (Multi-tenant isolation)
- Foreign key columns
- Status/type fields
- Frequently queried columns

### Example Indexes

```sql
-- Users
INDEX idx_users_university (university_id)
INDEX idx_users_type (user_type)
INDEX idx_users_email (email)

-- Course Enrollments
INDEX idx_enrollments_offering (course_offering_id)
INDEX idx_enrollments_student (student_id)
INDEX idx_enrollments_status (enrollment_status)

-- Grades
INDEX idx_grades_student (student_id)
INDEX idx_grades_enrollment (course_enrollment_id)
INDEX idx_grades_status (grade_status)
```

---

## ✅ Relationship Validation Rules

### Referential Integrity Rules

1. **Multi-tenant Isolation**
   - All entities must belong to same university
   - Cross-university references forbidden

2. **Academic Hierarchy**
   - Program must belong to Department's Faculty
   - Department must belong to Faculty's University

3. **Course Offering**
   - Teacher must belong to same university
   - Course must exist in department
   - Semester must be active for enrollment

4. **Enrollment**
   - Student must be enrolled in program
   - Course offering must be available
   - Prerequisites must be satisfied

5. **Grading**
   - Grade must reference valid enrollment
   - Grade scale must match university policy

---

**Complete database relationships documented.**
**See individual table files in [database/](.) folder for detailed schemas.**

**Total Tables**: 38
**Total Relationships**: 80+
**Status**: ✅ Complete

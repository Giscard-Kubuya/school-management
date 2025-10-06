/// Centralized Database Schema
/// 
/// This file imports and combines all individual schema files to provide
/// a single source of truth for the entire database schema.

// Import all schema files
import 'package:school_management_app/core/data/database/institutional_tables.dart' as institutional;
import 'package:school_management_app/core/data/database/academic_periods.dart' as academic;
import 'package:school_management_app/core/data/database/user_management.dart' as user_management;
import 'package:school_management_app/core/data/database/device_auth.dart' as device_auth;
import 'package:school_management_app/core/data/database/courses.dart' as courses;
import 'package:school_management_app/core/data/database/assignments.dart' as assignments;
import 'package:school_management_app/core/data/database/grading_attendance.dart' as grading_attendance;
import 'package:school_management_app/core/data/database/communication_docs.dart' as communication_docs;
import 'package:school_management_app/core/data/database/finance_payment.dart' as finance_payment;

class DatabaseSchema {
  // Database version - increment this when making schema changes
  static const int version = 1;
  
  // Database name
  static const String databaseName = 'school_management.db';

  // Get all table creation statements from all schemas
  static List<String> get createTableStatements => [
    // Institutional tables
    ...institutional.InstitutionalTablesSchema.createTableStatements,
    ...academic.AcademicPeriodsSchema.createTableStatements,
    
    // User and authentication
    ...user_management.UserManagementSchema.createTableStatements,
    ...device_auth.DeviceAuthSchema.createTableStatements,
    
    // Academic
    ...courses.CoursesSchema.createTableStatements,
    ...assignments.AssignmentsSchema.createTableStatements,
    
    // Grading and attendance
    ...grading_attendance.GradingAttendanceSchema.createTableStatements,
    
    // Communication and documents
    ...communication_docs.CommunicationDocsSchema.createTableStatements,
    
    // Finance and payments
    ...finance_payment.FinancePaymentSchema.createTableStatements,
  ];

  // Get all index creation statements from all schemas
  static List<String> get createIndexStatements => [
    // Institutional indexes
    ...institutional.InstitutionalTablesSchema.createIndexStatements,
    ...academic.AcademicPeriodsSchema.createIndexStatements,
    
    // User and authentication indexes
    ...user_management.UserManagementSchema.createIndexStatements,
    ...device_auth.DeviceAuthSchema.createIndexStatements,
    
    // Academic indexes
    ...courses.CoursesSchema.createIndexStatements,
    ...assignments.AssignmentsSchema.createIndexStatements,
    
    // Grading and attendance indexes
    ...grading_attendance.GradingAttendanceSchema.createIndexStatements,
    
    // Communication and documents indexes
    ...communication_docs.CommunicationDocsSchema.createIndexStatements,
    
    // Finance and payments indexes
    ...finance_payment.FinancePaymentSchema.createIndexStatements,
  ];

  // Get all schema validation queries (for checking if tables exist)
  static Map<String, String> get tableExistenceQueries => {
    // Institutional tables
    'universities': 'SELECT name FROM sqlite_master WHERE type="table" AND name="universities"',
    'faculties': 'SELECT name FROM sqlite_master WHERE type="table" AND name="faculties"',
    'departments': 'SELECT name FROM sqlite_master WHERE type="table" AND name="departments"',
    'programs': 'SELECT name FROM sqlite_master WHERE type="table" AND name="programs"',
    
    // Academic periods
    'academic_years': 'SELECT name FROM sqlite_master WHERE type="table" AND name="academic_years"',
    'semesters': 'SELECT name FROM sqlite_master WHERE type="table" AND name="semesters"',
    'terms': 'SELECT name FROM sqlite_master WHERE type="table" AND name="terms"',
    'academic_breaks': 'SELECT name FROM sqlite_master WHERE type="table" AND name="academic_breaks"',
    
    // User management
    'users': 'SELECT name FROM sqlite_master WHERE type="table" AND name="users"',
    'user_roles': 'SELECT name FROM sqlite_master WHERE type="table" AND name="user_roles"',
    'user_permissions': 'SELECT name FROM sqlite_master WHERE type="table" AND name="user_permissions"',
    'user_sessions': 'SELECT name FROM sqlite_master WHERE type="table" AND name="user_sessions"',
    'user_preferences': 'SELECT name FROM sqlite_master WHERE type="table" AND name="user_preferences"',
    
    // Device auth
    'device_configurations': 'SELECT name FROM sqlite_master WHERE type="table" AND name="device_configurations"',
    'device_registrations': 'SELECT name FROM sqlite_master WHERE type="table" AND name="device_registrations"',
    'pending_accounts': 'SELECT name FROM sqlite_master WHERE type="table" AND name="pending_accounts"',
    'device_blacklist': 'SELECT name FROM sqlite_master WHERE type="table" AND name="device_blacklist"',
    
    // Courses
    'courses': 'SELECT name FROM sqlite_master WHERE type="table" AND name="courses"',
    'course_prerequisites': 'SELECT name FROM sqlite_master WHERE type="table" AND name="course_prerequisites"',
    'course_offerings': 'SELECT name FROM sqlite_master WHERE type="table" AND name="course_offerings"',
    'course_enrollments': 'SELECT name FROM sqlite_master WHERE type="table" AND name="course_enrollments"',
    'course_sessions': 'SELECT name FROM sqlite_master WHERE type="table" AND name="course_sessions"',
    
    // Assignments
    'assignments': 'SELECT name FROM sqlite_master WHERE type="table" AND name="assignments"',
    'assignment_questions': 'SELECT name FROM sqlite_master WHERE type="table" AND name="assignment_questions"',
    'assignment_rubrics': 'SELECT name FROM sqlite_master WHERE type="table" AND name="assignment_rubrics"',
    'assignment_submissions': 'SELECT name FROM sqlite_master WHERE type="table" AND name="assignment_submissions"',
    'submission_files': 'SELECT name FROM sqlite_master WHERE type="table" AND name="submission_files"',
    
    // Grading and attendance
    'grade_scales': 'SELECT name FROM sqlite_master WHERE type="table" AND name="grade_scales"',
    'grade_categories': 'SELECT name FROM sqlite_master WHERE type="table" AND name="grade_categories"',
    'grades': 'SELECT name FROM sqlite_master WHERE type="table" AND name="grades"',
    'attendance': 'SELECT name FROM sqlite_master WHERE type="table" AND name="attendance"',
    'attendance_codes': 'SELECT name FROM sqlite_master WHERE type="table" AND name="attendance_codes"',
    
    // Communication and documents
    'announcements': 'SELECT name FROM sqlite_master WHERE type="table" AND name="announcements"',
    'messages': 'SELECT name FROM sqlite_master WHERE type="table" AND name="messages"',
    'notifications': 'SELECT name FROM sqlite_master WHERE type="table" AND name="notifications"',
    'documents': 'SELECT name FROM sqlite_master WHERE type="table" AND name="documents"',
    'document_shares': 'SELECT name FROM sqlite_master WHERE type="table" AND name="document_shares"',
    
    // Finance and payments
    'financial_accounts': 'SELECT name FROM sqlite_master WHERE type="table" AND name="financial_accounts"',
    'financial_transactions': 'SELECT name FROM sqlite_master WHERE type="table" AND name="financial_transactions"',
    'tuition_plans': 'SELECT name FROM sqlite_master WHERE type="table" AND name="tuition_plans"',
    'student_payments': 'SELECT name FROM sqlite_master WHERE type="table" AND name="student_payments"',
    'payment_methods': 'SELECT name FROM sqlite_master WHERE type="table" AND name="payment_methods"',
  };

  // Get all foreign key constraints
  static List<String> get foreignKeyPragma => [
    'PRAGMA foreign_keys = ON',  // Enable foreign key constraints
  ];

  // Get all initialization SQL statements
  static List<String> get initializationStatements => [
    ...foreignKeyPragma,
    ...createTableStatements,
    ...createIndexStatements,
  ];

  // Prevent instantiation
  DatabaseSchema._();
}

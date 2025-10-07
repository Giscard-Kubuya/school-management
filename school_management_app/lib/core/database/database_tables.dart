class DatabaseTables {
  // User related tables
  static const String users = 'users';
  static const String administrators = 'administrators';
  static const String teachers = 'teachers';
  static const String students = 'students';

  // User Authentication
  static const String userSessions = 'user_sessions';
  static const String passwordResetTokens = 'password_reset_tokens';

  // User Preferences
  static const String userPreferences = 'user_preferences';

  // Roles & Permissions
  static const String userRoles = 'user_roles';
  static const String permissions = 'permissions';
  static const String userPermissions = 'user_permissions';
  static const String rolePermissions = 'role_permissions';
  static const String userRoleMappings = 'user_role_mappings';

  // Audit & Logging
  static const String auditLogs = 'audit_logs';

  // Academic related tables
  static const String universities = 'universities';
  static const String faculties = 'faculties';
  static const String departments = 'departments';
  static const String programs = 'programs';
  static const String courses = 'courses';
  static const String courseOfferings = 'course_offerings';
  static const String courseEnrollments = 'course_enrollments';
  static const String coursePrerequisites = 'course_prerequisites';

  // Attendance related tables
  static const String classSessions = 'class_sessions';
  static const String attendanceRecords = 'attendance_records';
  static const String attendanceExcuses = 'attendance_excuses';

  // Assignment related tables
  static const String assignments = 'assignments';
  static const String assignmentSubmissions = 'assignment_submissions';
  static const String assignmentQuestions = 'assignment_questions';
  static const String assignmentRubrics = 'assignment_rubrics';
  static const String submissionFiles = 'submission_files';
  static const String rubricEvaluations = 'rubric_evaluations';

  // Grade related tables
  static const String grades = 'grades';
  static const String gradeCategories = 'grade_categories';
  static const String gradeScales = 'grade_scales';

  // Financial tables
  static const String financialAccounts = 'financial_accounts';
  static const String transactions = 'transactions';
  static const String transactionCategories = 'transaction_categories';
  static const String tuitionFees = 'tuition_fees';
  static const String feePayments = 'fee_payments';
  static const String paymentPlans = 'payment_plans';
  static const String paymentPlanInstallments = 'payment_plan_installments';
  static const String paymentMethods = 'payment_methods';
  static const String documentPayments = 'document_payments';
  static const String financialHistory = 'financial_history';
  static const String withdrawalRequests = 'withdrawal_requests';

  // Communication tables
  static const String messages = 'messages';
  static const String messageRecipients = 'message_recipients';
  static const String messageAttachments = 'message_attachments';
  static const String announcements = 'announcements';
  static const String announcementRecipients = 'announcement_recipients';
  static const String notifications = 'notifications';

  // Document tables
  static const String documentFolders = 'document_folders';
  static const String documents = 'documents';
  static const String courseMaterials = 'course_materials';
  static const String documentDownloads = 'document_downloads';

  // System tables
  static const String deviceConfigurations = 'device_configurations';
  static const String deviceRegistrations = 'device_registrations';
  static const String pendingAccounts = 'pending_accounts';

  // Academic structure
  static const String campuses = 'campuses';
  static const String buildings = 'buildings';
  static const String rooms = 'rooms';
  static const String academicYears = 'academic_years';
  static const String semesters = 'semesters';
}

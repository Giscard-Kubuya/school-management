class ApiConstants {
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // User Endpoints
  static const String userProfile = '/users/me';
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/change-password';
  
  // University Endpoints
  static const String universities = '/universities';
  static const String universityDetails = '/universities/{id}';
  
  // Course Endpoints
  static const String courses = '/courses';
  static const String myCourses = '/me/courses';
  static const String courseDetails = '/courses/{id}';
  static const String enrollCourse = '/courses/{id}/enroll';
  
  // Assignment Endpoints
  static const String assignments = '/assignments';
  static const String assignmentDetails = '/assignments/{id}';
  static const String submitAssignment = '/assignments/{id}/submit';
  
  // Grade Endpoints
  static const String grades = '/grades';
  static const String myGrades = '/me/grades';
  
  // Sync Endpoints
  static const String sync = '/sync';
  static const String syncStatus = '/sync/status';
}

// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/features/enrollments/domain/entities/enrollment.dart';

// abstract class EnrollmentRepository {
//   // Get enrollments with optional filters
//   Future<Either<Failure, List<Enrollment>>> getEnrollments({
//     String? courseOfferingId,
//     String? studentId,
//     String? status,
//     bool? activeOnly,
//   });

//   // Get a specific enrollment by ID
//   Future<Either<Failure, Enrollment>> getEnrollment(String id);

//   // Enroll a student in a course offering
//   Future<Either<Failure, Enrollment>> enrollStudent({
//     required String courseOfferingId,
//     required String studentId,
//     String enrollmentType = 'regular',
//   });

//   // Update enrollment status
//   Future<Either<Failure, Enrollment>> updateEnrollmentStatus({
//     required String enrollmentId,
//     required String status,
//     String? grade,
//     double? gradePoints,
//   });

//   // Withdraw a student from a course
//   Future<Either<Failure, Unit>> withdrawStudent(String enrollmentId);

//   // Get enrollment statistics
//   Future<Either<Failure, Map<String, dynamic>>> getEnrollmentStats({
//     String? courseOfferingId,
//     String? studentId,
//   });

//   // Check if a student is enrolled in a course offering
//   Future<Either<Failure, bool>> isStudentEnrolled({
//     required String courseOfferingId,
//     required String studentId,
//   });

//   // Get student's current course load (number of enrolled credits)
//   Future<Either<Failure, int>> getStudentCourseLoad(String studentId);

//   // Get waitlist position for a student
//   Future<Either<Failure, int>> getWaitlistPosition(String enrollmentId);
// }

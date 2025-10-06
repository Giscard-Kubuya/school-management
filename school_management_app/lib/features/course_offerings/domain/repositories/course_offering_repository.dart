// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/features/course_offerings/domain/entities/course_offering.dart';

// abstract class CourseOfferingRepository {
//   Future<Either<Failure, List<CourseOffering>>> getCourseOfferings({
//     String? courseId,
//     String? semesterId,
//     bool? isActive,
//   });
  
//   Future<Either<Failure, CourseOffering>> getCourseOffering(String id);
  
//   Future<Either<Failure, CourseOffering>> createCourseOffering(CourseOffering courseOffering);
  
//   Future<Either<Failure, CourseOffering>> updateCourseOffering(CourseOffering courseOffering);
  
//   Future<Either<Failure, Unit>> deleteCourseOffering(String id);
  
//   Future<Either<Failure, Unit>> enrollInCourseOffering(String id);
  
//   Future<Either<Failure, int>> getEnrolledCount(String id);
  
//   Future<Either<Failure, bool>> isEnrollmentOpen(String id);
// }

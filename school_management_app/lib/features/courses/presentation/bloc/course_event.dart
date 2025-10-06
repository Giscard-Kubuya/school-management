import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/courses/domain/entities/course.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class LoadCourses extends CourseEvent {}

class LoadCourseDetails extends CourseEvent {
  final String courseId;

  const LoadCourseDetails(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class CreateCourseEvent extends CourseEvent {
  final Course course;

  const CreateCourseEvent(this.course);

  @override
  List<Object> get props => [course];
}

class UpdateCourseEvent extends CourseEvent {
  final Course course;

  const UpdateCourseEvent(this.course);

  @override
  List<Object> get props => [course];
}

class DeleteCourseEvent extends CourseEvent {
  final String courseId;

  const DeleteCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class EnrollInCourseEvent extends CourseEvent {
  final String courseId;

  const EnrollInCourseEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class LoadEnrolledCourses extends CourseEvent {}

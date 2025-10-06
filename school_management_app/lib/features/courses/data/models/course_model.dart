import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/courses/domain/entities/course.dart';

class CourseModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String courseCode;
  final int creditHours;
  final bool isEnrolled;
  final DateTime? startDate;
  final DateTime? endDate;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.courseCode,
    required this.creditHours,
    this.isEnrolled = false,
    this.startDate,
    this.endDate,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructor: json['instructor'] as String,
      courseCode: json['courseCode'] as String,
      creditHours: json['creditHours'] as int,
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'] as String) 
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'courseCode': courseCode,
      'creditHours': creditHours,
      'isEnrolled': isEnrolled,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Course toEntity() {
    return Course(
      id: id,
      title: title,
      description: description,
      instructor: instructor,
      courseCode: courseCode,
      creditHours: creditHours,
      isEnrolled: isEnrolled,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructor,
        courseCode,
        creditHours,
        isEnrolled,
        startDate,
        endDate,
      ];
}

import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String courseCode;
  final int creditHours;
  final bool isEnrolled;
  final DateTime? startDate;
  final DateTime? endDate;

  const Course({
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

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? courseCode,
    int? creditHours,
    bool? isEnrolled,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      courseCode: courseCode ?? this.courseCode,
      creditHours: creditHours ?? this.creditHours,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

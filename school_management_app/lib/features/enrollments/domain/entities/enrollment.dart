import 'package:equatable/equatable.dart';

class Enrollment extends Equatable {
  final String id;
  final String courseOfferingId;
  final String studentId;
  final String enrollmentType; // 'regular', 'audit', 'credit'
  final String enrollmentStatus; // 'enrolled', 'waitlisted', 'dropped', 'completed'
  final DateTime enrollmentDate;
  final DateTime? withdrawalDate;
  final String? finalGrade;
  final double? gradePoints;
  final bool isGradePosted;

  const Enrollment({
    required this.id,
    required this.courseOfferingId,
    required this.studentId,
    required this.enrollmentType,
    required this.enrollmentStatus,
    required this.enrollmentDate,
    this.withdrawalDate,
    this.finalGrade,
    this.gradePoints,
    this.isGradePosted = false,
  });

  @override
  List<Object?> get props => [
        id,
        courseOfferingId,
        studentId,
        enrollmentType,
        enrollmentStatus,
        enrollmentDate,
        withdrawalDate,
        finalGrade,
        gradePoints,
        isGradePosted,
      ];

  Enrollment copyWith({
    String? id,
    String? courseOfferingId,
    String? studentId,
    String? enrollmentType,
    String? enrollmentStatus,
    DateTime? enrollmentDate,
    DateTime? withdrawalDate,
    String? finalGrade,
    double? gradePoints,
    bool? isGradePosted,
  }) {
    return Enrollment(
      id: id ?? this.id,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      studentId: studentId ?? this.studentId,
      enrollmentType: enrollmentType ?? this.enrollmentType,
      enrollmentStatus: enrollmentStatus ?? this.enrollmentStatus,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      withdrawalDate: withdrawalDate ?? this.withdrawalDate,
      finalGrade: finalGrade ?? this.finalGrade,
      gradePoints: gradePoints ?? this.gradePoints,
      isGradePosted: isGradePosted ?? this.isGradePosted,
    );
  }

  bool get isActive => 
      enrollmentStatus == 'enrolled' || 
      enrollmentStatus == 'waitlisted';
      
  bool get isCompleted => enrollmentStatus == 'completed';
  
  bool get isDropped => enrollmentStatus == 'dropped';
  
  bool get isWaitlisted => enrollmentStatus == 'waitlisted';
}

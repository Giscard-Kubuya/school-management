import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/course_offerings/domain/entities/course_offering.dart';

class CourseOfferingModel extends Equatable {
  final String id;
  final String courseId;
  final String semesterId;
  final String section;
  final int capacity;
  final int enrolledCount;
  final bool isActive;
  final DateTime? registrationStartDate;
  final DateTime? registrationEndDate;
  final DateTime? withdrawalDeadline;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final String? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseOfferingModel({
    required this.id,
    required this.courseId,
    required this.semesterId,
    required this.section,
    required this.capacity,
    this.enrolledCount = 0,
    this.isActive = true,
    this.registrationStartDate,
    this.registrationEndDate,
    this.withdrawalDeadline,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseOfferingModel.fromJson(Map<String, dynamic> json) {
    return CourseOfferingModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      semesterId: json['semester_id'] as String,
      section: json['section'] as String,
      capacity: json['capacity'] as int,
      enrolledCount: json['enrolled_count'] as int? ?? 0,
      isActive: json['is_active'] == 1,
      registrationStartDate: json['registration_start_date'] != null
          ? DateTime.parse(json['registration_start_date'] as String)
          : null,
      registrationEndDate: json['registration_end_date'] != null
          ? DateTime.parse(json['registration_end_date'] as String)
          : null,
      withdrawalDeadline: json['withdrawal_deadline'] != null
          ? DateTime.parse(json['withdrawal_deadline'] as String)
          : null,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: json['sync_version'] as int? ?? 1,
      isDirty: json['is_dirty'] == 1,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'semester_id': semesterId,
      'section': section,
      'capacity': capacity,
      'enrolled_count': enrolledCount,
      'is_active': isActive ? 1 : 0,
      'registration_start_date': registrationStartDate?.toIso8601String(),
      'registration_end_date': registrationEndDate?.toIso8601String(),
      'withdrawal_deadline': withdrawalDeadline?.toIso8601String(),
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CourseOffering toEntity() {
    return CourseOffering(
      id: id,
      courseId: courseId,
      semesterId: semesterId,
      section: section,
      capacity: capacity,
      enrolledCount: enrolledCount,
      isActive: isActive,
      registrationStartDate: registrationStartDate,
      registrationEndDate: registrationEndDate,
      withdrawalDeadline: withdrawalDeadline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        semesterId,
        section,
        capacity,
        enrolledCount,
        isActive,
        registrationStartDate,
        registrationEndDate,
        withdrawalDeadline,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];
}

import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class AttendanceExcuse extends BaseModel {
  final String id;
  final String universityId;
  final String attendanceRecordId;
  final String studentId;
  final String excuseType; // medical, family_emergency, official_business, other
  final String reason;
  final String? supportingDocument;
  final DateTime submittedAt;
  final String status; // pending, approved, rejected
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewComments;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceExcuse({
    required this.id,
    required this.universityId,
    required this.attendanceRecordId,
    required this.studentId,
    this.excuseType = 'other',
    required this.reason,
    this.supportingDocument,
    required this.submittedAt,
    this.status = 'pending',
    this.reviewedBy,
    this.reviewedAt,
    this.reviewComments,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        universityId,
        attendanceRecordId,
        studentId,
        excuseType,
        reason,
        supportingDocument,
        submittedAt,
        status,
        reviewedBy,
        reviewedAt,
        reviewComments,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory AttendanceExcuse.fromJson(Map<String, dynamic> json) {
    return AttendanceExcuse(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      attendanceRecordId: json['attendance_record_id'] as String,
      studentId: json['student_id'] as String,
      excuseType: json['excuse_type'] as String? ?? 'other',
      reason: json['reason'] as String,
      supportingDocument: json['supporting_document'] as String?,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      status: json['status'] as String? ?? 'pending',
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewComments: json['review_comments'] as String?,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty: (json['is_dirty'] as int?) == 1,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] != null
          ? Map<String, dynamic>.from(json['conflict_data'] as Map)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'attendance_record_id': attendanceRecordId,
      'student_id': studentId,
      'excuse_type': excuseType,
      'reason': reason,
      'supporting_document': supportingDocument,
      'submitted_at': submittedAt.toIso8601String(),
      'status': status,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'review_comments': reviewComments,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AttendanceExcuse copyWith({
    String? id,
    String? universityId,
    String? attendanceRecordId,
    String? studentId,
    String? excuseType,
    String? reason,
    String? supportingDocument,
    DateTime? submittedAt,
    String? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewComments,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceExcuse(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      attendanceRecordId: attendanceRecordId ?? this.attendanceRecordId,
      studentId: studentId ?? this.studentId,
      excuseType: excuseType ?? this.excuseType,
      reason: reason ?? this.reason,
      supportingDocument: supportingDocument ?? this.supportingDocument,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewComments: reviewComments ?? this.reviewComments,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

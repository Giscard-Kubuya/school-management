import 'package:flutter/foundation.dart';
import '../../base_model.dart';

enum AttendanceStatus { present, absent, late, excused }

@immutable
class Attendance extends BaseModel {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;
  final String? recordedById;
  final DateTime? updatedAt;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.date,
    required this.status,
    this.notes,
    this.recordedById,
    this.updatedAt,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    courseId,
    date,
    status,
    notes,
    recordedById,
    updatedAt,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
  ];

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      date: DateTime.parse(json['date'] as String),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
        orElse: () => AttendanceStatus.absent,
      ),
      notes: json['notes'] as String?,
      recordedById: json['recordedById'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      syncVersion: json['syncVersion'] as int? ?? 1,
      isDirty: json['isDirty'] as bool? ?? false,
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      conflictData: json['conflictData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
      if (notes != null) 'notes': notes,
      if (recordedById != null) 'recordedById': recordedById,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Attendance copyWith({
    String? id,
    String? studentId,
    String? courseId,
    DateTime? date,
    AttendanceStatus? status,
    String? notes,
    String? recordedById,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return Attendance(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      recordedById: recordedById ?? this.recordedById,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

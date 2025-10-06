import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class AttendanceRecord extends BaseModel {
  final String id;
  final String universityId;
  final String classSessionId;
  final String studentId;
  final String attendanceStatus; // present, absent, late, excused
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? notes;
  final String? markedBy;
  final DateTime? markedAt;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceRecord({
    required this.id,
    required this.universityId,
    required this.classSessionId,
    required this.studentId,
    this.attendanceStatus = 'present',
    this.checkInTime,
    this.checkOutTime,
    this.notes,
    this.markedBy,
    this.markedAt,
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
    classSessionId,
    studentId,
    attendanceStatus,
    checkInTime,
    checkOutTime,
    notes,
    markedBy,
    markedAt,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      classSessionId: json['class_session_id'] as String,
      studentId: json['student_id'] as String,
      attendanceStatus: json['attendance_status'] as String? ?? 'present',
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'] as String)
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'] as String)
          : null,
      notes: json['notes'] as String?,
      markedBy: json['marked_by'] as String?,
      markedAt: json['marked_at'] != null
          ? DateTime.parse(json['marked_at'] as String)
          : null,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty: (json['is_dirty'] as int?) == 1,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'class_session_id': classSessionId,
      'student_id': studentId,
      'attendance_status': attendanceStatus,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'notes': notes,
      'marked_by': markedBy,
      'marked_at': markedAt?.toIso8601String(),
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AttendanceRecord copyWith({
    String? id,
    String? universityId,
    String? classSessionId,
    String? studentId,
    String? attendanceStatus,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? notes,
    String? markedBy,
    DateTime? markedAt,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      classSessionId: classSessionId ?? this.classSessionId,
      studentId: studentId ?? this.studentId,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      notes: notes ?? this.notes,
      markedBy: markedBy ?? this.markedBy,
      markedAt: markedAt ?? this.markedAt,
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

import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/course_sessions/domain/entities/session.dart';

class SessionModel extends Equatable {
  final String id;
  final String courseOfferingId;
  final String teacherId;
  final String sessionType; // 'lecture', 'lab', 'tutorial', 'exam'
  final String? title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final bool isCancelled;
  final String? cancellationReason;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final String? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionModel({
    required this.id,
    required this.courseOfferingId,
    required this.teacherId,
    required this.sessionType,
    this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.isCancelled = false,
    this.cancellationReason,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      courseOfferingId: json['course_offering_id'] as String,
      teacherId: json['teacher_id'] as String,
      sessionType: json['session_type'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String?,
      isCancelled: json['is_cancelled'] == 1,
      cancellationReason: json['cancellation_reason'] as String?,
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
      'course_offering_id': courseOfferingId,
      'teacher_id': teacherId,
      'session_type': sessionType,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'is_cancelled': isCancelled ? 1 : 0,
      'cancellation_reason': cancellationReason,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Session toEntity() {
    return Session(
      id: id,
      courseOfferingId: courseOfferingId,
      teacherId: teacherId,
      sessionType: sessionType,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      isCancelled: isCancelled,
      cancellationReason: cancellationReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseOfferingId,
        teacherId,
        sessionType,
        title,
        description,
        startTime,
        endTime,
        location,
        isCancelled,
        cancellationReason,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];
}

import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class Semester extends BaseModel {
  final String id;
  final String universityId;
  final String academicYearId;
  final String name;
  final String code;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? registrationStartDate;
  final DateTime? registrationEndDate;
  final String status; // upcoming, registration, active, completed, archived
  final bool isCurrent;
  final String? description;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Semester({
    required this.id,
    required this.universityId,
    required this.academicYearId,
    required this.name,
    required this.code,
    required this.startDate,
    required this.endDate,
    this.registrationStartDate,
    this.registrationEndDate,
    this.status = 'upcoming',
    this.isCurrent = false,
    this.description,
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
    academicYearId,
    name,
    code,
    startDate,
    endDate,
    registrationStartDate,
    registrationEndDate,
    status,
    isCurrent,
    description,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      academicYearId: json['academic_year_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      registrationStartDate: json['registration_start_date'] != null
          ? DateTime.parse(json['registration_start_date'] as String)
          : null,
      registrationEndDate: json['registration_end_date'] != null
          ? DateTime.parse(json['registration_end_date'] as String)
          : null,
      status: json['status'] as String? ?? 'upcoming',
      isCurrent:
          (json['is_current'] as int?) == 1 ||
          (json['is_current'] as bool?) == true,
      description: json['description'] as String?,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty:
          (json['is_dirty'] as int?) == 1 ||
          (json['is_dirty'] as bool?) == true,
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
      'academic_year_id': academicYearId,
      'name': name,
      'code': code,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'registration_start_date': registrationStartDate?.toIso8601String().split(
        'T',
      )[0],
      'registration_end_date': registrationEndDate?.toIso8601String().split(
        'T',
      )[0],
      'status': status,
      'is_current': isCurrent ? 1 : 0,
      'description': description,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Semester copyWith({
    String? id,
    String? universityId,
    String? academicYearId,
    String? name,
    String? code,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? registrationStartDate,
    DateTime? registrationEndDate,
    String? status,
    bool? isCurrent,
    String? description,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Semester(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      academicYearId: academicYearId ?? this.academicYearId,
      name: name ?? this.name,
      code: code ?? this.code,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      registrationStartDate:
          registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      status: status ?? this.status,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
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

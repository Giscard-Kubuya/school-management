import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class Course extends BaseModel {
  final String id;
  final String name;
  final String code;
  final String? description;
  final int creditHours;
  final bool isActive;
  final String? departmentId;
  final String? programId;
  final int semester;
  final bool isRequired;
  final List<String>? prerequisites;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Course({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.creditHours = 3,
    this.isActive = true,
    this.departmentId,
    this.programId,
    this.semester = 1,
    this.isRequired = true,
    this.prerequisites,
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
    name,
    code,
    description,
    creditHours,
    isActive,
    departmentId,
    programId,
    semester,
    isRequired,
    prerequisites,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      creditHours: json['creditHours'] as int? ?? 3,
      isActive: json['isActive'] as bool? ?? true,
      departmentId: json['departmentId'] as String?,
      programId: json['programId'] as String?,
      semester: json['semester'] as int? ?? 1,
      isRequired: json['isRequired'] as bool? ?? true,
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'] as List)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      syncVersion: json['syncVersion'] as int? ?? 1,
      isDirty: json['isDirty'] as bool? ?? false,
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      conflictData: json['conflictData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      if (description != null) 'description': description,
      'creditHours': creditHours,
      'isActive': isActive,
      if (departmentId != null) 'departmentId': departmentId,
      if (programId != null) 'programId': programId,
      'semester': semester,
      'isRequired': isRequired,
      if (prerequisites != null) 'prerequisites': prerequisites,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Course copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    int? creditHours,
    bool? isActive,
    String? departmentId,
    String? programId,
    int? semester,
    bool? isRequired,
    List<String>? prerequisites,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      creditHours: creditHours ?? this.creditHours,
      isActive: isActive ?? this.isActive,
      departmentId: departmentId ?? this.departmentId,
      programId: programId ?? this.programId,
      semester: semester ?? this.semester,
      isRequired: isRequired ?? this.isRequired,
      prerequisites: prerequisites ?? this.prerequisites,
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

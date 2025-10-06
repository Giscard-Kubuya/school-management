import 'package:flutter/foundation.dart';
import '../base_model.dart';

enum ProgramLevel { undergraduate, graduate, doctorate, diploma, certificate }

@immutable
class Program extends BaseModel {
  final String id;
  final String departmentId;
  final String facultyId;
  final String universityId;
  final String name;
  final String code;

  // Program details
  final ProgramLevel level;
  final double durationYears;
  final int durationSemesters;
  final double totalCreditsRequired;

  // Requirements
  final String? description;
  final Map<String, dynamic>? requirements;
  final String? entranceRequirements;
  final String? careerProspects;

  // Status
  final bool isActive;

  // Sync metadata
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const Program({
    required this.id,
    required this.departmentId,
    required this.facultyId,
    required this.universityId,
    required this.name,
    required this.code,
    required this.level,
    this.durationYears = 4.0,
    this.durationSemesters = 8,
    this.totalCreditsRequired = 120.0,
    this.description,
    this.requirements,
    this.entranceRequirements,
    this.careerProspects,
    this.isActive = true,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] as String,
      departmentId: json['departmentId'] as String,
      facultyId: json['facultyId'] as String,
      universityId: json['universityId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      level: ProgramLevel.values.firstWhere(
        (e) => e.toString() == 'ProgramLevel.${json['level']}',
        orElse: () => ProgramLevel.undergraduate,
      ),
      durationYears: (json['durationYears'] as num).toDouble(),
      durationSemesters: json['durationSemesters'] as int,
      totalCreditsRequired: (json['totalCreditsRequired'] as num).toDouble(),
      description: json['description'] as String?,
      requirements: json['requirements'] as Map<String, dynamic>?,
      entranceRequirements: json['entranceRequirements'] as String?,
      careerProspects: json['careerProspects'] as String?,
      isActive: (json['isActive'] as int) == 1,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      syncVersion: json['syncVersion'] as int? ?? 1,
      isDirty: (json['isDirty'] as int?) == 1,
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      conflictData: json['conflictData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Program copyWith({
    String? id,
    String? departmentId,
    String? facultyId,
    String? universityId,
    String? name,
    String? code,
    ProgramLevel? level,
    double? durationYears,
    int? durationSemesters,
    double? totalCreditsRequired,
    String? description,
    Map<String, dynamic>? requirements,
    String? entranceRequirements,
    String? careerProspects,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Program(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      facultyId: facultyId ?? this.facultyId,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      code: code ?? this.code,
      level: level ?? this.level,
      durationYears: durationYears ?? this.durationYears,
      durationSemesters: durationSemesters ?? this.durationSemesters,
      totalCreditsRequired: totalCreditsRequired ?? this.totalCreditsRequired,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      entranceRequirements: entranceRequirements ?? this.entranceRequirements,
      careerProspects: careerProspects ?? this.careerProspects,
      isActive: isActive ?? this.isActive,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    departmentId,
    facultyId,
    universityId,
    name,
    code,
    level,
    durationYears,
    durationSemesters,
    totalCreditsRequired,
    description,
    requirements,
    entranceRequirements,
    careerProspects,
    isActive,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentId': departmentId,
      'facultyId': facultyId,
      'universityId': universityId,
      'name': name,
      'code': code,
      'level': level.toString().split('.').last,
      'durationYears': durationYears,
      'durationSemesters': durationSemesters,
      'totalCreditsRequired': totalCreditsRequired,
      'description': description,
      'requirements': requirements,
      'entranceRequirements': entranceRequirements,
      'careerProspects': careerProspects,
      'isActive': isActive ? 1 : 0,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty ? 1 : 0,
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

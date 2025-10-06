import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class PaymentPlan extends BaseModel {
  final String id;
  final String universityId;
  final String name;
  final String? description;
  final String planType; // tuition, other
  final int numberOfInstallments;
  final bool isActive;
  final bool isDefault;
  final String? applicableTo; // all, program, student
  final String? programId;
  final String? studentId;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentPlan({
    required this.id,
    required this.universityId,
    required this.name,
    this.description,
    required this.planType,
    required this.numberOfInstallments,
    this.isActive = true,
    this.isDefault = false,
    this.applicableTo = 'all',
    this.programId,
    this.studentId,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          syncStatus: syncStatus,
          syncVersion: syncVersion,
          isDirty: isDirty,
          lastSyncedAt: lastSyncedAt,
          conflictData: conflictData,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props => [
        id,
        universityId,
        name,
        description,
        planType,
        numberOfInstallments,
        isActive,
        isDefault,
        applicableTo,
        programId,
        studentId,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdBy,
        createdAt,
        updatedAt,
      ];

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      planType: json['plan_type'] as String,
      numberOfInstallments: json['number_of_installments'] as int,
      isActive: (json['is_active'] as int?) != 0 && (json['is_active'] as bool?) != false,
      isDefault: (json['is_default'] as int?) == 1 || (json['is_default'] as bool?) == true,
      applicableTo: json['applicable_to'] as String? ?? 'all',
      programId: json['program_id'] as String?,
      studentId: json['student_id'] as String?,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty: (json['is_dirty'] as int?) == 1 || (json['is_dirty'] as bool?) == true,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] != null
          ? Map<String, dynamic>.from(json['conflict_data'] as Map)
          : null,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'name': name,
      'description': description,
      'plan_type': planType,
      'number_of_installments': numberOfInstallments,
      'is_active': isActive ? 1 : 0,
      'is_default': isDefault ? 1 : 0,
      'applicable_to': applicableTo,
      'program_id': programId,
      'student_id': studentId,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PaymentPlan copyWith({
    String? id,
    String? universityId,
    String? name,
    String? description,
    String? planType,
    int? numberOfInstallments,
    bool? isActive,
    bool? isDefault,
    String? applicableTo,
    String? programId,
    String? studentId,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentPlan(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      description: description ?? this.description,
      planType: planType ?? this.planType,
      numberOfInstallments: numberOfInstallments ?? this.numberOfInstallments,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      applicableTo: applicableTo ?? this.applicableTo,
      programId: programId ?? this.programId,
      studentId: studentId ?? this.studentId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

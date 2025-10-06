import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class Department extends BaseModel {
  final String id;
  final String facultyId;
  final String universityId;
  final String name;
  final String code;
  final String? headTeacherId;
  final String? description;
  final String? phone;
  final String? email;
  final String? officeLocation;
  final bool isActive;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Department({
    required this.id,
    required this.facultyId,
    required this.universityId,
    required this.name,
    required this.code,
    this.headTeacherId,
    this.description,
    this.phone,
    this.email,
    this.officeLocation,
    this.isActive = true,
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
    facultyId,
    universityId,
    name,
    code,
    headTeacherId,
    description,
    phone,
    email,
    officeLocation,
    isActive,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      facultyId: json['facultyId'] as String,
      universityId: json['universityId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      headTeacherId: json['headTeacherId'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      officeLocation: json['officeLocation'] as String?,
      isActive: json['isActive'] as bool? ?? true,
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
      'facultyId': facultyId,
      'universityId': universityId,
      'name': name,
      'code': code,
      if (headTeacherId != null) 'headTeacherId': headTeacherId,
      if (description != null) 'description': description,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (officeLocation != null) 'officeLocation': officeLocation,
      'isActive': isActive,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Department copyWith({
    String? id,
    String? facultyId,
    String? universityId,
    String? name,
    String? code,
    String? headTeacherId,
    String? description,
    String? phone,
    String? email,
    String? officeLocation,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      facultyId: facultyId ?? this.facultyId,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      code: code ?? this.code,
      headTeacherId: headTeacherId ?? this.headTeacherId,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      officeLocation: officeLocation ?? this.officeLocation,
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
}

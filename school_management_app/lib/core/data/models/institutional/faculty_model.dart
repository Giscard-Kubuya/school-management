import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class Faculty extends BaseModel {
  final String id;
  final String universityId;
  final String name;
  final String code;

  // Leadership
  final String? deanName;
  final String? deanEmail;
  final String? deanPhone;

  // Details
  final String? description;
  final int? establishedYear;
  final String? buildingLocation;
  final String? officeNumber;
  final String? phone;
  final String? email;

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

  const Faculty({
    required this.id,
    required this.universityId,
    required this.name,
    required this.code,
    this.deanName,
    this.deanEmail,
    this.deanPhone,
    this.description,
    this.establishedYear,
    this.buildingLocation,
    this.officeNumber,
    this.phone,
    this.email,
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
    universityId,
    name,
    code,
    deanName,
    deanEmail,
    deanPhone,
    description,
    establishedYear,
    buildingLocation,
    officeNumber,
    phone,
    email,
    isActive,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'] as String,
      universityId: json['universityId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      deanName: json['deanName'] as String?,
      deanEmail: json['deanEmail'] as String?,
      deanPhone: json['deanPhone'] as String?,
      description: json['description'] as String?,
      establishedYear: json['establishedYear'] as int?,
      buildingLocation: json['buildingLocation'] as String?,
      officeNumber: json['officeNumber'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
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
      'universityId': universityId,
      'name': name,
      'code': code,
      if (deanName != null) 'deanName': deanName,
      if (deanEmail != null) 'deanEmail': deanEmail,
      if (deanPhone != null) 'deanPhone': deanPhone,
      if (description != null) 'description': description,
      if (establishedYear != null) 'establishedYear': establishedYear,
      if (buildingLocation != null) 'buildingLocation': buildingLocation,
      if (officeNumber != null) 'officeNumber': officeNumber,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
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

  Faculty copyWith({
    String? id,
    String? universityId,
    String? name,
    String? code,
    String? deanName,
    String? deanEmail,
    String? deanPhone,
    String? description,
    int? establishedYear,
    String? buildingLocation,
    String? officeNumber,
    String? phone,
    String? email,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Faculty(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      code: code ?? this.code,
      deanName: deanName ?? this.deanName,
      deanEmail: deanEmail ?? this.deanEmail,
      deanPhone: deanPhone ?? this.deanPhone,
      description: description ?? this.description,
      establishedYear: establishedYear ?? this.establishedYear,
      buildingLocation: buildingLocation ?? this.buildingLocation,
      officeNumber: officeNumber ?? this.officeNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
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

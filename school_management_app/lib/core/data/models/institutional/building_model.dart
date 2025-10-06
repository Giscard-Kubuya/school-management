import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class Building extends BaseModel {
  final String id;
  final String campusId;
  final String universityId;
  final String name;
  final String? code;
  
  // Location
  final String? address;
  final double? latitude;
  final double? longitude;
  
  // Details
  final int? floorCount;
  final int? roomCount;
  final String? description;
  final String? imageUrl;
  
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

  const Building({
    required this.id,
    required this.campusId,
    required this.universityId,
    required this.name,
    this.code,
    this.address,
    this.latitude,
    this.longitude,
    this.floorCount,
    this.roomCount,
    this.description,
    this.imageUrl,
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
    campusId,
    universityId,
    name,
    code,
    address,
    latitude,
    longitude,
    floorCount,
    roomCount,
    description,
    imageUrl,
    isActive,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as String,
      campusId: json['campusId'] as String,
      universityId: json['universityId'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      floorCount: json['floorCount'] as int?,
      roomCount: json['roomCount'] as int?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
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
      'campusId': campusId,
      'universityId': universityId,
      'name': name,
      if (code != null) 'code': code,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (floorCount != null) 'floorCount': floorCount,
      if (roomCount != null) 'roomCount': roomCount,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
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

  Building copyWith({
    String? id,
    String? campusId,
    String? universityId,
    String? name,
    String? code,
    String? address,
    double? latitude,
    double? longitude,
    int? floorCount,
    int? roomCount,
    String? description,
    String? imageUrl,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Building(
      id: id ?? this.id,
      campusId: campusId ?? this.campusId,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      floorCount: floorCount ?? this.floorCount,
      roomCount: roomCount ?? this.roomCount,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
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

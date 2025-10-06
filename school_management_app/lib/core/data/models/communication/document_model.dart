import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class Document extends BaseModel {
  final String id;
  final String universityId;
  final String folderId;
  final String name;
  final String? description;
  final String filePath;
  final String fileType;
  final int fileSize;
  final String? thumbnailPath;
  final bool isPublic;
  final String? accessLevel; // public, university, department, course, private
  final String? departmentId;
  final String? courseOfferingId;
  final int downloadCount;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Document({
    required this.id,
    required this.universityId,
    required this.folderId,
    required this.name,
    this.description,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    this.thumbnailPath,
    this.isPublic = false,
    this.accessLevel = 'private',
    this.departmentId,
    this.courseOfferingId,
    this.downloadCount = 0,
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
        folderId,
        name,
        description,
        filePath,
        fileType,
        fileSize,
        thumbnailPath,
        isPublic,
        accessLevel,
        departmentId,
        courseOfferingId,
        downloadCount,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdBy,
        createdAt,
        updatedAt,
      ];

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      folderId: json['folder_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      filePath: json['file_path'] as String,
      fileType: json['file_type'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      thumbnailPath: json['thumbnail_path'] as String?,
      isPublic: (json['is_public'] as int?) == 1 || (json['is_public'] as bool?) == true,
      accessLevel: json['access_level'] as String? ?? 'private',
      departmentId: json['department_id'] as String?,
      courseOfferingId: json['course_offering_id'] as String?,
      downloadCount: (json['download_count'] as int?) ?? 0,
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
      'folder_id': folderId,
      'name': name,
      'description': description,
      'file_path': filePath,
      'file_type': fileType,
      'file_size': fileSize,
      'thumbnail_path': thumbnailPath,
      'is_public': isPublic ? 1 : 0,
      'access_level': accessLevel,
      'department_id': departmentId,
      'course_offering_id': courseOfferingId,
      'download_count': downloadCount,
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

  Document copyWith({
    String? id,
    String? universityId,
    String? folderId,
    String? name,
    String? description,
    String? filePath,
    String? fileType,
    int? fileSize,
    String? thumbnailPath,
    bool? isPublic,
    String? accessLevel,
    String? departmentId,
    String? courseOfferingId,
    int? downloadCount,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Document(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      folderId: folderId ?? this.folderId,
      name: name ?? this.name,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      isPublic: isPublic ?? this.isPublic,
      accessLevel: accessLevel ?? this.accessLevel,
      departmentId: departmentId ?? this.departmentId,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      downloadCount: downloadCount ?? this.downloadCount,
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

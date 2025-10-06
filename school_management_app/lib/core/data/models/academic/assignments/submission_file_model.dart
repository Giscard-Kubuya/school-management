import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class SubmissionFile extends BaseModel {
  final String id;
  final String submissionId;
  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize; // in bytes
  final String? mimeType;
  final String? thumbnailUrl;
  final String uploadStatus; // 'uploading', 'completed', 'failed'
  final String? errorMessage;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubmissionFile({
    required this.id,
    required this.submissionId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    this.mimeType,
    this.thumbnailUrl,
    this.uploadStatus = 'completed',
    this.errorMessage,
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
    submissionId,
    fileName,
    filePath,
    fileType,
    fileSize,
    mimeType,
    thumbnailUrl,
    uploadStatus,
    errorMessage,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory SubmissionFile.fromJson(Map<String, dynamic> json) {
    return SubmissionFile(
      id: json['id'] as String,
      submissionId: json['submissionId'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      mimeType: json['mimeType'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      uploadStatus: json['uploadStatus'] as String? ?? 'completed',
      errorMessage: json['errorMessage'] as String?,
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
      'submissionId': submissionId,
      'fileName': fileName,
      'filePath': filePath,
      'fileType': fileType,
      'fileSize': fileSize,
      if (mimeType != null) 'mimeType': mimeType,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'uploadStatus': uploadStatus,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SubmissionFile copyWith({
    String? id,
    String? submissionId,
    String? fileName,
    String? filePath,
    String? fileType,
    int? fileSize,
    String? mimeType,
    String? thumbnailUrl,
    String? uploadStatus,
    String? errorMessage,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubmissionFile(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
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

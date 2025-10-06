import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class Announcement extends BaseModel {
  final String id;
  final String universityId;
  final String authorId;
  final String title;
  final String content;
  final String? imageUrl;
  final String? linkUrl;
  final String? courseOfferingId;
  final String? departmentId;
  final bool isPinned;
  final bool isPublished;
  final DateTime? publishedAt;
  final String? publishedBy;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Announcement({
    required this.id,
    required this.universityId,
    required this.authorId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.linkUrl,
    this.courseOfferingId,
    this.departmentId,
    this.isPinned = false,
    this.isPublished = true,
    this.publishedAt,
    this.publishedBy,
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
    authorId,
    title,
    content,
    imageUrl,
    linkUrl,
    courseOfferingId,
    departmentId,
    isPinned,
    isPublished,
    publishedAt,
    publishedBy,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      authorId: json['author_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      linkUrl: json['link_url'] as String?,
      courseOfferingId: json['course_offering_id'] as String?,
      departmentId: json['department_id'] as String?,
      isPinned:
          (json['is_pinned'] as int?) == 1 ||
          (json['is_pinned'] as bool?) == true,
      isPublished:
          (json['is_published'] as int?) != 0 &&
          (json['is_published'] as bool?) != false,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      publishedBy: json['published_by'] as String?,
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
      'author_id': authorId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'course_offering_id': courseOfferingId,
      'department_id': departmentId,
      'is_pinned': isPinned ? 1 : 0,
      'is_published': isPublished ? 1 : 0,
      'published_at': publishedAt?.toIso8601String(),
      'published_by': publishedBy,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Announcement copyWith({
    String? id,
    String? universityId,
    String? authorId,
    String? title,
    String? content,
    String? imageUrl,
    String? linkUrl,
    String? courseOfferingId,
    String? departmentId,
    bool? isPinned,
    bool? isPublished,
    DateTime? publishedAt,
    String? publishedBy,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      departmentId: departmentId ?? this.departmentId,
      isPinned: isPinned ?? this.isPinned,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      publishedBy: publishedBy ?? this.publishedBy,
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

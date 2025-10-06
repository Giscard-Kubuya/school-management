import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class Message extends BaseModel {
  final String id;
  final String universityId;
  final String senderId;
  final String receiverId;
  final String? subject;
  final String messageBody;
  final String messageType; // direct, course, announcement
  final String? courseOfferingId;
  final String? parentMessageId;
  final bool isRead;
  final DateTime? readAt;
  final String priority; // low, normal, high, urgent
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Message({
    required this.id,
    required this.universityId,
    required this.senderId,
    required this.receiverId,
    this.subject,
    required this.messageBody,
    this.messageType = 'direct',
    this.courseOfferingId,
    this.parentMessageId,
    this.isRead = false,
    this.readAt,
    this.priority = 'normal',
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
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
        senderId,
        receiverId,
        subject,
        messageBody,
        messageType,
        courseOfferingId,
        parentMessageId,
        isRead,
        readAt,
        priority,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      subject: json['subject'] as String?,
      messageBody: json['message_body'] as String,
      messageType: json['message_type'] as String? ?? 'direct',
      courseOfferingId: json['course_offering_id'] as String?,
      parentMessageId: json['parent_message_id'] as String?,
      isRead: (json['is_read'] as int?) == 1 || (json['is_read'] as bool?) == true,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      priority: json['priority'] as String? ?? 'normal',
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty: (json['is_dirty'] as int?) == 1 || (json['is_dirty'] as bool?) == true,
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
      'sender_id': senderId,
      'receiver_id': receiverId,
      'subject': subject,
      'message_body': messageBody,
      'message_type': messageType,
      'course_offering_id': courseOfferingId,
      'parent_message_id': parentMessageId,
      'is_read': isRead ? 1 : 0,
      'read_at': readAt?.toIso8601String(),
      'priority': priority,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? universityId,
    String? senderId,
    String? receiverId,
    String? subject,
    String? messageBody,
    String? messageType,
    String? courseOfferingId,
    String? parentMessageId,
    bool? isRead,
    DateTime? readAt,
    String? priority,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      subject: subject ?? this.subject,
      messageBody: messageBody ?? this.messageBody,
      messageType: messageType ?? this.messageType,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      priority: priority ?? this.priority,
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

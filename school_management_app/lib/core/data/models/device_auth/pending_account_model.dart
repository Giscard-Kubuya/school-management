import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class PendingAccount extends BaseModel {
  final String id;
  final String universityId;
  final String email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String accountType;
  final String status;
  final String? verificationToken;
  final DateTime? tokenExpiresAt;
  final DateTime? verifiedAt;
  final String? invitedBy;
  final DateTime? invitedAt;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PendingAccount({
    required this.id,
    required this.universityId,
    required this.email,
    this.phone,
    this.firstName,
    this.lastName,
    required this.accountType,
    this.status = 'pending',
    this.verificationToken,
    this.tokenExpiresAt,
    this.verifiedAt,
    this.invitedBy,
    this.invitedAt,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendingAccount.fromJson(Map<String, dynamic> json) {
    return PendingAccount(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      accountType: json['account_type'] as String,
      status: json['status'] as String? ?? 'pending',
      verificationToken: json['verification_token'] as String?,
      tokenExpiresAt: json['token_expires_at'] != null
          ? DateTime.parse(json['token_expires_at'] as String)
          : null,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      invitedBy: json['invited_by'] as String?,
      invitedAt: json['invited_at'] != null
          ? DateTime.parse(json['invited_at'] as String)
          : null,
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
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'account_type': accountType,
      'status': status,
      'verification_token': verificationToken,
      'token_expires_at': tokenExpiresAt?.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
      'invited_by': invitedBy,
      'invited_at': invitedAt?.toIso8601String(),
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    universityId,
    email,
    phone,
    firstName,
    lastName,
    accountType,
    status,
    verificationToken,
    tokenExpiresAt,
    verifiedAt,
    invitedBy,
    invitedAt,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  PendingAccount copyWith({
    String? id,
    String? universityId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? accountType,
    String? status,
    String? verificationToken,
    DateTime? tokenExpiresAt,
    DateTime? verifiedAt,
    String? invitedBy,
    DateTime? invitedAt,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PendingAccount(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      accountType: accountType ?? this.accountType,
      status: status ?? this.status,
      verificationToken: verificationToken ?? this.verificationToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      invitedBy: invitedBy ?? this.invitedBy,
      invitedAt: invitedAt ?? this.invitedAt,
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

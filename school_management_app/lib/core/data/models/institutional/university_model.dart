import 'package:flutter/foundation.dart';
import '../base_model.dart';

enum UniversityType {
  public,
  private,
  international,
}

enum SyncStatus {
  synced,
  pending,
  failed,
  conflict,
}

@immutable
class University extends BaseModel {
  final String id;
  final String name;
  final String code;
  
  // Location
  final String country;
  final String? state;
  final String city;
  final String? address;
  final String? postalCode;
  
  // Contact
  final String? phone;
  final String? email;
  final String? website;
  
  // Details
  final UniversityType type;
  final int? establishedYear;
  final String? accreditation;
  final String? logoUrl;
  
  // Status
  final bool isActive;
  
  // Sync metadata
  final SyncStatus syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const University({
    required this.id,
    required this.name,
    required this.code,
    required this.country,
    this.state,
    required this.city,
    this.address,
    this.postalCode,
    this.phone,
    this.email,
    this.website,
    this.type = UniversityType.public,
    this.establishedYear,
    this.accreditation,
    this.logoUrl,
    this.isActive = true,
    this.syncStatus = SyncStatus.synced,
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
        name,
        code,
        country,
        state,
        city,
        address,
        postalCode,
        phone,
        email,
        website,
        type,
        establishedYear,
        accreditation,
        logoUrl,
        isActive,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      country: json['country'] as String,
      state: json['state'] as String?,
      city: json['city'] as String,
      address: json['address'] as String?,
      postalCode: json['postalCode'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      type: UniversityType.values.firstWhere(
        (e) => e.toString() == 'UniversityType.${json['type']}',
        orElse: () => UniversityType.public,
      ),
      establishedYear: json['establishedYear'] as int?,
      accreditation: json['accreditation'] as String?,
      logoUrl: json['logoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.toString() == 'SyncStatus.${json['syncStatus']}',
        orElse: () => SyncStatus.synced,
      ),
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
      'name': name,
      'code': code,
      'country': country,
      if (state != null) 'state': state,
      'city': city,
      if (address != null) 'address': address,
      if (postalCode != null) 'postalCode': postalCode,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
      'type': type.toString().split('.').last,
      if (establishedYear != null) 'establishedYear': establishedYear,
      if (accreditation != null) 'accreditation': accreditation,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'syncStatus': syncStatus.toString().split('.').last,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  University copyWith({
    String? id,
    String? name,
    String? code,
    String? country,
    String? state,
    String? city,
    String? address,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    UniversityType? type,
    int? establishedYear,
    String? accreditation,
    String? logoUrl,
    bool? isActive,
    SyncStatus? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      type: type ?? this.type,
      establishedYear: establishedYear ?? this.establishedYear,
      accreditation: accreditation ?? this.accreditation,
      logoUrl: logoUrl ?? this.logoUrl,
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

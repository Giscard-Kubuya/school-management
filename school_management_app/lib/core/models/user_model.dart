import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String universityId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  final String passwordHash;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? profilePicture;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? bio;
  final String? settings;
  final String? preferences;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? verificationToken;
  final String? resetPasswordToken;
  final String? resetPasswordExpires;
  final String? lastPasswordReset;
  final int failedLoginAttempts;
  final String? accountLockedUntil;
  final String? timezone;
  final String? language;
  final String? themePreference;

  const User({
    required this.id,
    required this.universityId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.passwordHash,
    this.isActive = true,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.profilePicture,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.bio,
    this.settings,
    this.preferences,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.verificationToken,
    this.resetPasswordToken,
    this.resetPasswordExpires,
    this.lastPasswordReset,
    this.failedLoginAttempts = 0,
    this.accountLockedUntil,
    this.timezone,
    this.language,
    this.themePreference,
  });

  /// Creates a User from a Map (e.g., from database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      universityId: map['university_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      role: map['role'],
      passwordHash: map['password_hash'],
      isActive: map['is_active'] == 1,
      lastLoginAt: map['last_login_at'] != null ? DateTime.parse(map['last_login_at']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      profilePicture: map['profile_picture'],
      dateOfBirth: map['date_of_birth'],
      gender: map['gender'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      postalCode: map['postal_code'],
      bio: map['bio'],
      settings: map['settings'],
      preferences: map['preferences'],
      isEmailVerified: map['is_email_verified'] == 1,
      isPhoneVerified: map['is_phone_verified'] == 1,
      verificationToken: map['verification_token'],
      resetPasswordToken: map['reset_password_token'],
      resetPasswordExpires: map['reset_password_expires'],
      lastPasswordReset: map['last_password_reset'],
      failedLoginAttempts: map['failed_login_attempts'] ?? 0,
      accountLockedUntil: map['account_locked_until'],
      timezone: map['timezone'],
      language: map['language'],
      themePreference: map['theme_preference'],
    );
  }

  /// Converts the User to a Map (e.g., for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'university_id': universityId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'password_hash': passwordHash,
      'is_active': isActive ? 1 : 0,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'profile_picture': profilePicture,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'bio': bio,
      'settings': settings,
      'preferences': preferences,
      'is_email_verified': isEmailVerified ? 1 : 0,
      'is_phone_verified': isPhoneVerified ? 1 : 0,
      'verification_token': verificationToken,
      'reset_password_token': resetPasswordToken,
      'reset_password_expires': resetPasswordExpires,
      'last_password_reset': lastPasswordReset,
      'failed_login_attempts': failedLoginAttempts,
      'account_locked_until': accountLockedUntil,
      'timezone': timezone,
      'language': language,
      'theme_preference': themePreference,
    };
  }

  /// Creates a copy of the User with updated fields
  User copyWith({
    String? id,
    String? universityId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? role,
    String? passwordHash,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? profilePicture,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? bio,
    String? settings,
    String? preferences,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? verificationToken,
    String? resetPasswordToken,
    String? resetPasswordExpires,
    String? lastPasswordReset,
    int? failedLoginAttempts,
    String? accountLockedUntil,
    String? timezone,
    String? language,
    String? themePreference,
  }) {
    return User(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      passwordHash: passwordHash ?? this.passwordHash,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      bio: bio ?? this.bio,
      settings: settings ?? this.settings,
      preferences: preferences ?? this.preferences,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      verificationToken: verificationToken ?? this.verificationToken,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordExpires: resetPasswordExpires ?? this.resetPasswordExpires,
      lastPasswordReset: lastPasswordReset ?? this.lastPasswordReset,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      accountLockedUntil: accountLockedUntil ?? this.accountLockedUntil,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      themePreference: themePreference ?? this.themePreference,
    );
  }

  @override
  List<Object?> get props => [
        id,
        universityId,
        firstName,
        lastName,
        email,
        phoneNumber,
        role,
        passwordHash,
        isActive,
        lastLoginAt,
        createdAt,
        updatedAt,
        deletedAt,
        profilePicture,
        dateOfBirth,
        gender,
        address,
        city,
        state,
        country,
        postalCode,
        bio,
        settings,
        preferences,
        isEmailVerified,
        isPhoneVerified,
        verificationToken,
        resetPasswordToken,
        resetPasswordExpires,
        lastPasswordReset,
        failedLoginAttempts,
        accountLockedUntil,
        timezone,
        language,
        themePreference,
      ];
}

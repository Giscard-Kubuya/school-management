import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../../core/models/user_model.dart';
import '../database_service.dart';
import '../database_tables.dart';

/// Data Access Object for User operations
class UserDao {
  final DatabaseService _databaseService;

  UserDao(this._databaseService);

  /// Creates the users table
  Future<void> createTable() async {
    // Table creation is handled by DatabaseHelper._createUserTables
    // This method is kept for backward compatibility
  }

  /// Converts a database map to a User model
  User _fromMap(Map<String, dynamic> map) => User.fromMap(map);

  /// Converts a User model to a database map
  Map<String, dynamic> _toMap(User user) => user.toMap();

  /// Inserts a new user into the database
  /// Returns the ID of the inserted user
  Future<String> insert(User user) async {
    final id = await _databaseService.insert(
      DatabaseTables.users,
      _toMap(user),
    );
    return id.toString();
  }

  /// Retrieves a user by ID
  Future<User?> getById(String id) async {
    final results = await _databaseService.query(
      DatabaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return _fromMap(results.first);
  }

  /// Retrieves a user by email
  Future<User?> getByEmail(String email) async {
    final results = await _databaseService.query(
      DatabaseTables.users,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (results.isEmpty) return null;
    return _fromMap(results.first);
  }

  /// Updates an existing user
  Future<int> update(User user) async {
    final map = _toMap(user);
    // Remove the ID from the update map
    map.remove('id');

    return await _databaseService.update(
      DatabaseTables.users,
      map,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Deletes a user by ID
  Future<int> delete(String id) async {
    return await _databaseService.delete(
      DatabaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Retrieves all users
  Future<List<User>> getAll() async {
    final results = await _databaseService.query(DatabaseTables.users);
    return results.map((map) => _fromMap(map)).toList();
  }

  /// Searches users by name or email
  Future<List<User>> search(String query) async {
    final results = await _databaseService.query(
      DatabaseTables.users,
      where: 'first_name LIKE ? OR last_name LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return results.map((map) => _fromMap(map)).toList();
  }

  /// Updates the user's password
  Future<int> updatePassword(String userId, String newPasswordHash) async {
    return await _databaseService.update(
      DatabaseTables.users,
      {
        'password_hash': newPasswordHash,
        'updated_at': DateTime.now().toIso8601String(),
        'last_password_reset': DateTime.now().toIso8601String(),
        'reset_password_token': null,
        'reset_password_expires': null,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Updates the user's last login timestamp
  Future<void> updateLastLogin(String userId) async {
    await _databaseService.update(
      DatabaseTables.users,
      {
        'last_login_at': DateTime.now().toIso8601String(),
        'failed_login_attempts': 0, // Reset failed attempts on successful login
        'account_locked_until': null,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Records a failed login attempt
  Future<void> recordFailedLoginAttempt(String email) async {
    // First get the current failed attempts
    final user = await getByEmail(email);
    if (user == null) return;

    final failedAttempts = user.failedLoginAttempts + 1;
    final now = DateTime.now();

    // Lock account after 5 failed attempts for 30 minutes
    final lockedUntil = failedAttempts >= 5
        ? now.add(const Duration(minutes: 30))
        : null;

    await _databaseService.update(
      DatabaseTables.users,
      {
        'failed_login_attempts': failedAttempts,
        'account_locked_until': lockedUntil?.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  /// Checks if a user account is locked
  Future<bool> isAccountLocked(String email) async {
    final user = await getByEmail(email);
    if (user == null) return false;

    if (user.accountLockedUntil == null) return false;

    try {
      final lockedUntil = DateTime.parse(user.accountLockedUntil!);
      final now = DateTime.now();

      // Check if the lock has expired
      if (now.isAfter(lockedUntil)) {
        // Reset the lock if it has expired
        await _databaseService.update(
          DatabaseTables.users,
          {
            'failed_login_attempts': 0,
            'account_locked_until': null,
            'updated_at': now.toIso8601String(),
          },
          where: 'email = ?',
          whereArgs: [email],
        );
        return false;
      }

      return true;
    } catch (e) {
      // If there's an error parsing the date, treat it as not locked
      return false;
    }
  }

  /// Gets users by role
  Future<List<User>> getUsersByRole(String role) async {
    final results = await _databaseService.query(
      DatabaseTables.users,
      where: 'role = ?',
      whereArgs: [role],
    );

    return results.map((map) => _fromMap(map)).toList();
  }

  /// Updates user profile information
  Future<int> updateProfile(User user) async {
    final map = _toMap(user);
    // Only update profile-related fields
    final profileFields = {
      'first_name': map['first_name'],
      'last_name': map['last_name'],
      'phone_number': map['phone_number'],
      'profile_picture': map['profile_picture'],
      'date_of_birth': map['date_of_birth'],
      'gender': map['gender'],
      'address': map['address'],
      'city': map['city'],
      'state': map['state'],
      'country': map['country'],
      'postal_code': map['postal_code'],
      'bio': map['bio'],
      'timezone': map['timezone'],
      'language': map['language'],
      'theme_preference': map['theme_preference'],
      'updated_at': DateTime.now().toIso8601String(),
    };

    return await _databaseService.update(
      DatabaseTables.users,
      profileFields,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}

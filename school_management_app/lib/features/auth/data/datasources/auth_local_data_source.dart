// import 'package:school_management_app/core/error/exceptions.dart';
// import 'package:school_management_app/features/auth/domain/entities/user.dart';

// abstract class AuthLocalDataSource {
//   /// Caches the [User] which was gotten the last time the user had an internet connection.
//   ///
//   /// Throws a [CacheException] for all error codes.
//   Future<void> cacheUser(User user);
  
//   /// Gets the cached [User].
//   ///
//   /// Throws a [CacheException] if no cached data is present.
//   Future<User> getCachedUser();
  
//   /// Deletes all cached user data.
//   ///
//   /// Throws a [CacheException] for all error codes.
//   Future<void> clearCachedUser();
  
//   /// Caches the auth token.
//   ///
//   /// Throws a [CacheException] for all error codes.
//   Future<void> cacheAuthToken(String token);
  
//   /// Gets the cached auth token.
//   ///
//   /// Returns null if no token is cached.
//   Future<String?> getCachedAuthToken();
  
//   /// Clears the cached auth token.
//   ///
//   /// Throws a [CacheException] for all error codes.
//   Future<void> clearAuthToken();
// }

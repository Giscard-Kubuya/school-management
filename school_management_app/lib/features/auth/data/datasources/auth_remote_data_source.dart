// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/features/auth/domain/entities/user.dart';

// abstract class AuthRemoteDataSource {
//   // Check if user is signed in
//   Future<bool> get isSignedIn;
  
//   // Get current user
//   Stream<User> get user;
  
//   // Sign in with email and password
//   Future<User> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   });
  
//   // Sign up with email and password
//   Future<User> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String name,
//   });
  
//   // Sign in with Google
//   Future<User> signInWithGoogle();
  
//   // Sign out
//   Future<void> signOut();
  
//   // Send password reset email
//   Future<void> sendPasswordResetEmail(String email);
  
//   // Update user profile
//   Future<User> updateProfile({
//     String? name,
//     String? photoUrl,
//   });
  
//   // Update password
//   Future<void> updatePassword({
//     required String currentPassword,
//     required String newPassword,
//   });
// }

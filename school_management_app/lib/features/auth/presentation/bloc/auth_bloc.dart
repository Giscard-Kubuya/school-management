// import 'dart:async';
// import 'package:equatable/equatable.dart';
// import 'package:school_management_app/features/auth/domain/entities/user.dart';
// import 'package:school_management_app/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
// import 'package:school_management_app/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
// import 'package:school_management_app/features/auth/domain/usecases/sign_in_with_google.dart';
// import 'package:school_management_app/features/auth/domain/usecases/sign_out.dart';
// import 'package:school_management_app/features/auth/domain/usecases/send_password_reset_email.dart';
// import 'package:school_management_app/features/auth/domain/usecases/update_profile.dart';
// import 'package:school_management_app/features/auth/domain/usecases/update_password.dart';


// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final SignInWithEmailAndPassword signInWithEmailAndPassword;
//   final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
//   final SignInWithGoogle signInWithGoogle;
//   final SignOut signOut;
//   final SendPasswordResetEmail sendPasswordResetEmail;
//   final UpdateProfile updateProfile;
//   final UpdatePassword updatePassword;
  
//   StreamSubscription<User>? _userSubscription;

//   AuthBloc({
//     required this.signInWithEmailAndPassword,
//     required this.signUpWithEmailAndPassword,
//     required this.signInWithGoogle,
//     required this.signOut,
//     required this.sendPasswordResetEmail,
//     required this.updateProfile,
//     required this.updatePassword,
//   }) : super(AuthState.initial()) {
//     on<AuthUserChanged>(_onAuthUserChanged);
//     on<SignInRequested>(_onSignInRequested);
//     on<SignUpRequested>(_onSignUpRequested);
//     on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
//     on<SignOutRequested>(_onSignOutRequested);
//     on<SendPasswordResetEmailRequested>(_onSendPasswordResetEmailRequested);
//     on<UpdateProfileRequested>(_onUpdateProfileRequested);
//     on<UpdatePasswordRequested>(_onUpdatePasswordRequested);
//   }

//   void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
//     emit(state.copyWith(
//       status: event.user.isNotEmpty ? AuthStatus.authenticated : AuthStatus.unauthenticated,
//       user: event.user,
//     );
//   }

//   Future<void> _onSignInRequested(
//     SignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await signInWithEmailAndPassword(
//       SignInParams(
//         email: event.email,
//         password: event.password,
//       ),
//     );

//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (user) => emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         user: user,
//       )),
//     );
//   }

//   Future<void> _onSignUpRequested(
//     SignUpRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await signUpWithEmailAndPassword(
//       SignUpParams(
//         email: event.email,
//         password: event.password,
//         name: event.name,
//       ),
//     );

//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (user) => emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         user: user,
//         isNewUser: true,
//       )),
//     );
//   }

//   Future<void> _onSignInWithGoogleRequested(
//     SignInWithGoogleRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await signInWithGoogle();
    
//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (user) => emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         user: user,
//       )),
//     );
//   }

//   Future<void> _onSignOutRequested(
//     SignOutRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await signOut();
    
//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (_) => emit(state.copyWith(
//         status: AuthStatus.unauthenticated,
//         user: const User.empty(),
//       )),
//     );
//   }

//   Future<void> _onSendPasswordResetEmailRequested(
//     SendPasswordResetEmailRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await sendPasswordResetEmail(event.email);
    
//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (_) => emit(state.copyWith(
//         status: state.isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated,
//       )),
//     );
//   }

//   Future<void> _onUpdateProfileRequested(
//     UpdateProfileRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await updateProfile(
//       UpdateProfileParams(
//         name: event.name,
//         photoUrl: event.photoUrl,
//       ),
//     );

//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (user) => emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         user: user,
//       )),
//     );
//   }

//   Future<void> _onUpdatePasswordRequested(
//     UpdatePasswordRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));
    
//     final result = await updatePassword(
//       UpdatePasswordParams(
//         currentPassword: event.currentPassword,
//         newPassword: event.newPassword,
//       ),
//     );

//     result.fold(
//       (failure) => emit(state.copyWith(
//         status: AuthStatus.failure,
//         errorMessage: failure.message,
//       )),
//       (_) => emit(state.copyWith(
//         status: AuthStatus.authenticated,
//       )),
//     );
//   }

//   @override
//   Future<void> close() {
//     _userSubscription?.cancel();
//     return super.close();
//   }
// }

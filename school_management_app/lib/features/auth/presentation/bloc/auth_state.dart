import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/auth/domain/entities/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final User user;
  final String? errorMessage;
  final bool isEmailVerified;
  final bool isNewUser;

  const AuthState({
    this.status = AuthStatus.initial,
    required this.user,
    this.errorMessage,
    this.isEmailVerified = false,
    this.isNewUser = false,
  });

  factory AuthState.initial() {
    return const AuthState(user: User.empty);
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isEmailVerified,
    bool? isNewUser,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        isEmailVerified,
        isNewUser,
      ];

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isInitial => status == AuthStatus.initial;
  bool get isFailure => status == AuthStatus.failure;
}

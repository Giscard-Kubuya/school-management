import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/auth/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final User user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class SendPasswordResetEmailRequested extends AuthEvent {
  final String email;

  const SendPasswordResetEmailRequested(this.email);

  @override
  List<Object> get props => [email];
}

class UpdateProfileRequested extends AuthEvent {
  final String? name;
  final String? photoUrl;

  const UpdateProfileRequested({this.name, this.photoUrl});

  @override
  List<Object?> get props => [name, photoUrl];
}

class UpdatePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const UpdatePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

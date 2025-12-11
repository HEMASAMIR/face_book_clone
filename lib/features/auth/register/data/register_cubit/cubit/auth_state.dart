part of 'auh_cubit.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends AuthState {}

final class RegisterLoading extends AuthState {}

final class RegisterAuthenticated extends AuthState {
  final User user;

  const RegisterAuthenticated(this.user);
}

class RegisterError extends AuthState {
  final String message;

  const RegisterError(this.message);
}

//LOGIN STATES
class LoginLoading extends AuthState {}

class LoginAuthenticated extends AuthState {
  final User user;

  const LoginAuthenticated(this.user);
}

class LoginError extends AuthState {
  final String message;

  const LoginError(this.message);
}

//SINGOUT STATES
class SignOutSuccess extends AuthState {}

//update user data
class EditProfileLoading extends AuthState {}

class EditProfileSuccess extends AuthState {}

class EditProfileFailure extends AuthState {
  final String message;
  const EditProfileFailure(this.message);
}

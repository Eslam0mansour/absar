
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}
class CodeSent extends AuthState {
  final String verificationId;
  CodeSent({required this.verificationId});
}
class AuthSignOutSuccess extends AuthState {}

class CodeSent2 extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
class ChangePasswordVisibility extends AuthState {}
class GetUserSuccess extends AuthState {}
class GetUserError extends AuthState {}
class GetUserLoading extends AuthState {}
class DataCompletedDone extends AuthState {}

class HaveCurrentUser extends AuthState {}

class NotHaveCurrentUser extends AuthState {}
class CodeWrite extends AuthState {}
class ChangeCountryCode extends AuthState {}
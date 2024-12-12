part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class ErrorOccurred extends AuthState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class GetUserData extends AuthState {}

class SubmitionVerified extends AuthState {}

class UpdateEmailAndPassword extends AuthState {}

class RestEmailSent extends AuthState {}

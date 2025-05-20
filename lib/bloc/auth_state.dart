part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class UnauthenticatedState extends AuthState {}

class AuthenticatedState extends AuthState {
  final String email;
  final String name;

  AuthenticatedState({
    required this.email,
    required this.name,
  });
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({required this.message});
}
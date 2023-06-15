//import 'package:equatable/equatable.dart';

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

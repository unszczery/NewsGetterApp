import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;

  AuthBloc({required this.sharedPreferences}) : super(AuthInitial()) {
    on<RegisterEvent>(_mapRegisterEventToState,
        transformer: bloc_concurrency.sequential());
    on<LoginEvent>(_mapLoginEventToState,
        transformer: bloc_concurrency.sequential());
  }

  Future<void> _mapRegisterEventToState(
      RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final email = event.email;
      final password = event.password;
      sharedPreferences.setString('email', email);
      sharedPreferences.setString('password', password);
      emit(AuthSuccess());
      sharedPreferences.setBool('isLoggedIn', true);
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _mapLoginEventToState(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final email = event.email;
      final password = event.password;
      final savedEmail = sharedPreferences.getString('email');
      final savedPassword = sharedPreferences.getString('password');
      if (email == savedEmail && password == savedPassword) {
        emit(AuthSuccess());
        sharedPreferences.setBool('isLoggedIn', true);
      } else {
        emit(AuthFailure(errorMessage: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Stream<AuthState> mapEventToStates(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthLoading();
      try {
        final email = event.email;
        final password = event.password;
        final savedEmail = sharedPreferences.getString('email');
        final savedPassword = sharedPreferences.getString('password');
        if (email == savedEmail && password == savedPassword) {
          yield AuthSuccess();
          sharedPreferences.setBool('isLoggedIn', true);
        } else {
          yield AuthFailure(errorMessage: 'Invalid email or password');
        }
      } catch (e) {
        yield AuthFailure(errorMessage: e.toString());
      }
    } else if (event is RegisterEvent) {
      yield AuthLoading();
      try {
        final email = event.email;
        final password = event.password;
        sharedPreferences.setString('email', email);
        sharedPreferences.setString('password', password);
        yield AuthSuccess();
        sharedPreferences.setBool('isLoggedIn', true);
      } catch (e) {
        yield AuthFailure(errorMessage: e.toString());
      }
    }
  }
}

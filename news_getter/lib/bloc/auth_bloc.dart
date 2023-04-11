import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;

  AuthBloc({required this.sharedPreferences}) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
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

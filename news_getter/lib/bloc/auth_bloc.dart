import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:news_getter/bloc/auth_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthBlfoc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;
  AuthBlfoc({required this.sharedPreferences}) : super(AuthInitial());

  @override
  Stream<AuthState> _mapEventToState(AuthEvent event) async* {
    if (event is CheckAuthStatus) {
      yield* _mapCheckAuthStatusToState();
    } else if (event is LoginEvent) {
      yield* _mapLoginToState(event.email, event.password);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapCheckAuthStatusToState() async* {
    final isAuthenticated =
        sharedPreferences.getBool('isAuthenticated') ?? false;
    if (isAuthenticated) {
      yield Authenticated();
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginToState(String email, String password) async* {
    final isAuthenticated = true;

    if (isAuthenticated) {
      await sharedPreferences.setBool('isAuthenticated', true);
      yield Authenticated();
    } else {
      yield LoginFailed(); //if something is going to be wrong with Internet, this will work
    }
  }

  Stream<AuthState> _mapLogoutToState() async* {
    await sharedPreferences.remove('isAuthenticated');
    yield Unauthenticated();
  }
}

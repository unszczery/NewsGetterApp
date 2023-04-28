import 'package:flutter/material.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AuthBloc _authBloc;
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _sharedPreferences = snapshot.data!;
          final isLoggedIn = _sharedPreferences.getBool('isLoggedIn') ?? false;
          if (isLoggedIn) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            _authBloc = AuthBloc(sharedPreferences: _sharedPreferences);
          }
          return Scaffold(
              body: BlocProvider(
                  create: (_) => _authBloc,
                  child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else if (state is AuthFailure) {
                      final snackBar =
                          SnackBar(content: Text(state.errorMessage));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }, child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              _authBloc.add(LoginEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text));
                            },
                            child: const Text('Log in'),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                              onPressed: () {
                                _authBloc.add(RegisterEvent(
                                    email: _emailController.text,
                                    password: _passwordController.text));
                              },
                              child: const Text('Register'))
                        ],
                      ),
                    );
                  }))));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

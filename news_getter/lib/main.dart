import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:news_getter/components/secure_storage.dart';
import 'package:news_getter/screens/auth_screen.dart';
import 'package:news_getter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SecureStorage secureStorage = SecureStorage();
  runApp(MyApp(secureStorage: secureStorage));
}

class MyApp extends StatelessWidget {
  final SecureStorage secureStorage;
  const MyApp({required this.secureStorage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Getter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<AuthBloc>(
        create: (_) =>
            AuthBloc(secureStorage: secureStorage)..add(AppStarted()),
        child: const AuthScreen(),
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

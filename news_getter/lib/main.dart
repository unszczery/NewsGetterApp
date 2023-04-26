import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:news_getter/screens/auth_screen.dart';
import 'package:news_getter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Getter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(sharedPreferences: prefs)..add(AppStarted()),
        child: AuthScreen(),
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

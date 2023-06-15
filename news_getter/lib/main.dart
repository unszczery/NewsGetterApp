import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';
import 'package:news_getter/components/secure_storage.dart';
import 'package:news_getter/repository/auth_repository.dart';
import 'package:news_getter/screens/auth_screen.dart';
import 'package:news_getter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SecureStorage secureStorage = SecureStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context)),
        child: MaterialApp(
            title: 'News Getter',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: SignIn()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_getter/bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('News Getter'),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () => const SnackBar(content: Text('Pressed')),
        ),
      ],
    ));
  }
}

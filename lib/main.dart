import 'package:flutter/material.dart';
import 'package:notes/screens/home/home.dart';
import 'package:notes/screens/notes/manage.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/utils/themes.dart';

void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: theme,
      routes: {
        homeRoute: (context) => const Home(),
        manageNoteRoute: (context) => const ManageNote(),
      },
      initialRoute: homeRoute,
    );
  }
}

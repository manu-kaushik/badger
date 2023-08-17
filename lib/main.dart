import 'package:flutter/material.dart';
import 'package:badger/screens/home/home.dart';
import 'package:badger/screens/notes/manage.dart';
import 'package:badger/utils/constants.dart';
import 'package:badger/utils/local_storage.dart';
import 'package:badger/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage().initialize();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      routes: {
        homeRoute: (context) => const Home(),
        manageNoteRoute: (context) => const ManageNote(),
      },
      initialRoute: homeRoute,
    );
  }
}

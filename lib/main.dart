import 'package:flutter/material.dart';
import 'package:badger/screens/home/home_screen.dart';
import 'package:badger/screens/notes/manage_note_screen.dart';
import 'package:badger/utils/constants.dart';
import 'package:badger/helpers/local_storage.dart';
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
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        HomeScreen.routePath: (context) => const HomeScreen(),
        ManageNoteScreen.routePath: (context) => const ManageNoteScreen(),
      },
      initialRoute: HomeScreen.routePath,
    );
  }
}

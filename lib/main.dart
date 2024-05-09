import 'package:badger/helpers/local_storage.dart';
import 'package:badger/screens/exports.dart';
import 'package:badger/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage().initialize();

  runApp(const ProviderScope(child: Main()));
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

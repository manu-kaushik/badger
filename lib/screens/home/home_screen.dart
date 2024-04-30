import 'package:badger/screens/home/tabs/notes_tab.dart';
import 'package:badger/screens/home/tabs/todos_tab.dart';
import 'package:badger/helpers/local_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routePath = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage localStorage = LocalStorage();

  int currentIndex = 0;

  final String currentIndexKey = 'currentHomeTabIndex';

  @override
  void initState() {
    super.initState();

    setCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          NotesTab(),
          TodosTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note,
            ),
            label: 'Notes',
            tooltip: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.checklist_rounded,
            ),
            label: 'Todos',
            tooltip: 'Todos',
          ),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: const IconThemeData(size: 32),
        unselectedIconTheme: const IconThemeData(size: 32),
      ),
    );
  }

  void setCurrentIndex() async {
    currentIndex = await localStorage.getInt(currentIndexKey);

    setState(() {});
  }

  void onTap(int index) {
    localStorage.setInt(currentIndexKey, index);

    setState(() {
      currentIndex = index;
    });
  }
}

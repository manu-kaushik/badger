import 'package:badger/screens/home/tabs/notes.dart';
import 'package:badger/screens/home/tabs/todos.dart';
import 'package:badger/utils/local_storage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage _localStorage = LocalStorage();

  int _currentIndex = 0;

  final String _currentIndexKey = 'currentHomeTabIndex';

  @override
  void initState() {
    super.initState();

    _setCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          NotesTab(),
          TodosTab(),
        ],
      ),
      bottomNavigationBar: _getBottomNav(),
    );
  }

  BottomNavigationBar _getBottomNav() {
    return BottomNavigationBar(
      onTap: _onTabTapped,
      currentIndex: _currentIndex,
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
    );
  }

  void _setCurrentIndex() async {
    _currentIndex = await _localStorage.getInt(_currentIndexKey);

    setState(() {});
  }

  void _onTabTapped(int index) {
    _localStorage.setInt(_currentIndexKey, index);

    setState(() {
      _currentIndex = index;
    });
  }
}

import 'package:flutter/material.dart';

import 'package:badger/screens/home/tabs/notes.dart';
import 'package:badger/screens/home/tabs/todos.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/local_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage _localStorage = LocalStorage();

  int _currentIndex = 0;

  final List<Widget> _children = [
    const NotesTab(),
    const TodosTab(),
  ];

  final String _currentIndexKey = 'currentHomeTabIndex';

  void onTabTapped(int index) {
    _localStorage.setInt(_currentIndexKey, index);
  }

  @override
  Widget build(BuildContext context) {
    setCurrentIndex();

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note,
              color: getCurrentTabColor(),
            ),
            label: 'Notes',
            tooltip: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.checklist_rounded,
              color: getCurrentTabColor(),
            ),
            label: 'Todos',
            tooltip: 'Todos',
          ),
        ],
        backgroundColor: getCurrentTabColor().shade50,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28,
        selectedIconTheme: const IconThemeData(size: 32),
      ),
    );
  }

  MaterialColor getCurrentTabColor() =>
      _currentIndex == 0 ? notesThemeColor : todosThemeColor;

  void setCurrentIndex() async {
    _currentIndex = await _localStorage.getInt(_currentIndexKey);

    setState(() {});
  }
}

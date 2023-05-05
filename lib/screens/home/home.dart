import 'package:flutter/material.dart';

import 'package:notes/screens/home/tabs/notes_tab.dart';
import 'package:notes/screens/home/tabs/todos_tab.dart';
import 'package:notes/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const NotesTab(),
    const TodosTab(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          getCurrentTabTitle(),
          style: TextStyle(
            color: getCurrentTabColor(),
          ),
        ),
        backgroundColor: getCurrentTabColor().shade50,
        elevation: 0,
      ),
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
      _currentIndex == 0 ? primaryColor : secondaryColor;

  String getCurrentTabTitle() => _currentIndex == 0 ? 'Notes' : 'Todos';
}

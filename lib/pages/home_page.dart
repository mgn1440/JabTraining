import 'package:flutter/material.dart';
import 'package:jab_training/pages/setting_page.dart';
import 'package:jab_training/pages/schedule_page.dart';
import 'package:jab_training/pages/reservation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>[
    '스케줄',
    '나의 예약',
    '개인 설정',
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    SchedulePage(),
    ReservationsPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: '스케줄',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '나의 예약',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '개인 설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

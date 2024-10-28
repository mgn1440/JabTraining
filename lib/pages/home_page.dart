import 'package:flutter/material.dart';
import 'package:jab_training/pages/setting_page.dart';
import 'package:jab_training/pages/schedule_page.dart';
import 'package:jab_training/pages/reservation_page.dart';
import 'package:jab_training/pages/equipment_page.dart';
import 'package:jab_training/component/video_list_component.dart';
import 'package:jab_training/pages/workout_video_page.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/custom_app_bar.dart';

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
    '시설 소개',
    '운동 영상',
    '개인 설정',
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    SchedulePage(),
    ReservationsPage(),
    EquipmentPage(),
    WorkoutVideoPage(),
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
      appBar: CustomAppBar(
        title: _titles[_selectedIndex],
        iconStat: false,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3), // 그림자의 방향을 위쪽으로 설정
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
              icon: Icon(Icons.fitness_center),
              label: '시설 소개',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: '운동 영상',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '개인 설정',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: primarySwatch[500],
          backgroundColor: background2,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

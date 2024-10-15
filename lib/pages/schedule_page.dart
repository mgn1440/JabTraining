import 'package:flutter/material.dart';
import 'package:jab_training/pages/gym_select_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';
import 'package:jab_training/models/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jab_training/provider/calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:jab_training/const/color.dart';
import 'dart:async';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final supabase = Supabase.instance.client;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  late SharedPreferences prefs;
  bool _isLoading = false;
  String _currentLocation = '';
  int _selectedLocationId = 1;
  late final calendarProvider = Provider.of<CalendarProvider>(context);

  void startDayChangeListener() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now(); // 현재는 무조건 캘린더 범위의 첫 날
      DateTime currentFocusedDay = calendarProvider.focusedDay;

      // 자정을 지나 현재 날짜가 범위에서 벗어난 경우, focusedDay를 업데이트
      if (currentFocusedDay.isBefore(now)) {
        // 현재 날짜가 자정을 지나면 currentFocusedDay를 오늘 날짜로 업데이트
        calendarProvider.updateFocusedDay(now);
        calendarProvider.updateSelectedDate(now);
      }
    });
  }

  int? getLocationIdByName(String name) {
    for (var location in _gymLocations) {
      if (location['name'] == name) {
        return location['id'] as int?;
      }
    }
    return null; // 해당 이름의 지점이 없을 경우 null 반환
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLocation = prefs.getString('centerName') ?? '';
      _selectedLocationId = getLocationIdByName(_currentLocation) ?? 1;
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    startDayChangeListener();
  }

  final List<Map<String, dynamic>> _gymLocations = [
    {'id': 1, 'name': '잽 트레이닝 교대점'},
    {'id': 2, 'name': '잽 트레이닝 역삼점'},
    {'id': 3, 'name': '잽 트레이닝 선릉점'},
  ];

  Stream<List<Workout>> getSelectDayWorkouts(DateTime date) {
    return supabase
        .from('workouts')
        .stream(primaryKey: ['id'])
        .eq('workout_date', date.toIso8601String().split('T')[0])
        .order('start_time', ascending: true)
        .map((data) => (data as List).map((e) => Workout.fromMap(e)).toList());
  }

  void _selectGymLocation() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GymSelectPage()),
    );

    if (result != null && result is String) {
      await prefs.setString('centerName', result);
      setState(() {
        _currentLocation = result;
        _selectedLocationId = getLocationIdByName(result) ?? 1;
      });
    }
  }

  Future<bool> isWorkoutReserved(String workoutId) async {
    final userId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('reservations')
        .select()
        .eq('workout_id', workoutId)
        .eq('user_id', userId)
        .maybeSingle(); // 해당 예약이 없을 경우 null 반환
    return response != null; // null이 아니면 예약된 상태
  }

  void _handleReserve(Workout workout) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.from('reservations').insert({
        'user_id': supabase.auth.currentUser!.id,
        'workout_id': workout.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('예약이 완료되었습니다.'),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약에 실패했습니다. 잠시 후 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  StartingDayOfWeek getStartingDayOfWeek() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return StartingDayOfWeek.monday;
      case DateTime.tuesday:
        return StartingDayOfWeek.tuesday;
      case DateTime.wednesday:
        return StartingDayOfWeek.wednesday;
      case DateTime.thursday:
        return StartingDayOfWeek.thursday;
      case DateTime.friday:
        return StartingDayOfWeek.friday;
      case DateTime.saturday:
        return StartingDayOfWeek.saturday;
      case DateTime.sunday:
        return StartingDayOfWeek.sunday;
      default:
        return StartingDayOfWeek.monday; // 기본값 (안전장치)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: grayscaleSwatch[100],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentLocation,
                      style: TextStyle(
                        color: grayscaleSwatch[100],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: _selectGymLocation,
                  child: Text(
                    '바꾸기',
                    style: TextStyle(
                      color: primarySwatch[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
            ],
          )),
      body: Column(
        children: [
          TableCalendar(
            headerVisible: false, // 년도와 달 뜨는 헤더
            daysOfWeekHeight: 50,
            focusedDay: calendarProvider.focusedDay,
            firstDay: DateTime.now(), // 오늘 포함 7일 표시
            lastDay: DateTime.now().add(const Duration(days: 14)),
            startingDayOfWeek: getStartingDayOfWeek(),
            calendarFormat: _calendarFormat,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: grayscaleSwatch[100]),
              weekendStyle: TextStyle(color: grayscaleSwatch[100]),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(calendarProvider.selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(calendarProvider.selectedDate, selectedDay)) {
                calendarProvider.updateFocusedDay(focusedDay);
                calendarProvider.updateSelectedDate(selectedDay);
              }
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(),
              selectedDecoration: BoxDecoration(
                color: primarySwatch[500],
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: grayscaleSwatch[100]),
              weekendTextStyle: TextStyle(color: grayscaleSwatch[100]),
              defaultTextStyle: TextStyle(color: grayscaleSwatch[100]),
              selectedTextStyle: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: StreamBuilder<List<Workout>>(
                  stream: getSelectDayWorkouts(
                      calendarProvider.selectedDate ?? DateTime.now()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}'); // DEBUG
                      return const Center(
                        child: Text('오류가 발생했습니다! 다시 시도해주세요.'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('선택한 날짜의 운동 수업이 없습니다.'),
                      );
                    }
                    final workouts = snapshot.data!
                        .where((workout) =>
                            workout.locationId == _selectedLocationId)
                        .toList();
                    if (workouts.isEmpty) {
                      return const Center(
                        child: Text('선택한 날짜의 운동 수업이 없습니다.'),
                      );
                    }
                    return ListView.separated(
                        itemCount: workouts.length,
                        separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: grayscaleSwatch[400],
                            ),
                        itemBuilder: (context, index) {
                          final workout = workouts[index];
                          return FutureBuilder<bool>(
                              future: isWorkoutReserved(workout.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  print('Error: ${snapshot.error}'); // DEBUG
                                  return const Center(
                                      child: Text('오류가 발생했습니다! 다시 시도해주세요.'));
                                }
                                final isReserved = snapshot.data ?? false;
                                return WorkoutTile(
                                  workoutName: workout.workoutName,
                                  startTime: workout.startTime.toLocal(),
                                  duration: workout.duration,
                                  onReserve: _isLoading
                                      ? () => {}
                                      : () => _handleReserve(workout),
                                  locationId: workout.locationId,
                                  isReserved: isReserved,
                                );
                              });
                        });
                  })),
        ],
      ),
    );
  }
}

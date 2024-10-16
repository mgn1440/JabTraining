import 'package:flutter/material.dart';
import 'package:jab_training/pages/gym_select_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';
import 'package:jab_training/models/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jab_training/provider/calendar_provider.dart';
import 'package:jab_training/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/gym_select_app_bar.dart';
import 'dart:async';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool _isInit = false;
  final supabase = Supabase.instance.client;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  late SharedPreferences prefs;
  bool _isLoading = false;
  late final calendarProvider = Provider.of<CalendarProvider>(context);
  late LocationProvider locationProvider =
      Provider.of<LocationProvider>(context);

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

  @override
  void initState() {
    super.initState();
    startDayChangeListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // locationProvider = Provider.of<LocationProvider>(context);
      locationProvider.initialize();
      _isInit = !_isInit;
    }
  }

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
      prefs = await SharedPreferences.getInstance();
      await prefs.setString('centerName', result);
      locationProvider.updateCurrentLocation(result);
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
      appBar: GymSelectAppBar(),
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
                            workout.locationId ==
                            locationProvider.currentLocationId)
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

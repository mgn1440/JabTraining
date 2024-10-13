import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';
import 'package:jab_training/models/workout.dart';
import 'package:jab_training/provider/calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:jab_training/const/color.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final supabase = Supabase.instance.client;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  bool _isLoading = false;
  late final calendarProvider = Provider.of<CalendarProvider>(context);

  // TODO: 사용자가 선택한 체육관 정보 가져와야 함
  int _selectedLocationId = 2;
  String _currentLocation = 'JabTraining 역삼점';

  final List<Map<String, dynamic>> _gymLocations = [
    {'id': 1, 'name': 'JabTraining 선릉점'},
    {'id': 2, 'name': 'JabTraining 역삼점'},
    {'id': 3, 'name': 'JabTraining 교대점'},
  ];

  Stream<List<Workout>> getSelectDayWorkouts(DateTime date) {
    return supabase
        .from('workouts')
        .stream(primaryKey: ['id'])
        .eq('workout_date', date.toIso8601String().split('T')[0])
        .map((data) => (data as List).map((e) => Workout.fromMap(e)).toList());
  }

  void _selectGymLocation() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
              itemCount: _gymLocations.length,
              itemBuilder: (context, index) {
                final location = _gymLocations[index];
                return ListTile(
                  title: Text(location['name'] as String),
                  onTap: () {
                    setState(() {
                      _currentLocation = location['name'] as String;
                      _selectedLocationId = location['id'] as int;
                    });
                    Navigator.pop(context);
                  },
                );
              }
          );
        }
    );
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('예약이 완료되었습니다.'),
            )
        );
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            Text(_currentLocation),
            TextButton(
                onPressed: _selectGymLocation,
                child: const Text(
                  '바꾸기',
                  style: TextStyle(color: Colors.green),
                ))
          ],
        )
      ),
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
                  stream: getSelectDayWorkouts(calendarProvider.selectedDate ?? DateTime.now()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(
                        child: Text('Error: ${snapshot.error.toString()}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('선택한 날짜의 운동 수업이 없습니다.'),
                      );
                    }
                    final workouts = snapshot.data!.where((workout) => workout.locationId == _selectedLocationId).toList();
                    if (workouts.isEmpty) {
                      return const Center(child: Text('선택한 날짜의 운동 수업이 없습니다.'),);
                    }
                    return ListView.builder(
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                         final workout = workouts[index];
                          return FutureBuilder<bool>(
                            future: isWorkoutReserved(workout.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return const Center(child: Text('오류가 발생했습니다!!'));
                              }
                              final isReserved = snapshot.data ?? false;
                              return WorkoutTile(
                                  workoutName: workout.workoutName,
                                  startTime: workout.startTime,
                                  duration: workout.duration,
                                  onReserve: _isLoading
                                    ? () => {}
                                    : () => _handleReserve(workout),
                                  locationId: workout.locationId,
                                  isReserved: isReserved,
                              );
                            }
                          );
                        }
                    );
                  }
              ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';
import 'package:jab_training/models/workout.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final supabase = Supabase.instance.client;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  bool _isLoading = false;

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
            focusedDay: _focusedDay,
            firstDay: DateTime.now(), // 오늘 포함 7일 표시
            lastDay: DateTime.now().add(const Duration(days: 14)),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            daysOfWeekVisible: true,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: StreamBuilder<List<Workout>>(
                  stream: getSelectDayWorkouts(_selectedDate ?? DateTime.now()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
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
                                return const Center(child: Text('오류가 발생했습니다.'));
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

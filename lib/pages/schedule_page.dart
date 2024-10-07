import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';


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

  Stream<List<Map<String, dynamic>>> getSelectDayWorkouts(DateTime date){
    return supabase
        .from('workouts')
        .stream(primaryKey: ['id'])
        .eq('workout_date', date.toIso8601String().split('T')[0]);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
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
                  final workouts = snapshot.data!;
                  return ListView.builder(
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final workout = workouts[index];
                        final startTime = DateTime.parse(workout['start_time']);
                        final duration = workout['duration'] as int;
                        final workoutName = workout['workout_name'] as String;
                        final maxParticipants = workout['max_participants'] as int;

                        return WorkoutTile(
                            workoutName: workoutName,
                            startTime: startTime,
                            duration: duration,
                            maxParticipants: maxParticipants,
                            currentParticipants: 10,
                            onReserve: (){},
                        );

                      }
                  );
                }
            ),
        )
      ],
    );
  }
}

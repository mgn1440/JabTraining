import 'package:flutter/material.dart';
import 'package:jab_training/models/workout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final supabase = Supabase.instance.client;
  late Future<Map<DateTime, List<Workout>>> _reservationsByDate;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() {
      _reservationsByDate = fetchReservationsGroupedByDate();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _cancelReservation(String reservationId) async {
    print('Canceling reservation: $reservationId');
    try {
       await supabase
          .from('reservations')
          .delete()
          .eq('workout_id', reservationId);
       setState(() {
         _loadReservations(); // 상태 업데이트를 위해 setState를 사용
       });
        _showSnackBar('예약이 취소되었습니다.');
    } catch (e) {
      _showSnackBar('예약 취소 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, List<Workout>>>(
        future: _reservationsByDate,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // DEBUG: return Center(child: Text('Error: ${snapshot.error}'));
            return const Center(child: Text('오류가 발생했습니다'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('예약이 없습니다.'));
          }
          final reservationsByDate = snapshot.data!;
          return ListView.builder(
              itemCount: reservationsByDate.length,
              itemBuilder: (context, index) {
                final date = reservationsByDate.keys.elementAt(index);
                final reservations = reservationsByDate[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     AppBar(
                       title: Text(_formatDate(date)),
                       automaticallyImplyLeading: false,
                     ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservations[index];
                          return WorkoutTile(
                            workoutName: reservation.workoutName,
                            startTime: reservation.startTime,
                            duration: reservation.duration,
                            locationId: reservation.locationId,
                            onReserve: () => _cancelReservation(reservation.id),
                            isReservationPage: true,
                          );
                        }
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  Future<Map<DateTime, List<Workout>>> fetchReservationsGroupedByDate() async {
    final now = DateTime.now().toUtc();
    final res = await supabase
        .from('reservations')
        .select('''
          id,
          user_id,
          workout_id,
          workouts(
          id,
          workout_name,
          start_time,
          duration,
          location_id
          )
         ''')
        .eq('user_id', supabase.auth.currentUser!.id)
        .gte('workouts.start_time', now.toIso8601String());
    List<Workout> workouts = res.map((e) => Workout.fromMap(e['workouts'])).toList();
    Map<DateTime, List<Workout>> groupedWorkouts = {};

    for (var workout in workouts) {
      DateTime workoutDate = DateTime(
        workout.startTime.year,
        workout.startTime.month,
        workout.startTime.day,
      );

      if (!groupedWorkouts.containsKey(workoutDate)) {
        groupedWorkouts[workoutDate] = [];
      }
      groupedWorkouts[workoutDate]!.add(workout);
    }
    return groupedWorkouts;
  }

  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일,  ${date.year}년';
  }

}







































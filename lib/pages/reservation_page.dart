import 'package:flutter/material.dart';
import 'package:jab_training/models/workout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/workout_reservation_component.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/const/color.dart';

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

  Future<void> _cancelReservation(String reservationId) async {
    try {
       await supabase
          .from('reservations')
          .delete()
          .eq('workout_id', reservationId);
       setState(() {
         _loadReservations(); // 상태 업데이트를 위해 setState를 사용
       });
       if (mounted) {
         context.showSnackBar('예약이 취소되었습니다.', isError: false);
       }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('예약 취소 중 오류가 발생했습니다.', isError: true);
      }
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
            return Center(child: Text('Error: ${snapshot.error}'));
            //return const Center(child: Text('오류가 발생했습니다'));
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
                       backgroundColor: background,
                       title: Text(
                           _formatDate(date),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                       ),
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
                            startTime: reservation.startTime.toLocal(), // 한국시간
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
    final todayStart = DateTime.now().toUtc().toLocal();
    final todayStartDate = DateTime(todayStart.year, todayStart.month, todayStart.day); // 오늘의 시작


    final res = await supabase
        .from('reservations')
        .select('''
          workouts(
          id,
          workout_name,
          start_time,
          location_id
          )
         ''')
        .eq('user_id', supabase.auth.currentUser!.id)
        .gte('workouts.start_time', todayStartDate.toIso8601String()); // TODO: 지난 시간을 null로 가져온다.

    List<Workout> workouts = res
        .where((e) => e['workouts'] != null) // workouts가 null인 데이터 제외
        .map((e) => Workout.fromMap(e['workouts']))
        .toList();

    Map<DateTime, List<Workout>> groupedWorkouts = {};

    for (var workout in workouts) {
      DateTime workoutDate = DateTime(
        workout.startTime.toLocal().year,
        workout.startTime.toLocal().month,
        workout.startTime.toLocal().day,
      );
      if (!groupedWorkouts.containsKey(workoutDate)) {
        groupedWorkouts[workoutDate] = [];
      }
      groupedWorkouts[workoutDate]!.add(workout);
    }

    // 시간순으로 정렬
    for (var date in groupedWorkouts.keys) {
      groupedWorkouts[date]!.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return groupedWorkouts;
  }

  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일,  ${date.year}년';
  }

}







































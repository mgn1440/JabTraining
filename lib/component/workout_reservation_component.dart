import 'package:flutter/material.dart';


class WorkoutTile extends StatelessWidget {
  final String workoutName;
  final DateTime startTime;
  final int duration;
  final int maxParticipants;
  final int currentParticipants;
  final VoidCallback onReserve;


  const WorkoutTile({
    super.key,
    required this.workoutName,
    required this.startTime,
    required this.duration,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    int remainingParticipants = maxParticipants - currentParticipants;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    workoutName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                workoutName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '남은 자리: $remainingParticipants',
                    style: const TextStyle(fontSize: 14),
                  ),
                  ElevatedButton(
                    onPressed: onReserve,
                    child: const Text('예약하기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

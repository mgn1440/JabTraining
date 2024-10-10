class Workout {
  final String id;
  final String workoutName;
  final DateTime startTime;
  final int duration;
  final int locationId;

  Workout({
    required this.id,
    required this.workoutName,
    required this.startTime,
    required this.duration,
    required this.locationId,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      workoutName: map['workout_name'],
      startTime: DateTime.parse(map['start_time']),
      duration: map['duration'],
      locationId: map['location_id'],
    );
  }
}
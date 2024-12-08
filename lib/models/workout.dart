class Workout {
  final String id;
  final String workoutName;
  final DateTime startTime;
  final int locationId;
  final int capacity;

  Workout({
    required this.id,
    required this.workoutName,
    required this.startTime,
    required this.locationId,
    required this.capacity,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      workoutName: map['workout_name'],
      startTime: DateTime.parse(map['start_time']),
      locationId: map['location_id'],
      capacity: map['capacity'],
    );
  }
}
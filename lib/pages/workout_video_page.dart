import 'package:flutter/material.dart';

class WorkoutVideoPage extends StatefulWidget {
  const WorkoutVideoPage({super.key});

  @override
  State<WorkoutVideoPage> createState() => _WorkoutVideoPageState();
}

class _WorkoutVideoPageState extends State<WorkoutVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Workout Video Page'),
      ),
    );
  }
}
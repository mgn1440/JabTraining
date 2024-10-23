import 'package:flutter/material.dart';

class FitnessVideoPage extends StatefulWidget {
  const FitnessVideoPage({super.key});

  @override
  State<FitnessVideoPage> createState() => _FitnessVideoPageState();
}

class _FitnessVideoPageState extends State<FitnessVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Workout Video Page'),
      ),
    );
  }
}

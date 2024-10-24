import 'package:flutter/material.dart';

class FitnessVideoPage extends StatefulWidget {
  const FitnessVideoPage({super.key});

  @override
  State<FitnessVideoPage> createState() => _FitnessVideoPageState();
}

class _FitnessVideoPageState extends State<FitnessVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피트니스 영상'),
      ),
      body: const Center(
        child: Text('Workout Video Page'),
      ),
    );
  }
}

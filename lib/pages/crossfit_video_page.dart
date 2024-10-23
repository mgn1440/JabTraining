import 'package:flutter/material.dart';

class CrossfitVideoPage extends StatefulWidget {
  const CrossfitVideoPage({super.key});

  @override
  State<CrossfitVideoPage> createState() => _CrossfitVideoPageState();
}

class _CrossfitVideoPageState extends State<CrossfitVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Workout Video Page'),
      ),
    );
  }
}

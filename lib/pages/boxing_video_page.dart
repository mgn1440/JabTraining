import 'package:flutter/material.dart';

class BoxingVideoPage extends StatefulWidget {
  const BoxingVideoPage({super.key});

  @override
  State<BoxingVideoPage> createState() => _BoxingVideoPageState();
}

class _BoxingVideoPageState extends State<BoxingVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Workout Video Page'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CrossfitVideoPage extends StatefulWidget {
  const CrossfitVideoPage({super.key});

  @override
  State<CrossfitVideoPage> createState() => _CrossfitVideoPageState();
}

class _CrossfitVideoPageState extends State<CrossfitVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('크로스핏 영상'),
      ),
      body: const Center(
        child: Text('Workout Video Page'),
      ),
    );
  }
}

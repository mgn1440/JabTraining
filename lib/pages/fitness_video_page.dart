import 'package:flutter/material.dart';
import 'package:jab_training/component/video_list_component.dart';
import 'package:jab_training/component/custom_app_bar.dart';

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
        child: VideoListComponent(videoType: 'fitness'),
      ),
    );
  }
}

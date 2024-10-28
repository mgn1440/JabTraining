import 'package:flutter/material.dart';
import 'package:jab_training/component/video_list_component.dart';
import 'package:jab_training/component/custom_app_bar.dart';

class TeamTrainingPage extends StatefulWidget {
  const TeamTrainingPage({super.key});

  @override
  State<TeamTrainingPage> createState() => _TeamTrainingPageState();
}

class _TeamTrainingPageState extends State<TeamTrainingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
          title: '팀트레이닝 영상',
          iconStat: true,
      ),
      body: VideoListComponent(videoType: 'team'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jab_training/component/video_list_component.dart';
import 'package:jab_training/component/custom_app_bar.dart';

class CrossfitVideoPage extends StatefulWidget {
  const CrossfitVideoPage({super.key});

  @override
  State<CrossfitVideoPage> createState() => _CrossfitVideoPageState();
}

class _CrossfitVideoPageState extends State<CrossfitVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
          title: '크로스핏 영상',
          iconStat: true,
      ),
      body: VideoListComponent(videoType: 'crossfit'),
    );
  }
}

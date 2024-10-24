import 'package:flutter/material.dart';
import 'package:jab_training/component/video_component.dart';
import 'package:jab_training/component/custom_app_bar.dart';

class BoxingVideoPage extends StatefulWidget {
  const BoxingVideoPage({super.key});

  @override
  State<BoxingVideoPage> createState() => _BoxingVideoPageState();
}

class _BoxingVideoPageState extends State<BoxingVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: '복싱 영상',
        iconStat: true,
      ),
      body: VideoComponent(),
    );
  }
}

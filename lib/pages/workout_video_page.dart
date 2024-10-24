import 'package:flutter/material.dart';
import 'package:jab_training/pages/boxing_video_page.dart';
import 'package:jab_training/pages/crossfit_video_page.dart';
import 'package:jab_training/pages/fitness_video_page.dart';

class WorkoutVideoPage extends StatefulWidget {
  const WorkoutVideoPage({super.key});

  @override
  State<WorkoutVideoPage> createState() => _WorkoutVideoPageState();
}

class _WorkoutVideoPageState extends State<WorkoutVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16), // 이미지 간격 설정
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BoxingVideoPage()),
                  );
                },
                child: Image.asset('assets/images/boxing.png'),
              ),
              const SizedBox(height: 20), // 이미지 간격 설정
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CrossfitVideoPage()),
                  );
                },
                child: Image.asset('assets/images/crossfit.png'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FitnessVideoPage()),
                  );
                },
                child: Image.asset('assets/images/fitness.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


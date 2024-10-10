import 'package:flutter/material.dart';


class IntroducePage extends StatefulWidget {
  const IntroducePage({super.key});

  @override
  State<IntroducePage> createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Introduce Page'),
      ),
    );
  }
}

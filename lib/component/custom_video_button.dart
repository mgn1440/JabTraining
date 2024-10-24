import 'package:flutter/material.dart';

class CustomVideoButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final IconData iconData;
  const CustomVideoButton({
    super.key,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
      color: Colors.white,
      iconSize: 30,
    );
  }
}

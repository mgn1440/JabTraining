import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool iconStat;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.iconStat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background2.withOpacity(1.0), // 배경색 설정
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // 그림자 색상 및 투명도 설정
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // 그림자의 위치 설정
          ),
        ],
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.transparent, // AppBar의 배경색을 투명하게 설정
        elevation: 0, // AppBar의 기본 elevation 제거
        leading: iconStat
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

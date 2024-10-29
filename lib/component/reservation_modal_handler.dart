import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/custom_buttons.dart';

String formatTimeRange(DateTime startTime, int duration) {
  final endTime = startTime.add(Duration(minutes: duration));
  final startFormat = DateFormat('h:mma').format(startTime).toLowerCase();
  final endFormat = DateFormat('h:mma').format(endTime).toLowerCase();
  return '$startFormat - $endFormat';
}

Future<void> handleReservation(
    BuildContext context,
    VoidCallback onReserve,
    String workoutName,
    DateTime startTime,
    int duration,
    int locationId) async {
  final supabase = Supabase.instance.client;
  try {
    final response = await supabase
        .from('profiles')
        .select('first_check_in')
        .eq('id', supabase.auth.currentUser!.id)
        .single();

    final isFirstCheckIn = response['first_check_in'] as bool?;
    if (context.mounted) {
      if (isFirstCheckIn == false) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: background,
              width: double.infinity,
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workoutName,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: grayscaleSwatch[100]),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${startTime.month}월 ${startTime.day}일 (${[
                              '월',
                              '화',
                              '수',
                              '목',
                              '금',
                              '토',
                              '일'
                            ][startTime.weekday - 1]})',
                            style: TextStyle(
                                fontSize: 16,
                                color: grayscaleSwatch[200],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 모달 닫기
                        },
                        child: const Text(
                          '취소',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatTimeRange(startTime, duration),
                    style: TextStyle(fontSize: 14, color: grayscaleSwatch[200]),
                  ),
                  const SizedBox(height: 12),
                  const Divider(), // 줄 추가
                  const SizedBox(height: 16),
                  Center(
                    // 가운데 정렬
                    child: Column(
                      children: [
                        Text(
                          '스튜디오 이용이 처음이신가요?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: grayscaleSwatch[100],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                                fontSize: 15,
                                color: grayscaleSwatch[100]), // 기본 스타일
                            children: [
                              TextSpan(
                                text: '일주일 체험', // 볼드 텍스트
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarySwatch[500]),
                              ),
                              const TextSpan(
                                  text: '해보시고 결정하실 수 있습니다.'), // 일반 텍스트
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                                fontSize: 15,
                                color: grayscaleSwatch[100]), // 기본 스타일
                            children: [
                              const TextSpan(text: '체험권 가격은 '), // 일반 텍스트
                              TextSpan(
                                text: '30,000원', // 볼드 텍스트
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarySwatch[500]),
                              ),
                              const TextSpan(text: '입니다.'), // 일반 텍스트
                            ],
                          ),
                        ),
                        const SizedBox(height: 16), // 버튼 위 공간
                        CustomButton(
                          isEnabled: true,
                          buttonType: ButtonType.filled,
                          onPressed: () async {
                            onReserve();
                            Navigator.pop(context); // 모달 닫기
                          },
                          child: const Text('스튜디오 방문해서 결제하기'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        onReserve();
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필을 먼저 작성해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}

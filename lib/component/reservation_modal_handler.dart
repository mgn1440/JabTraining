import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> handleReservation(BuildContext context, VoidCallback onReserve) async {
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
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '운동 이름', // TODO: 실제 이름
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 모달 닫기
                        },
                        child: const Text(
                          '취소',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      '2024년 10월 19일',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Divider(), // 줄 추가
                  const SizedBox(height: 16),
                  const Text(
                    '1주일 체험권 30,000원',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      onReserve();
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: const Text('매장 방문해서 결제하기'),
                  ),
                ],
              ),
            );
          },
        );
      }
      else {
        onReserve();
      }
    }
  } catch (e) {
    if (context.mounted) {
      print(e);
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
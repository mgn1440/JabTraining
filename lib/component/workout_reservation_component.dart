import 'package:flutter/material.dart';
import 'package:jab_training/component/reservation_modal_handler.dart';
import 'package:jab_training/const/color.dart';


class WorkoutTile extends StatelessWidget {
  final String workoutName;
  final DateTime startTime;
  final int duration;
  final VoidCallback onReserve; // 등록 or 취소
  final int locationId;
  final bool isReserved;
  final bool isReservationPage;


  const WorkoutTile({
    super.key,
    required this.workoutName,
    required this.startTime,
    required this.duration,
    required this.onReserve,
    required this.locationId,
    this.isReserved = false,
    this.isReservationPage = false,
  });

  final List<String> _gymLocations = const [
    '선릉점',
    '역삼점',
    '교대점',
  ];

  String formattedTime() {
    int hour = startTime.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    // 12를 초과하는 경우 12를 빼고 0이 되는 경우 12로 설정
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12; // 0시를 12시로 변환
    }
    return '$hour:${startTime.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = startTime.isBefore(now);

    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedTime(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '$duration min',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const Spacer(),
            Text(
              workoutName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isPast) ...[
                    const SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(
                          '완료',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ] else if (isReservationPage) ...[
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end, // 텍스트 정렬
                          children: [
                            Text(
                              _gymLocations[locationId - 1],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 16,
                                  Icons.check,
                                  color: primarySwatch[500],
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '예약됨',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primarySwatch[500],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: IconButton(
                            onPressed: onReserve,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
                else if (isReserved == false) ...[
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async => handleReservation(context, onReserve),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: primarySwatch[500],
                          backgroundColor: background,
                          side: BorderSide(color: primarySwatch[500]!, width: 1),
                      ),
                      child: const Text('예약하기'),
                    ),
                  ),
                ]
                else ...[ // 스케줄 페이지에서 예약된 경우
                    SizedBox(
                      width: 100,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              size: 16,
                              Icons.check,
                              color: primarySwatch[500],
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '예약됨',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primarySwatch[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}

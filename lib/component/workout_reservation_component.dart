import 'package:flutter/material.dart';


class WorkoutTile extends StatelessWidget {
  final String workoutName;
  final DateTime startTime;
  final int duration;
  final VoidCallback onReserve; // 등록 or 취소
  final int locationId;
  final bool isReservationPage;


  const WorkoutTile({
    super.key,
    required this.workoutName,
    required this.startTime,
    required this.duration,
    required this.onReserve,
    required this.locationId,
    this.isReservationPage = false,
  });

  final List<String> _gymLocations = const [
    '선릉점',
    '역삼점',
    '교대점',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$duration분',
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
                  if (isReservationPage) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 텍스트와 아이콘을 좌우로 배치
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬
                          children: [
                            Text(
                              _gymLocations[locationId - 1],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Text(
                              '예약됨',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: onReserve,
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ]
                  else
                    ElevatedButton(
                      onPressed: onReserve,
                      child: const Text('예약하기'),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

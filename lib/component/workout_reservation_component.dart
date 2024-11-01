import 'package:flutter/material.dart';
import 'package:jab_training/component/reservation_modal_handler.dart';
import 'package:jab_training/const/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/available_slot_widget.dart';

class WorkoutTile extends StatelessWidget {
  final String workoutId;
  final String workoutName;
  final DateTime startTime;
  final VoidCallback onReserve; // 등록 or 취소
  final int locationId;
  final bool isReserved;
  final bool isReservationPage;
  final int capacity;

  const WorkoutTile({
    super.key,
    required this.workoutId,
    required this.workoutName,
    required this.startTime,
    required this.onReserve,
    required this.locationId,
    required this.capacity,
    this.isReserved = false,
    this.isReservationPage = false,
  });

  final List<String> _gymLocations = const [
    '교대점',
    '역삼점',
    '선릉점',
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

  Future<int> _fetchReservationCount(String workoutId, int capacity) async {
    final response = await Supabase.instance.client
        .from('reservations')
        .select('user_id')
        .eq('workout_id', workoutId)
        .count();
    final reservedCount = response.count ?? 0;
    return capacity - reservedCount;
  }


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = startTime.isBefore(now);

    return SizedBox(
      height: 80,
      child: Card(
        color: background2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formattedTime(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                workoutName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            crossAxisAlignment:
                                CrossAxisAlignment.end, // 텍스트 정렬
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _gymLocations[locationId - 1],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                   FutureBuilder<int>(
                       future: _fetchReservationCount(workoutId, capacity),
                       builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return const CircularProgressIndicator();
                         }
                         if (snapshot.hasError) {
                           print(snapshot.error);
                            return const Text('다시 시도해주세요');
                         }
                         final remainingSlots = snapshot.data!;
                         return AvailableSlotWidget(
                           remainingSlots: remainingSlots,
                           onReserve: onReserve,
                         );
                       }
                   )
                  ]
                  else ...[ // 스케줄 페이지에서 예약된 경우
                      SizedBox(
                        width: 100,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                size: 16,
                                Icons.check,
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
      ),
    );
  }
}

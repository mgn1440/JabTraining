import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/reservation_modal_handler.dart';

class AvailableSlotWidget extends StatelessWidget {
  final int remainingSlots;
  final VoidCallback onReserve;
  final String workoutName;
  final DateTime startTime;
  final int locationId;

  const AvailableSlotWidget({
    super.key,
    required this.remainingSlots,
    required this.onReserve,
    required this.workoutName,
    required this.startTime,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$remainingSlots자리 남음',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: ElevatedButton(
              onPressed: remainingSlots > 0
                  ? () => handleReservation(context, onReserve, workoutName, startTime, locationId)
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: primarySwatch[500],
                backgroundColor: background,
                side: BorderSide(color: primarySwatch[500]!, width: 1),
              ),
              child: const Text('예약하기'),
            ),
          ),
        ],
      ),
    );
  }
}

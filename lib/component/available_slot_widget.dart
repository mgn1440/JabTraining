import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';

class AvailableSlotWidget extends StatelessWidget {
  final int remainingSlots;
  final VoidCallback onReserve;

  const AvailableSlotWidget({
    super.key,
    required this.remainingSlots,
    required this.onReserve,
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
              onPressed: onReserve,
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

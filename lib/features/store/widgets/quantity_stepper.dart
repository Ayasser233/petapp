import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';

/// Reusable quantity stepper widget: [trash/–] [qty] [+]
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement; // removes item when qty == 1
  final bool compact;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 28.0 : 32.0;
    return Container(
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement / delete
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: quantity <= 1 ? Colors.red.shade50 : Colors.grey.shade100,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              ),
              child: Icon(
                quantity <= 1 ? Icons.delete_outline : Icons.remove,
                size: compact ? 14 : 16,
                color: quantity <= 1 ? Colors.red : AppColors.lightblack,
              ),
            ),
          ),
          // Quantity
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: compact ? 13 : 14,
              ),
            ),
          ),
          // Increment
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
              ),
              child: Icon(
                Icons.add,
                size: compact ? 14 : 16,
                color: AppColors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

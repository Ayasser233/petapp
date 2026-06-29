import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;
  final bool readOnly;

  const StarRatingWidget({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 32,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return GestureDetector(
          onTap: readOnly ? null : () => onChanged(i + 1),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: filled ? const Color(0xFFF5C518) : Colors.grey.shade400,
            size: size,
          ),
        );
      }),
    );
  }
}

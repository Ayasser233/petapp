import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';

/// Premium circular category chip — circle icon + label below.
class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static IconData _iconFor(String category) {
    final l = category.toLowerCase();
    if (l == 'all') return Icons.grid_view_rounded;
    if (l.contains('pharma') || l.contains('medicine') || l.contains('drug')) {
      return Icons.local_pharmacy_outlined;
    }
    if (l.contains('dog') || l.contains('canine') || l.contains('puppy')) {
      return Icons.pets;
    }
    if (l.contains('cat') || l.contains('feline') || l.contains('kitten')) {
      return Icons.cruelty_free_outlined;
    }
    if (l.contains('food') || l.contains('treat') || l.contains('nutrition')) {
      return Icons.restaurant_outlined;
    }
    if (l.contains('toy') || l.contains('play') || l.contains('game')) {
      return Icons.sports_handball_outlined;
    }
    if (l.contains('groom') || l.contains('bath') || l.contains('shampoo')) {
      return Icons.content_cut_outlined;
    }
    if (l.contains('collar') || l.contains('leash') || l.contains('harness')) {
      return Icons.link_rounded;
    }
    if (l.contains('health') || l.contains('vitamin') || l.contains('supplement')) {
      return Icons.favorite_border_rounded;
    }
    if (l.contains('bird') || l.contains('rabbit') || l.contains('fish')) {
      return Icons.emoji_nature_outlined;
    }
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.orange.withValues(alpha: 0.15)
                    : isDark
                        ? AppColors.lightblack
                        : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.orange
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  _iconFor(label),
                  size: 28,
                  color: selected
                      ? AppColors.orange
                      : isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 64,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.w500,
                  color: selected
                      ? AppColors.orange
                      : isDark
                          ? Colors.white70
                          : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
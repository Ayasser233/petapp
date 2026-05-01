import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/vets/models/review_model.dart';
import 'package:petapp/features/vets/screens/all_reviews_screen.dart';
import 'package:intl/intl.dart';

class VetReviews extends StatefulWidget {
  final List<ReviewModel> reviews;
  final bool isLoading;
  final int totalReviews;
  final String vetId;
  final String vetName;

  const VetReviews({
    super.key,
    required this.reviews,
    this.isLoading = false,
    this.totalReviews = 0,
    required this.vetId,
    this.vetName = '',
  });

  @override
  State<VetReviews> createState() => _VetReviewsState();
}

class _VetReviewsState extends State<VetReviews> {
  String _sortOrder = 'Default Order';
  static const _sortOptions = ['Default Order', 'Newest First', 'Highest Rated', 'Lowest Rated'];

  List<ReviewModel> get _sortedReviews {
    final list = List<ReviewModel>.from(widget.reviews);
    switch (_sortOrder) {
      case 'Newest First':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Highest Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rated':
        list.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      default:
        break;
    }
    // Show only first 4 in the preview
    return list.take(4).toList();
  }

  double get _overallRating {
    if (widget.reviews.isEmpty) return 0.0;
    final sum = widget.reviews.fold<double>(0.0, (s, r) => s + r.rating);
    return sum / widget.reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final dividerColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final dropdownBg = isDark ? Colors.grey[850]! : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                "Owner's Reviews",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _SortDropdown(
                value: _sortOrder,
                options: _sortOptions,
                onChanged: (v) => setState(() => _sortOrder = v),
                isDark: isDark,
                dropdownBg: dropdownBg,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Loading ──────────────────────────────────────────────
        if (widget.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.orange),
            ),
          )
        else ...[
          // ── Overall Rating subtitle ──────────────────────────
          Center(
            child: Text(
              'Overall Rating from ${widget.totalReviews} Visitors',
              style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
            ),
          ),
          const SizedBox(height: 16),

          // ── Overall Rating Card (single, centered) ───────────
          _RatingSummaryCard(
            rating: _overallRating,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // ── Empty State ──────────────────────────────────────
          if (widget.reviews.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.rate_review_outlined, size: 48, color: subTextColor),
                    const SizedBox(height: 12),
                    Text(
                      'No reviews yet',
                      style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // ── Review Items (first 3) ────────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sortedReviews.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: dividerColor),
              itemBuilder: (context, index) => _ReviewItem(
                review: _sortedReviews[index],
                textColor: textColor,
                subTextColor: subTextColor,
              ),
            ),
            const SizedBox(height: 16),

            // ── View More Button ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.orange,
                  side: const BorderSide(color: AppColors.orange, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(() => AllReviewsScreen(
                    vetId: widget.vetId,
                    vetName: widget.vetName,
                  ));
                },
                child: const Text(
                  'View More',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

// ── Sort Dropdown ──────────────────────────────────────────────────────────────
class _SortDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool isDark;
  final Color dropdownBg;

  const _SortDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.isDark,
    required this.dropdownBg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showMenu<String>(
          context: context,
          position: _getMenuPosition(context),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          items: options.map((o) {
            final isSelected = o == value;
            return PopupMenuItem<String>(
              value: o,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      o,
                      style: TextStyle(
                        color: isSelected ? AppColors.orange : (isDark ? Colors.white : Colors.black87),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_rounded, color: AppColors.orange, size: 18),
                ],
              ),
            );
          }).toList(),
        );
        if (selected != null) onChanged(selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: dropdownBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.orange, size: 18),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {}

  RelativeRect _getMenuPosition(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return RelativeRect.fill;
    final offset = box.localToGlobal(Offset.zero);
    return RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + box.size.height,
      offset.dx + box.size.width,
      0,
    );
  }
}

// ── Rating Summary Card (Overall only) ────────────────────────────────────────
class _RatingSummaryCard extends StatelessWidget {
  final double rating;
  final bool isDark;

  const _RatingSummaryCard({
    required this.rating,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(height: 6),
          _StarRating(rating: rating, size: 24),
          const SizedBox(height: 8),
          Text(
            'Overall Rating',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual Review Item ─────────────────────────────────────────────────────
class _ReviewItem extends StatelessWidget {
  final ReviewModel review;
  final Color textColor;
  final Color subTextColor;

  const _ReviewItem({
    required this.review,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars + "Overall Rating" label
          Row(
            children: [
              _StarRating(rating: review.rating, size: 18),
              const SizedBox(width: 8),
              Text(
                'Overall Rating',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: subTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Comment in quotes
          if (review.comment.isNotEmpty)
            Text(
              '"${review.comment}"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 6),

          // Name (bold) + date
          Row(
            children: [
              Text(
                review.userName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(review.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: subTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }
}

// ── Star Rating ────────────────────────────────────────────────────────────────
class _StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRating({required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final halfFilled = !filled && (i < rating);
        return Icon(
          halfFilled ? Icons.star_half : (filled ? Icons.star : Icons.star_border),
          color: (filled || halfFilled) ? AppColors.orange : (isDark ? Colors.grey[600] : Colors.grey[400]),
          size: size,
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/vets/models/review_model.dart';
import 'package:intl/intl.dart';

class VetReviews extends StatelessWidget {
  final List<ReviewModel> reviews;
  final bool isLoading;

  const VetReviews({
    super.key,
    required this.reviews,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.rate_review, color: AppColors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).reviews,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
              const Spacer(),
              if (reviews.isNotEmpty)
                Text(
                  '${reviews.length} ${reviews.length == 1 ? AppLocalizations.of(context).review : AppLocalizations.of(context).reviews}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subTextColor,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Loading State
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: AppColors.orange,
                ),
              ),
            )

          // Empty State
          else if (reviews.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).noReviewsYet,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: subTextColor,
                          ),
                    ),
                  ],
                ),
              ),
            )

          // Reviews List
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => Divider(
                height: 24,
                color: isDark ? Colors.grey[800] : Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _buildReviewItem(
                  context,
                  review,
                  isDark,
                  textColor,
                  subTextColor,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    ReviewModel review,
    bool isDark,
    Color textColor,
    Color? subTextColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Info and Rating
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.orange.withValues(alpha: 0.2),
              backgroundImage:
                  review.userImage != null && review.userImage!.isNotEmpty
                      ? AssetImage(review.userImage!)
                      : null,
              child: review.userImage == null || review.userImage!.isEmpty
                  ? Text(
                      review.userName.isNotEmpty
                          ? review.userName[0].toUpperCase()
                          : 'U',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // User Name and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(review.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subTextColor,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),

            // Rating Stars
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: index < review.rating ? Colors.amber : Colors.grey,
                  size: 16,
                );
              }),
            ),
          ],
        ),

        // Review Comment
        const SizedBox(height: 12),
        Text(
          review.comment,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}

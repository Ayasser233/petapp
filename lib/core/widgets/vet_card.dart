import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

/// Reusable Vet Card Component
/// Can be used in: Home Screen, Vet Explorer, Search Results, Favorites, etc.
class VetCard extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final String location;
  final String? distance;
  final String primaryImage;
  final double rating;
  final int totalReviews;
  final int yearsExperience;
  final List<String> services;
  final bool isOpen;
  final String openingStatus;
  final String? phone;
  final VoidCallback onTap;
  final VoidCallback? onCallPressed;
  final bool showDistance;
  final bool showActionButtons;
  final bool compact;

  const VetCard({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    this.distance,
    required this.primaryImage,
    required this.rating,
    required this.totalReviews,
    required this.yearsExperience,
    this.services = const [],
    required this.isOpen,
    required this.openingStatus,
    this.phone,
    required this.onTap,
    this.onCallPressed,
    this.showDistance = true,
    this.showActionButtons = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      shadowColor: isDark ? Colors.black : Colors.grey.withValues(alpha: 0.3),
      elevation: isDark ? 8 : 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVetImage(context, isDark),
            _buildVetInfo(
              context,
              isDark,
              textColor,
              subTextColor,
              chipBgColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVetImage(BuildContext context, bool isDark) {
    // Check if it's a network URL or local asset
    final isNetworkImage = primaryImage.startsWith('http://') ||
        primaryImage.startsWith('https://') ||
        primaryImage.startsWith('www.');

    return Stack(
      children: [
        // Main Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: isNetworkImage
              ? Image.network(
                  primaryImage,
                  width: double.infinity,
                  height: compact ? 120 : 150,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: compact ? 120 : 150,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: compact ? 120 : 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.local_hospital,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Image.asset(
                  primaryImage,
                  width: double.infinity,
                  height: compact ? 120 : 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: compact ? 120 : 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.local_hospital,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
        ),

        // Rating Badge (Top Right)
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$rating ($totalReviews)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),

        // Category Badge (Top Left)
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
            ),
          ),
        ),

        // Distance Badge (Bottom Right) - Only show if enabled and available
        if (showDistance && distance != null && distance!.isNotEmpty)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_car,
                      color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    distance!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVetInfo(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color? subTextColor,
    Color? chipBgColor,
  ) {
    return Padding(
      padding: EdgeInsets.all(compact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vet Name
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Location and Experience
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.orange, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subTextColor,
                        fontSize: 13,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$yearsExperience ${AppLocalizations.of(context).yearsExp}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subTextColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Opening Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOpen
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              openingStatus,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOpen ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
            ),
          ),

          // Services (if not compact)
          if (!compact && services.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: services.take(4).map((service) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: chipBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    service,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor,
                          fontSize: 11,
                        ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Action Buttons
          if (showActionButtons) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: isDark ? 8 : 2,
                    ),
                    child: Text(
                      AppLocalizations.of(context).viewDetails,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                    ),
                  ),
                ),
                if (phone != null && onCallPressed != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onCallPressed,
                      icon: const Icon(Icons.phone, color: AppColors.orange),
                      tooltip: AppLocalizations.of(context).callVet,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../models/vet_model.dart';
import '../../screens/vet_explorer_screen.dart';
import 'package:petapp/core/services/location_service.dart';

class VetExplorerCard extends StatelessWidget {
  final VetModel vet;
  final VetExplorerController controller;

  const VetExplorerCard({
    super.key,
    required this.vet,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[200];
    final locationService = Get.find<LocationService>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      shadowColor: isDark ? Colors.black : Colors.grey.withValues(alpha: 0.3),
      elevation: isDark ? 8 : 4,
      child: InkWell(
        onTap: () => controller.navigateToVetDetail(vet),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVetImage(context, isDark, locationService),
            _buildVetInfo(
                context, isDark, textColor, subTextColor, chipBgColor),
          ],
        ),
      ),
    );
  }

  /// Build vet image with overlays
  Widget _buildVetImage(
      BuildContext context, bool isDark, LocationService locationService) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.asset(
            vet.primaryImage,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        // Rating badge
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
                  AppLocalizations.of(context)
                      .ratingWithReviews(vet.rating, vet.reviews),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
        // Category badge
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
              vet.category,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        // Distance badge (if available and valid)
        if (locationService.isPermissionGranted &&
            vet.distance != 'Calculating...' &&
            vet.distance != 'Unknown' &&
            vet.distance.isNotEmpty)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_car,
                      color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    vet.distance,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Build vet info section
  Widget _buildVetInfo(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color? subTextColor,
    Color? chipBgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vet name
          Text(
            vet.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),

          // Location and experience
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.orange, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  vet.location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subTextColor,
                      ),
                ),
              ),
              Text(
                AppLocalizations.of(context)
                    .yearsExperience(vet.yearsExperience),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subTextColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Opening status
          if (vet.openingHours.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: vet.isCurrentlyOpen
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                vet.openingStatus,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: vet.isCurrentlyOpen ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          const SizedBox(height: 12),

          // Services
          if (vet.services.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vet.services.take(4).map((service) {
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
                        ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.navigateToVetDetail(vet),
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
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Quick call button
              if (vet.phone != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.snackbar(
                        AppLocalizations.of(context).callVet,
                        AppLocalizations.of(context).callingNumber(vet.phone!),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.phone, color: AppColors.orange),
                    tooltip: AppLocalizations.of(context).callVet,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

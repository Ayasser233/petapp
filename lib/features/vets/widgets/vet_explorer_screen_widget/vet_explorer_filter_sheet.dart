import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../screens/vet_explorer_screen.dart';
import '../../screens/governorate_city_selector_screen.dart';

class VetExplorerFilterSheet extends StatelessWidget {
  final VetExplorerController controller;

  const VetExplorerFilterSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              _buildHeader(context, textColor),

              // Filters Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRegionFilter(context, textColor, subTextColor),
                      const SizedBox(height: 24),
                      _buildServiceFilter(context, textColor, subTextColor),
                      const SizedBox(height: 24),
                      _buildSortFilter(context, textColor, subTextColor),
                      const SizedBox(height: 24),
                      _buildDistanceFilter(context, textColor, subTextColor),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Action buttons
              _buildActionButtons(context, isDark),
            ],
          );
        },
      ),
    );
  }

  /// Build header
  Widget _buildHeader(BuildContext context, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).filters,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: textColor),
          ),
        ],
      ),
    );
  }

  /// Build region filter
  Widget _buildRegionFilter(
      BuildContext context, Color textColor, Color? subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).region,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final selectedRegion = controller.selectedRegion.value;

          return Column(
            children: [
              // Default options
              _buildRegionOption(
                context: context,
                textColor: textColor,
                subTextColor: subTextColor,
                value: 'allRegions',
                label: AppLocalizations.of(context).allRegions,
                icon: Icons.public,
                isSelected: selectedRegion == 'allRegions',
                onTap: () {
                  controller.selectedRegion.value = 'allRegions';
                },
              ),
              const SizedBox(height: 8),
              _buildRegionOption(
                context: context,
                textColor: textColor,
                subTextColor: subTextColor,
                value: 'nearbyAutoDetect',
                label: AppLocalizations.of(context).nearbyAutoDetect,
                icon: Icons.my_location,
                isSelected: selectedRegion == 'nearbyAutoDetect',
                onTap: () {
                  controller.selectedRegion.value = 'nearbyAutoDetect';
                },
              ),
              const SizedBox(height: 16),
              // Divider
              Divider(
                color: subTextColor?.withValues(alpha: 0.3),
                height: 1,
              ),
              const SizedBox(height: 16),
              // Specific location selector
              _buildLocationSelector(
                context: context,
                textColor: textColor,
                subTextColor: subTextColor,
                currentSelection: selectedRegion == 'allRegions' ||
                        selectedRegion == 'nearbyAutoDetect'
                    ? null
                    : selectedRegion,
              ),
            ],
          );
        }),
      ],
    );
  }

  /// Build a region option card
  Widget _buildRegionOption({
    required BuildContext context,
    required Color textColor,
    required Color? subTextColor,
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orange.withValues(alpha: 0.1)
              : (isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.orange
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.orange : textColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.orange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// Build location selector that opens the city selector screen
  Widget _buildLocationSelector({
    required BuildContext context,
    required Color textColor,
    required Color? subTextColor,
    required String? currentSelection,
  }) {
    final isDark = THelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: () async {
        // Open the governorate/city selector screen
        final result = await Get.to<String>(
          () => const GovernorateCitySelectorScreen(),
          transition: Transition.rightToLeft,
        );

        if (result != null) {
          controller.selectedRegion.value = result;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: currentSelection != null
              ? AppColors.orange.withValues(alpha: 0.1)
              : (isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: currentSelection != null
                ? AppColors.orange
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: currentSelection != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: currentSelection != null
                    ? AppColors.orange
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                currentSelection != null
                    ? Icons.location_on
                    : Icons.add_location_alt,
                color: currentSelection != null
                    ? Colors.white
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSelection ?? AppLocalizations.of(context).selectGovernorateOrCity,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: currentSelection != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: currentSelection != null ? AppColors.orange : subTextColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// Build region dropdown items - REMOVED (no longer needed)

  /// Build service filter
  Widget _buildServiceFilter(
      BuildContext context, Color textColor, Color? subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).service,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 12),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: controller.selectedService.value,
                isExpanded: true,
                underline: const SizedBox(),
                items: _buildServiceDropdownItems(context, textColor),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedService.value = newValue;
                  }
                },
              ),
            )),
      ],
    );
  }

  /// Build service dropdown items
  List<DropdownMenuItem<String>> _buildServiceDropdownItems(
      BuildContext context, Color textColor) {
    final services = [
      'allServices',
      ...controller.availableServices,
    ];

    return services.map((service) {
      String displayText;

      switch (service) {
        case 'allServices':
          displayText = AppLocalizations.of(context).allServices;
          break;
        case 'vaccination':
          displayText = AppLocalizations.of(context).vaccination;
          break;
        case 'checkup':
          displayText = AppLocalizations.of(context).checkup;
          break;
        case 'surgery':
          displayText = AppLocalizations.of(context).surgery;
          break;
        case 'consultation':
          displayText = AppLocalizations.of(context).consultation;
          break;
        case 'emergency':
          displayText = AppLocalizations.of(context).emergency;
          break;
        case 'grooming':
          displayText = AppLocalizations.of(context).grooming;
          break;
        default:
          displayText = service;
      }

      return DropdownMenuItem<String>(
        value: service,
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
        ),
      );
    }).toList();
  }

  /// Build sort filter
  Widget _buildSortFilter(
      BuildContext context, Color textColor, Color? subTextColor) {
    final sortOptions = [
      {'value': 'default', 'label': AppLocalizations.of(context).sortDefault},
      {'value': 'nearby', 'label': AppLocalizations.of(context).sortNearby},
      {'value': 'rating', 'label': AppLocalizations.of(context).sortRating},
      {'value': 'reviews', 'label': AppLocalizations.of(context).sortReviews},
      {'value': 'name', 'label': AppLocalizations.of(context).sortName},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).sortBy,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 12),
        Obx(() => RadioGroup<String>(
              groupValue: controller.sortOption.value,
              onChanged: (String? value) {
                if (value != null) {
                  controller.sortOption.value = value;
                }
              },
              child: Column(
                children: sortOptions.map((option) {
                  return RadioListTile<String>(
                    value: option['value']!,
                    title: Text(
                      option['label']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                    ),
                    activeColor: AppColors.orange,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }

  /// Build distance filter
  Widget _buildDistanceFilter(
      BuildContext context, Color textColor, Color? subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).maxDistance,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 12),
        Obx(() => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .distanceKm(controller.maxDistance.value.round()),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                    ),
                    Text(
                      AppLocalizations.of(context).anyDistance,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subTextColor,
                          ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.orange,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: AppColors.orange,
                    overlayColor: AppColors.orange.withValues(alpha: 0.2),
                    valueIndicatorColor: AppColors.orange,
                  ),
                  child: Slider(
                    value: controller.maxDistance.value,
                    min: 5.0,
                    max: 100.0,
                    divisions: 19,
                    label: AppLocalizations.of(context)
                        .distanceKm(controller.maxDistance.value.round()),
                    onChanged: (double value) {
                      controller.maxDistance.value = value;
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                controller.clearAllFilters();
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.orange,
                side: const BorderSide(color: AppColors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                AppLocalizations.of(context).clearAll,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.applyFilters();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: isDark ? 8 : 2,
              ),
              child: Text(
                AppLocalizations.of(context).applyFilters,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

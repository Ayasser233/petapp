import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../screens/clinic_explorer_screen.dart';

class ClinicExplorerFilterSheet extends StatelessWidget {
  final ClinicExplorerController controller;

  const ClinicExplorerFilterSheet({
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
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: textColor),
          ),
        ],
      ),
    );
  }

  /// Build region filter
  Widget _buildRegionFilter(BuildContext context, Color textColor, Color? subTextColor) {
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
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: controller.selectedRegion.value,
                isExpanded: true,
                underline: const SizedBox(),
                items: _buildRegionDropdownItems(context, textColor),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedRegion.value = newValue;
                  }
                },
              ),
            )),
      ],
    );
  }

  /// Build region dropdown items
  List<DropdownMenuItem<String>> _buildRegionDropdownItems(BuildContext context, Color textColor) {
    final items = <DropdownMenuItem<String>>[];
    
    for (final region in controller.regions) {
      String displayText;
      
      switch (region) {
        case 'allRegions':
          displayText = AppLocalizations.of(context).allRegions;
          break;
        case 'nearbyAutoDetect':
          displayText = AppLocalizations.of(context).nearbyAutoDetect;
          break;
        default:
          displayText = region;
      }
      
      items.add(
        DropdownMenuItem<String>(
          value: region,
          child: Text(
            displayText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
          ),
        ),
      );
      
      // Add cities for governorates
      if (controller.isGovernorate(region)) {
        final cities = controller.getCitiesForGovernorate(region);
        for (final city in cities) {
          items.add(
            DropdownMenuItem<String>(
              value: city,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '• $city',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                      ),
                ),
              ),
            ),
          );
        }
      }
    }
    
    return items;
  }

  /// Build service filter
  Widget _buildServiceFilter(BuildContext context, Color textColor, Color? subTextColor) {
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
  List<DropdownMenuItem<String>> _buildServiceDropdownItems(BuildContext context, Color textColor) {
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
  Widget _buildSortFilter(BuildContext context, Color textColor, Color? subTextColor) {
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
        Obx(() => Column(
              children: sortOptions.map((option) {
                return RadioListTile<String>(
                  value: option['value']!,
                  groupValue: controller.sortOption.value,
                  title: Text(
                    option['label']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                        ),
                  ),
                  activeColor: AppColors.orange,
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.sortOption.value = value;
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            )),
      ],
    );
  }

  /// Build distance filter
  Widget _buildDistanceFilter(BuildContext context, Color textColor, Color? subTextColor) {
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
                      AppLocalizations.of(context).distanceKm(controller.maxDistance.value.round()),
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
                    overlayColor: AppColors.orange.withOpacity(0.2),
                    valueIndicatorColor: AppColors.orange,
                  ),
                  child: Slider(
                    value: controller.maxDistance.value,
                    min: 5.0,
                    max: 100.0,
                    divisions: 19,
                    label: AppLocalizations.of(context).distanceKm(controller.maxDistance.value.round()),
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
                Get.back();
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
                Get.back();
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
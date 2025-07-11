import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class ClinicHeader extends StatelessWidget {
  final Map<String, dynamic> clinic;

  const ClinicHeader({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clinic Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            clinic['image'] ?? 'assets/images/pet_hospital.jpg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.local_hospital,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Clinic Name and Favorite Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                clinic['name'] ?? 'BluePearl Pet Hospital',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppColors.orange,
              ),
              onPressed: () {
                // Handle favorite
              },
            ),
          ],
        ),
        
        // Location
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.orange,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              clinic['location'] ?? 'Healdsburg, CA',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: subTextColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '• ${clinic['distance'] ?? '11 ${AppLocalizations.of(context).minutes}'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: subTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
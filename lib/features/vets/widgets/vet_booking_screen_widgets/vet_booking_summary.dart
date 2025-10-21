import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../screens/vet_booking_screen.dart';

class VetBookingSummary extends StatelessWidget {
  final VetBookingController controller;

  const VetBookingSummary({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    // Get vet data from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final vetName = args?['vet']?['name'];
    final serviceName = args?['service'];
    final price = args?['price'];

    return Card(
      color: cardColor,
      elevation: isDark ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).bookingDetails,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              Icons.local_hospital,
              AppLocalizations.of(context).vet,
              vetName,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              Icons.medical_services,
              AppLocalizations.of(context).service,
              serviceName,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              Icons.attach_money,
              AppLocalizations.of(context).price,
              price,
              textColor,
              subTextColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color textColor,
    Color? subTextColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: subTextColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subTextColor,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

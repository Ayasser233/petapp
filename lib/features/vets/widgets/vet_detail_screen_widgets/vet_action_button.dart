import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';

class VetActionButton extends StatelessWidget {
  final Map<String, dynamic> vet;
  final String price;

  const VetActionButton({
    super.key,
    required this.vet,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final hasEmergency = vet['hasEmergency'] == true;
    final emergencyPrice = vet['emergencyPrice'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: hasEmergency && emergencyPrice != null
          ? Row(
              children: [
                // Consultation booking button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _navigateToBooking(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        elevation: isDark ? 4 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).bookConsultation,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Emergency booking button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToBooking(context, true),
                      icon: const Icon(Icons.emergency, size: 18),
                      label: Text(
                        AppLocalizations.of(context).emergency,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        elevation: isDark ? 4 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _navigateToBooking(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  elevation: isDark ? 4 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).bookConsultation,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
    );
  }

  void _navigateToBooking(BuildContext context, bool isEmergency) {
    final emergencyPrice = vet['emergencyPrice'];
    final emergencyPriceStr = emergencyPrice != null
        ? '${emergencyPrice.toString().replaceAll(RegExp(r'\.0$'), '')} EGP'
        : null;

    Get.toNamed(
      AppRoutes.vetBooking,
      arguments: {
        'vet': vet,
        'service': isEmergency
            ? AppLocalizations.of(context).emergency
            : AppLocalizations.of(context).consultation,
        'price': isEmergency ? (emergencyPriceStr ?? price) : price,
        'isEmergency': isEmergency,
      },
    );
  }
}

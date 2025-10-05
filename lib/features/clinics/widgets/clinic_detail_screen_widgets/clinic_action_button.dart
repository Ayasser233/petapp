import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';

class ClinicActionButton extends StatelessWidget {
  final Map<String, dynamic> clinic;
  final String price;

  const ClinicActionButton({
    super.key,
    required this.clinic,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed(
              AppRoutes.hospitalBooking,
              arguments: {
                'clinic': clinic,
                'service': AppLocalizations.of(context).consultation,
                'price': price,
              },
            );
          },
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
}
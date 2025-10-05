import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class ClinicServices extends StatelessWidget {
  const ClinicServices({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;

    final services = [
      AppLocalizations.of(context).generalWellnessExam,
      AppLocalizations.of(context).vaccinations,
      AppLocalizations.of(context).microchipping,
      AppLocalizations.of(context).nutritionalCounseling,
      AppLocalizations.of(context).laboratoryServices,
      AppLocalizations.of(context).surgery,
      AppLocalizations.of(context).dentalCare,
      AppLocalizations.of(context).emergencyCare,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).services,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        ...services.map((service) => _buildServiceBullet(context, service, textColor)),
      ],
    );
  }

  Widget _buildServiceBullet(BuildContext context, String service, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
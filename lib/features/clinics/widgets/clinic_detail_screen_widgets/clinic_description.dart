import 'package:flutter/material.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class ClinicDescription extends StatelessWidget {
  final Map<String, dynamic> clinic;

  const ClinicDescription({
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
        Text(
          AppLocalizations.of(context).description,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          clinic['description'] ?? AppLocalizations.of(context).defaultClinicDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: subTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
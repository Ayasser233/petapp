import 'package:flutter/material.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class VetDescription extends StatelessWidget {
  final Map<String, dynamic> vet;

  const VetDescription({
    super.key,
    required this.vet,
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
          vet['description'] ?? AppLocalizations.of(context).defaultvetDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: subTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class ClinicWorkingHours extends StatelessWidget {
  const ClinicWorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    final workHours = {
      AppLocalizations.of(context).mondayFriday: '9:00 AM - 7:00 PM',
      AppLocalizations.of(context).saturday: '10:00 AM - 5:00 PM',
      AppLocalizations.of(context).sunday: AppLocalizations.of(context).closed,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).workingHours,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: workHours.entries.map((entry) {
              final bool isClosed = entry.value == AppLocalizations.of(context).closed;
              final bool isSunday = entry.key == AppLocalizations.of(context).sunday;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: isSunday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isClosed ? Colors.red[300] : subTextColor,
                        fontWeight: isSunday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
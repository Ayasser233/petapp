import 'package:flutter/material.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class VetStats extends StatelessWidget {
  final Map<String, dynamic> vet;

  const VetStats({
    super.key,
    required this.vet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            vet['reviews']?.toString() ?? '127',
            AppLocalizations.of(context).reviews,
            textColor,
            subTextColor,
          ),
          _buildStatDivider(isDark),
          _buildStatItem(
            context,
            vet['patients']?.toString() ?? '709',
            AppLocalizations.of(context).patients,
            textColor,
            subTextColor,
          ),
          _buildStatDivider(isDark),
          _buildStatItem(
            context,
            vet['yearsExperience']?.toString() ?? '15',
            AppLocalizations.of(context).yearsExp,
            textColor,
            subTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, Color textColor, Color? subTextColor) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: subTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      height: 30,
      width: 1,
      color: isDark ? Colors.grey[800] : Colors.grey[300],
    );
  }
}
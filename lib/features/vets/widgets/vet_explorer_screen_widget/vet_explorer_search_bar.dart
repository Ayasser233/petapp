import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../../../core/services/facebook_event_service.dart';
import '../../screens/vet_explorer_screen.dart';

class VetExplorerSearchBar extends StatelessWidget {
  final VetExplorerController controller;

  const VetExplorerSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final searchBgColor = isDark ? AppColors.lightblack : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: searchBgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: subTextColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              focusNode: controller.searchFocusNode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchVetsHint,
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: subTextColor,
                    ),
              ),
              onChanged: controller.updateSearchQuery,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  FacebookEventService.logSearch(
                    searchString: value.trim(),
                    contentType: 'vet',
                  );
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune, color: subTextColor),
            onPressed: controller.showFilterModal,
            tooltip: AppLocalizations.of(context).filters,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class ActivityFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ActivityFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  static const List<String> _filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = selectedFilter.toLowerCase() == filter.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              label: _getLocalizedFilter(context, filter),
              isSelected: isSelected,
              onTap: () => onFilterChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getLocalizedFilter(BuildContext context, String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        return AppLocalizations.of(context).all;
      case 'upcoming':
        return AppLocalizations.of(context).upcoming;
      case 'completed':
        return AppLocalizations.of(context).completed;
      case 'cancelled':
        return AppLocalizations.of(context).cancelled;
      default:
        return filter;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.orange 
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: isDark && !isSelected 
              ? Border.all(color: Colors.grey[700]!, width: 1)
              : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.orange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.grey[300] : Colors.grey[700]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
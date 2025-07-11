import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import '../../screens/clinic_explorer_screen.dart';

class ClinicExplorerCategoryTabs extends StatelessWidget {
  final ClinicExplorerController controller;

  const ClinicExplorerCategoryTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.getLocalizedCategories(context).length,
        itemBuilder: (context, index) {
          final category = controller.getLocalizedCategories(context)[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;

            return GestureDetector(
              onTap: () => controller.updateCategory(category),
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.orange : Colors.transparent,
                  ),
                ),
                child: Text(
                  controller.getCategoryDisplayName(context, category),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? AppColors.orange : textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
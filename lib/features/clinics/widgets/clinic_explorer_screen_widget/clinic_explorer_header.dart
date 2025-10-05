import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/location_service.dart';
import '../../screens/clinic_explorer_screen.dart';

class ClinicExplorerHeader extends StatelessWidget implements PreferredSizeWidget {
  final ClinicExplorerController controller;

  const ClinicExplorerHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final locationService = Get.find<LocationService>();


    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      elevation: 0,
      title: Text(
        AppLocalizations.of(context).findClinics,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
      ),
      centerTitle: true,
      actions: [
        Obx(() => IconButton(
              onPressed: () {
                if (locationService.isPermissionGranted) {
                  controller.refreshData();
                } else {
                  controller.requestLocationPermission();
                }
              },
              icon: locationService.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
                      ),
                    )
                  : Icon(
                      locationService.isPermissionGranted
                          ? Icons.location_on
                          : Icons.location_off,
                      color: locationService.isPermissionGranted
                          ? AppColors.orange
                          : Colors.grey,
                    ),
              tooltip: locationService.isPermissionGranted
                  ? AppLocalizations.of(context).refreshLocation
                  : AppLocalizations.of(context).enableLocation,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
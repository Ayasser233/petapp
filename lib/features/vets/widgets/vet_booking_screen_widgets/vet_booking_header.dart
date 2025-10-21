import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../screens/vet_booking_screen.dart';

class VetBookingHeader extends StatelessWidget implements PreferredSizeWidget {
  final VetBookingController controller;

  const VetBookingHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;

    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Get.back(),
      ),
      title: Text(
        AppLocalizations.of(context).bookVetVisit,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
      ),
      centerTitle: true,
      actions: [
        Obx(() => controller.isBookingConfirmed.value
            ? const SizedBox.shrink()
            : IconButton(
                icon: Icon(Icons.refresh, color: textColor),
                onPressed: controller.resetBooking,
                tooltip: AppLocalizations.of(context).resetBooking,
              )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Commented out - only needed for notifications
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Commented out - only needed for notifications
// import 'package:petapp/core/utils/app_colors.dart'; // Commented out - only needed for notifications
import 'package:petapp/core/utils/constants.dart';
// import 'package:petapp/features/notifications/controllers/notification_controller.dart'; // Commented out - only needed for notifications

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool isDark;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    required this.isDark,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: isDark ? Colors.black : Colors.white,
      toolbarHeight: 80,
      title: showLogo
          ? Image.asset(
              isDark ? Constants.mainlogoDark : Constants.mainlogoLight,
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            )
          : Text(
              title ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
            ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
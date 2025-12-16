import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/constants.dart';
import 'package:petapp/features/notifications/controllers/notification_controller.dart';

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
      toolbarHeight: 80, // Increased height
      flexibleSpace: Container(
        padding: const EdgeInsets.fromLTRB(32.0,30.0,32.0, 10.0), // Adjusted padding to move content down
        alignment: Alignment.bottomCenter, // Align to bottom
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, // Center the items vertically
          
          children: [
            // Show logo or title
            showLogo
                ? Image.asset(
                    isDark ? Constants.mainlogoDark : Constants.mainlogoLight,
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                  )
                : Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                  ),
            // Actions and notification icon
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Custom actions
                if (actions != null) ...actions!,
                if (actions != null) const SizedBox(width: 8),
                // Notification icon
                GetX<NotificationController>(
                  init: NotificationController(),
                  builder: (controller) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.lightblack : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.bell,
                              color: isDark ? AppColors.orange : AppColors.orange,
                              size: 24,
                            ),
                            onPressed: () {
                              Get.toNamed('/notifications');
                            },
                          ),
                        ),
                        // Unread badge
                        if (controller.unreadCount.value > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? Colors.black : Colors.white,
                                  width: 2,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  controller.unreadCount.value > 9
                                      ? '9+'
                                      : '${controller.unreadCount.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Update this to match toolbarHeight
}
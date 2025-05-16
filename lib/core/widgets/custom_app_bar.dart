import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool isDark;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    required this.isDark,
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
            // Notification icon
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.lightblack : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDark ? AppColors.orange : Colors.grey[700],
                ),
                onPressed: () {
                  // Handle notification tap
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Update this to match toolbarHeight
}
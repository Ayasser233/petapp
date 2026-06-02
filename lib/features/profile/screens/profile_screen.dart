import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/review_service.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/profile/screens/account_details_screen.dart';
import 'package:petapp/core/services/whatsapp_launcher_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final backgroundColor = isDark ? Colors.black : const Color(0xFFF5F5F5);
    final localizations = AppLocalizations.of(context);
    final authService = Get.find<AuthService>();
    final isGuest = authService.authStatus == AuthStatus.guest;

    return BaseScreen(
      navBarIndex: 2,
      appBar: AppBar(
        title: Text(localizations.myProfile),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Guest user banner
                if (isGuest) _buildGuestProfileBanner(context, isDark),

                // ── Grouped section: Account / My Pets / Aleefy Points ──────
                _buildSectionCard(
                  context,
                  isDark: isDark,
                  cardColor: cardColor,
                  items: [
                    if (!isGuest)
                      _SectionItem(
                        icon: FontAwesomeIcons.circleUser,
                        label: localizations.myAccount,
                        onTap: () {
                          try {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const AccountDetailsScreen(),
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  localizations.errorOpeningAccountDetails),
                            ));
                          }
                        },
                      ),
                    _SectionItem(
                      icon: FontAwesomeIcons.paw,
                      label: localizations.myPets,
                      onTap: () => isGuest
                          ? _showLoginRequiredDialog(context)
                          : Get.toNamed(AppRoutes.myPets),
                    ),
                    _SectionItem(
                      icon: FontAwesomeIcons.star,
                      label: localizations.aleefyPoints,
                      onTap: () => isGuest
                          ? _showLoginRequiredDialog(context)
                          : Get.toNamed(AppRoutes.pointsHistory),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Grouped section: Settings / Rate the App / Contact Support ──
                _buildSectionCard(
                  context,
                  isDark: isDark,
                  cardColor: cardColor,
                  items: [
                    _SectionItem(
                      icon: FontAwesomeIcons.gear,
                      label: localizations.settings,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    _SectionItem(
                      icon: FontAwesomeIcons.solidStar,
                      label: 'Rate the App',
                      onTap: () => _rateApp(context),
                    ),
                    _SectionItem(
                      icon: FontAwesomeIcons.headset,
                      label: 'Contact Support',
                      onTap: () => _showSupportOptions(context),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _buildProfileOption(
                  context,
                  localizations.logout,
                  FontAwesomeIcons.arrowRightFromBracket,
                  () async {
                    // Show confirmation dialog
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(localizations.logout),
                        content: Text(localizations.areYouSureYouWantToLogout),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(localizations.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(localizations.logout),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true) {
                      // Show loading indicator
                      Get.dialog(
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                        ),
                        barrierDismissible: false,
                      );

                      try {
                        // Call AuthService signOut which handles API call and cleanup
                        await authService.signOut();

                        // Close loading dialog
                        Get.back();

                        // Navigate to login screen
                        Get.offAllNamed(AppRoutes.login);

                        // Show success message
                        Get.snackbar(
                          localizations.success,
                          localizations.loggedOutSuccessfully,
                          backgroundColor: AppColors.orange,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } catch (e) {
                        // Close loading dialog
                        Get.back();

                        // Show error message
                        Get.snackbar(
                          localizations.error,
                          localizations.logoutFailed,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                  textColor: Colors.red,
                ),

                // Social media links and footer
                const SizedBox(height: 24),

                // Social media section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        localizations.followUs,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(
                            FontAwesomeIcons.facebook,
                            context,
                            'Facebook',
                            'https://www.facebook.com/aleefyapp',
                          ),
                          const SizedBox(width: 24),
                          _buildSocialIcon(
                            FontAwesomeIcons.instagram,
                            context,
                            'Instagram',
                            'https://instagram.com/aleefy_app',
                          ),
                          const SizedBox(width: 24),
                          _buildSocialIcon(
                            FontAwesomeIcons.globe,
                            context,
                            'Website',
                            'https://aleefy-app.com',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Terms and Privacy Policy
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to terms
                      },
                      child: Text(
                        localizations.termsOfService,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      ' · ',
                      style: TextStyle(color: subTextColor),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to privacy policy in-app screen
                        Navigator.pushNamed(context, '/privacy-policy');
                      },
                      child: Text(
                        localizations.privacyPolicy,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  '${localizations.appTitle} v1.0.0',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Grouped section card ──────────────────────────────────────────────────

  Widget _buildSectionCard(
    BuildContext context, {
    required bool isDark,
    required Color cardColor,
    required List<_SectionItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildSectionTile(context, items[i], isDark: isDark),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 56,
                endIndent: 16,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.06),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTile(
    BuildContext context,
    _SectionItem item, {
    required bool isDark,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightorange.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(item.icon, color: AppColors.orange, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight,
                size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ── Support bottom sheet ──────────────────────────────────────────────────

  void _showSupportOptions(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how you\'d like to reach us',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),

              // WhatsApp option
              _buildSheetOption(
                context: ctx,
                icon: FontAwesomeIcons.whatsapp,
                iconColor: const Color(0xFF25D366),
                label: 'WhatsApp',
                subtitle: 'Chat with us directly',
                onTap: () {
                  Navigator.pop(ctx);
                  WhatsAppLauncherService.openSupportChat(context: context);
                },
                isDark: isDark,
              ),

              const SizedBox(height: 10),

              // Email option
              _buildSheetOption(
                context: ctx,
                icon: FontAwesomeIcons.envelope,
                iconColor: AppColors.orange,
                label: 'Email',
                subtitle: 'Send us an email',
                onTap: () {
                  Navigator.pop(ctx);
                  WhatsAppLauncherService.openSupportEmail(context: context);
                },
                isDark: isDark,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required BuildContext context,
    required FaIconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final cardColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7F7F7);
    final textColor = isDark ? Colors.white : Colors.black87;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            FaIcon(FontAwesomeIcons.chevronRight,
                size: 13, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // ── Rate the App ──────────────────────────────────────────────────────────

  /// The user explicitly tapped "Rate the App" — always show the prompt,
  /// bypassing cooldown / count guards, and mark as rated afterwards.
  Future<void> _rateApp(BuildContext context) =>
      ReviewService.forceOpenStoreListing(context);

  // ── Existing helpers (unchanged) ─────────────────────────────────────────

  Widget _buildProfileOption(
      BuildContext context, String title, FaIconData icon, VoidCallback onTap,
      {bool isDark = false, Color cardColor = Colors.white, Color? textColor}) {
    final defaultTextColor = isDark ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightorange.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(icon, color: AppColors.orange, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? defaultTextColor,
                ),
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
      FaIconData icon, BuildContext context, String label, String url) {
    return InkWell(
      onTap: () async {
        try {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Could not open $label'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
              ));
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error opening $label'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightorange.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(icon, color: AppColors.orange, size: 22),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.loginRequired),
        content: Text(localizations.loginRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.toNamed(AppRoutes.login);
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            child: Text(localizations.login),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfileBanner(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_outline, size: 48, color: AppColors.orange),
          const SizedBox(height: 12),
          const Text(
            'You\'re browsing as a guest',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.orange),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create an account to access all features',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Login or Register',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private data class for section tiles ─────────────────────────────────────

class _SectionItem {
  final FaIconData icon;
  final String label;
  final VoidCallback onTap;
  const _SectionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
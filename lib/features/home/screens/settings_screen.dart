import 'package:flutter/material.dart';
import 'package:petapp/core/providers/settings_provider.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:petapp/core/localization/app_localizations.dart'; // Add this import

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Add the missing _buildSectionHeader method
  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black87;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightorange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
  
  // Update the build method in the SettingsScreen class
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final backgroundColor = isDark ? Colors.black : const Color(0xFFF5F5F5);
    final localizations = AppLocalizations.of(context); // Get localizations
    
    return BaseScreen(
      navBarIndex: 2, // This is accessed from the profile screen
      appBar: AppBar(
        title: Text(localizations.settings), // Use localized string
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Section
              _buildSectionHeader(context, localizations.appearance, Icons.palette_outlined),
              const SizedBox(height: 8),
              _buildThemeSettings(context, cardColor),
              
              const SizedBox(height: 24),
              
              // Language Section
              _buildSectionHeader(context, localizations.language, Icons.language),
              const SizedBox(height: 8),
              _buildLanguageSettings(context, cardColor),
              
              const SizedBox(height: 24),
              
              // Notifications Section
              _buildSectionHeader(context, localizations.notifications, Icons.notifications_outlined),
              const SizedBox(height: 8),
              _buildNotificationSettings(context, cardColor),
              
              const SizedBox(height: 24),
              
              // Privacy Section
              _buildSectionHeader(context, localizations.privacySecurity, Icons.security_outlined),
              const SizedBox(height: 8),
              _buildPrivacySettings(context, cardColor),
              
              const SizedBox(height: 24),
              
              // About Section
              _buildSectionHeader(context, localizations.about, Icons.info_outline),
              const SizedBox(height: 8),
              _buildAboutSettings(context, cardColor),
              
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  // Update the _buildThemeSettings method
  Widget _buildThemeSettings(BuildContext context, Color cardColor) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context); // Get localizations
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRadioTile(
            context: context,
            title: localizations.lightMode,
            subtitle: localizations.useLightTheme,
            value: ThemePreference.light,
            groupValue: settingsProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                settingsProvider.setThemeMode(value);
              }
            },
            icon: Icons.light_mode_outlined,
          ),
          _buildDivider(),
          _buildRadioTile(
            context: context,
            title: localizations.darkMode,
            subtitle: localizations.useDarkTheme,
            value: ThemePreference.dark,
            groupValue: settingsProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                settingsProvider.setThemeMode(value);
              }
            },
            icon: Icons.dark_mode_outlined,
          ),
          _buildDivider(),
          _buildRadioTile(
            context: context,
            title: localizations.systemDefault,
            subtitle: localizations.useSystemTheme,
            value: ThemePreference.system,
            groupValue: settingsProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                settingsProvider.setThemeMode(value);
              }
            },
            icon: Icons.settings_suggest_outlined,
          ),
        ],
      ),
    );
  }

  // Update the _buildLanguageSettings method
  Widget _buildLanguageSettings(BuildContext context, Color cardColor) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context); // Get localizations
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRadioTile(
            context: context,
            title: localizations.english,
            subtitle: localizations.useEnglish,
            value: LanguagePreference.english,
            groupValue: settingsProvider.language,
            onChanged: (value) {
              if (value != null) {
                settingsProvider.setLanguage(value);
              }
            },
            icon: Icons.language,
          ),
          _buildDivider(),
          _buildRadioTile(
            context: context,
            title: localizations.arabic,
            subtitle: localizations.useArabic,
            value: LanguagePreference.arabic,
            groupValue: settingsProvider.language,
            onChanged: (value) {
              if (value != null) {
                settingsProvider.setLanguage(value);
              }
            },
            icon: Icons.language,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationSettings(BuildContext context, Color cardColor) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context); // Get localizations
    
    return Container(
      // Replace your current container decoration with this enhanced version
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: localizations.pushNotifications,
            subtitle: localizations.receivePushNotifications,
            value: settingsProvider.notificationsEnabled,
            onChanged: (value) {
              settingsProvider.setNotificationsEnabled(value);
            },
            icon: Icons.notifications,
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            title: localizations.emailNotifications,
            subtitle: localizations.receiveEmailUpdates,
            value: settingsProvider.emailNotificationsEnabled,
            onChanged: (value) {
              settingsProvider.setEmailNotificationsEnabled(value);
            },
            icon: Icons.email_outlined,
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            title: localizations.sound,
            subtitle: localizations.playSoundForNotifications,
            value: settingsProvider.soundEnabled,
            onChanged: (value) {
              settingsProvider.setSoundEnabled(value);
            },
            icon: Icons.volume_up_outlined,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPrivacySettings(BuildContext context, Color cardColor) {
    final localizations = AppLocalizations.of(context); // Get localizations

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            context: context,
            title: localizations.privacyPolicy,
            subtitle: localizations.readOurPrivacyPolicy,
            onTap: () {
              // Navigate to privacy policy
            },
            icon: Icons.privacy_tip_outlined,
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            title: localizations.termsOfService,
            subtitle: localizations.readOurTermsOfService,
            onTap: () {
              // Navigate to terms of service
            },
            icon: Icons.description_outlined,
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            title: localizations.deleteAccount,
            subtitle: localizations.deleteYourAccountPermanently,
            onTap: () {
              // Show delete account confirmation
              _showDeleteAccountDialog(context);
            },
            icon: Icons.delete_outline,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAboutSettings(BuildContext context, Color cardColor) {
    AppLocalizations.of(context); // Get localizations

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            context: context,
            title: 'App Version',
            subtitle: 'v1.0.0',
            onTap: () {},
            icon: Icons.info_outline,
            showArrow: false,
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            title: 'Contact Support',
            subtitle: 'Get help with the app',
            onTap: () {
              // Navigate to support
            },
            icon: Icons.support_agent_outlined,
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            title: 'Rate the App',
            subtitle: 'Leave a review on the store',
            onTap: () {
              // Open app store rating
            },
            icon: Icons.star_border,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRadioTile<T>({required BuildContext context, required String title, required String subtitle, required T value, required T groupValue, required void Function(T?)? onChanged, required IconData icon}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onChanged != null) {
            onChanged(value);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightorange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Replace the standard Radio with a custom styled one
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value == groupValue ? AppColors.orange : Colors.transparent,
                  border: Border.all(
                    color: value == groupValue ? AppColors.orange : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: value == groupValue
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({required BuildContext context, required String title, required String subtitle, required bool value, required void Function(bool) onChanged, required IconData icon}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightorange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Replace the standard Switch with a more customized one
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.orange,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionTile({required BuildContext context, required String title, required String subtitle, required VoidCallback onTap, required IconData icon, bool showArrow = true, bool isDestructive = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDestructive ? Colors.red : (isDark ? Colors.white : Colors.black87);
    final subTextColor = isDestructive ? Colors.red.withOpacity(0.7) : (isDark ? Colors.white70 : Colors.black54);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? Colors.red.withOpacity(0.2) 
                      : AppColors.lightorange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : AppColors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
  
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement account deletion logic
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
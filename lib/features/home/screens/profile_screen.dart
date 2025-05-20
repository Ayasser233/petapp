import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petapp/core/localization/app_localizations.dart'; // Add this import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final backgroundColor = isDark ? Colors.black : const Color(0xFFF5F5F5);
    final localizations = AppLocalizations.of(context); // Get localizations
    
    return BaseScreen(
      navBarIndex: 2, // This is the profile screen (index 2)
      appBar: AppBar(
        title: Text(localizations.myProfile), // Use localized string
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome section with user info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // User profile image
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.lightorange,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(height: 16),
                      // User name and phone
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${localizations.welcome} Aaron Smith',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+1 234 567 8910',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Profile options list - now with rounded containers
                _buildProfileOption(
                  context,
                  localizations.myAccount,
                  Icons.person_outline,
                  () {
                    // Navigate to account settings
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),

                const SizedBox(height: 12),
                
                // Add My Pets button right after the welcome section
                _buildProfileOption(
                  context,
                  localizations.myPets,
                  Icons.pets,
                  () {
                    Get.toNamed(AppRoutes.myPets);
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                _buildProfileOption(
                  context,
                  localizations.favorites,
                  Icons.favorite_border,
                  () {
                    // Navigate to favorites
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                _buildProfileOption(
                  context,
                  localizations.support,
                  Icons.headset_mic_outlined,
                  () {
                    // Navigate to support
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                _buildProfileOption(
                  context,
                  localizations.settings,
                  Icons.settings_outlined,
                  () {
                    // Navigate to settings
                    // Replace the Navigator.push code with:
                    Get.toNamed(AppRoutes.settings);
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                _buildProfileOption(
                  context,
                  localizations.rateApp,
                  Icons.star_border,
                  () {
                    // Open app rating
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                _buildProfileOption(
                  context,
                  localizations.logout,
                  Icons.logout,
                  () async {
                    // Log out
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    Get.offAllNamed(AppRoutes.login);
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                  textColor: Colors.red,
                ),
                
                // Social media links and footer
                const SizedBox(height: 24),
                
                // Social media section with rounded container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                          _buildSocialIcon(Icons.facebook, context),
                          const SizedBox(width: 24),
                          _buildSocialIcon(Icons.camera_alt_outlined, context),
                          const SizedBox(width: 24),
                          _buildSocialIcon(Icons.link, context),
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
                        'Terms and Conditions',
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
                        // Navigate to privacy policy
                      },
                      child: Text(
                        'Privacy Policy',
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
                  'PetApp v1.0.0',
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
  
  // Updated method to create rounded profile options
  Widget _buildProfileOption(
    BuildContext context, 
    String title, 
    IconData icon, 
    VoidCallback onTap,
    {bool isDark = false, Color cardColor = Colors.white, Color? textColor}
  ) {
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
              color: Colors.black.withOpacity(0.05),
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
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? defaultTextColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  
  // Updated social icon widget with improved styling
  Widget _buildSocialIcon(IconData icon, BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightorange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: AppColors.orange,
        size: 22,
      ),
    );
  }
  
  // Remove the _buildDivider method as we no longer need it
}
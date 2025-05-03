import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      navBarIndex: 2, // This is the profile screen (index 2)
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile image
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // User name
              Text(
                'Aaron Smith',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Email
              Text(
                'aaron.smith@example.com',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              
              // Profile options
              _buildProfileOption(
                context, 
                'My Pets', 
                Icons.pets, 
                () {
                  // Navigate to my pets screen
                }
              ),
              
              _buildProfileOption(
                context, 
                'Payment Methods', 
                Icons.payment, 
                () {
                  // Navigate to payment methods
                }
              ),
              
              _buildProfileOption(
                context, 
                'Settings', 
                Icons.settings, 
                () {
                  // Navigate to settings
                }
              ),
              
              _buildProfileOption(
                context, 
                'Help & Support', 
                Icons.help_outline, 
                () {
                  // Navigate to help and support
                }
              ),
              
              _buildProfileOption(
                context, 
                'Reset App', 
                Icons.refresh, 
                () async {
                  // Reset app state
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  await prefs.setBool('isOnboardingCompleted', false);
                  Get.offAllNamed(AppRoutes.onboarding);
                },
                isDestructive: true,
              ),
              
              _buildProfileOption(
                context, 
                'Log Out', 
                Icons.logout, 
                () async {
                  // Log out
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  Get.offAllNamed(AppRoutes.login);
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileOption(
    BuildContext context, 
    String title, 
    IconData icon, 
    VoidCallback onTap,
    {bool isDestructive = false}
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : AppColors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.orange,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
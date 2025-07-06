import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/profile/screens/account_details_screen.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                
                // Guest user banner
                if (isGuest)
                  _buildGuestProfileBanner(context, isDark),
                
                if (!isGuest)
                // Profile options list
                _buildProfileOption(
                  context,
                  localizations.myAccount,
                  Icons.person_outline,
                  () {
                    try {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountDetailsScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations.errorOpeningAccountDetails)),
                      );
                    }
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),

                if (!isGuest) const SizedBox(height: 12),
                
                _buildProfileOption(
                  context,
                  localizations.myPets,
                  Icons.pets,
                  () {
                    if (isGuest) {
                      _showLoginRequiredDialog(context);
                    } else {
                      Get.toNamed(AppRoutes.myPets);
                    }
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                // Aleefy Points option
                _buildProfileOption(
                  context,
                  localizations.aleefyPoints,
                  Icons.stars_rounded,
                  () {
                    if (isGuest) {
                      _showLoginRequiredDialog(context);
                    } else {
                      Get.toNamed(AppRoutes.pointsHistory);
                    }
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                ),
                
                const SizedBox(height: 12),
                
                // Vouchers option with Add New Voucher button
                _buildVouchersOption(
                  context,
                  isDark: isDark,
                  cardColor: cardColor,
                  isGuest: isGuest,
                ),
                
                const SizedBox(height: 12),
                
                /*InkWell(
                  onTap: () => Get.toNamed(AppRoutes.favorites),
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
                          child: const Icon(
                            Icons.favorite_border,
                            color: AppColors.orange,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            localizations.favorites,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
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
                
                const SizedBox(height: 12),*/
                
                _buildProfileOption(
                  context,
                  localizations.settings,
                  Icons.settings_outlined,
                  () {
                    Get.toNamed(AppRoutes.settings);
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
                
                // Social media section
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
                        // Navigate to privacy policy
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
  
  // Special vouchers option with Add New Voucher button
  Widget _buildVouchersOption(
    BuildContext context,
    {required bool isDark, required Color cardColor, bool isGuest = false}
  ) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            if (isGuest) {
              _showLoginRequiredDialog(context);
            } else {
              Get.toNamed(AppRoutes.vouchers);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: AppColors.orange,
                      size: 24.0,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      localizations.myVouchers,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: isDark ? Colors.white70 : Colors.black54,
                      size: 16.0,
                    ),
                  ],
                ),
                if (!isGuest) ...[
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Open redeem voucher dialog or navigate to redeem screen
                        Get.toNamed(AppRoutes.redeem);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(localizations.addVoucher),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Show Add Voucher Dialog
  void _showAddVoucherDialog(BuildContext context, bool isDark) {
    final TextEditingController codeController = TextEditingController();
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildAddVoucherDialogContent(context, codeController, isDark, localizations),
        );
      },
    );
  }
  
  // Build Add Voucher Dialog Content
  Widget _buildAddVoucherDialogContent(
    BuildContext context, 
    TextEditingController codeController, 
    bool isDark,
    AppLocalizations localizations
  ) {
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.confirmation_number_rounded,
                  color: AppColors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.addVoucher,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      localizations.enterYourVoucherCode,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Voucher code input
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: localizations.enterVoucherCode,
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
                prefixIcon: const Icon(
                  Icons.local_offer_outlined,
                  color: AppColors.orange,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    localizations.cancel,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _addVoucher(context, codeController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    localizations.addVoucher,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Help text
          Text(
            localizations.voucherHelpText,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[500] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Add voucher logic
  void _addVoucher(BuildContext context, String code) {
    final localizations = AppLocalizations.of(context);
    
    if (code.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseEnterVoucherCode),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    // Close dialog
    Navigator.of(context).pop();
    
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(localizations.validatingVoucherCode.replaceFirst('{code}', code.toUpperCase())),
          ],
        ),
        backgroundColor: AppColors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Simulate success/failure
      final isValid = code.toUpperCase().startsWith('ALEEFY') || 
                     code.toUpperCase().startsWith('SAVE') ||
                     code.toUpperCase().startsWith('DISCOUNT');
      
      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(localizations.voucherAddedSuccessfully.replaceFirst('{code}', code.toUpperCase())),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: localizations.view,
              textColor: Colors.white,
              onPressed: () {
                Get.toNamed('/vouchers');
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(localizations.invalidVoucherCode.replaceFirst('{code}', code.toUpperCase())),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: localizations.retry,
              textColor: Colors.white,
              onPressed: () {
                _showAddVoucherDialog(context, Theme.of(context).brightness == Brightness.dark);
              },
            ),
          ),
        );
      }
    });
  }
  
  // Profile option widget
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
  
  // Social icon widget
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
  
  // Show login required dialog
  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to be logged in to access this feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.toNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
  
  // Build guest profile banner
  Widget _buildGuestProfileBanner(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.person_outline,
            size: 48,
            color: AppColors.orange,
          ),
          const SizedBox(height: 12),
          const Text(
            'You\'re browsing as a guest',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create an account to access all features',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Login or Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
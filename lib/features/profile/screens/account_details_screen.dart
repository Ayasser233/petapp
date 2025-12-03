import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/features/profile/controllers/profile_controller.dart';
import 'package:petapp/core/utils/formatters.dart';
import 'package:petapp/core/utils/arabic_numeral_formatter.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Track if fields are being edited
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Initialize controllers with actual data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWithProfileData();
    });
  }

  void _initializeWithProfileData() {
    final profile = _profileController.userProfile;

    // Debug: Print profile status

    if (profile != null) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;

      // Strip country code from phone number for display
      String displayPhone = profile.phone;

      if (displayPhone.startsWith('+200')) {
        // Backend sometimes returns +200 instead of +20
        // Remove +200 and add back 0
        displayPhone = '0${displayPhone.substring(4)}'; // Remove +200 and add 0
      } else if (displayPhone.startsWith('+20')) {
        // Normal case: Remove +20 and add 0
        String phoneWithoutCode = displayPhone.substring(3); // Remove +20
        if (!phoneWithoutCode.startsWith('0')) {
          displayPhone = '0$phoneWithoutCode'; // Add 0 prefix
        } else {
          displayPhone = phoneWithoutCode; // Already has 0
        }
      } else if (displayPhone.startsWith('+')) {
        // For other country codes, try to remove them
        final match = RegExp(r'^\+\d{1,3}').firstMatch(displayPhone);
        if (match != null) {
          displayPhone = displayPhone.substring(match.group(0)!.length);
        }
      }

      _phoneController.text = displayPhone;
    } else {
      // Handle null profile case - Load from storage or show defaults
      _loadDefaultOrStoredData();
    }
  }

  void _loadDefaultOrStoredData() async {
    // Try to load user data from storage or AuthService
    try {
      // If you have an AuthService with user data
      final authService = Get.find<AuthService>();

      if (authService.authStatus == AuthStatus.authenticated) {
        // For authenticated users, try to refresh profile
        await _profileController.refreshProfile();
        final profile = _profileController.userProfile;

        if (profile != null) {
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _phoneController.text = profile.phone;
        } else {
          // Still null after refresh, use defaults
          _setDefaultValues();
        }
      } else if (authService.authStatus == AuthStatus.guest) {
        // Guest mode - show guest values
        _nameController.text = 'Guest User';
        _emailController.text = 'guest@example.com';
        _phoneController.text = '';
      } else {
        // Unauthenticated - show empty fields
        _nameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
      }
    } catch (e) {
      _setDefaultValues();
    }
  }

  void _setDefaultValues() {
    _nameController.text = 'User';
    _emailController.text = 'user@example.com';
    _phoneController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      if (_isEditing) {
        // Save data when switching from edit mode to view mode
        _saveUserData();
      } else {
        // Just enable editing mode
        _isEditing = true;
      }
    });
  }

  void _saveUserData() async {
    // Split the name into firstName and lastName
    final nameParts = _nameController.text.trim().split(' ');
    final firstName = nameParts.isNotEmpty && nameParts.first.isNotEmpty
        ? nameParts.first
        : null;
    final lastName =
        nameParts.length > 1 && nameParts.sublist(1).join(' ').isNotEmpty
            ? nameParts.sublist(1).join(' ')
            : null;


    // Convert Arabic numerals to English for phone number
    String phoneText =
        TFormatter.toEnglishNumerals(_phoneController.text.trim());
    final phoneValue = phoneText.isNotEmpty ? phoneText : null;

    try {
      final success = await _profileController.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        phone: phoneValue,
      );

      if (success) {
        setState(() {
          _isEditing = false;
        });

        // Show success message
        if (mounted) {
          final localizations = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        Text(localizations.accountDetailsUpdatedSuccessfully),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Refresh the UI with updated data
        _initializeWithProfileData();
      } else {
        // Keep editing mode if save failed
        // Error message will be shown by ProfileController
      }
    } catch (e) {
      // Keep editing mode if save failed
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      Text(localizations.failedToUpdateProfile(e.toString())),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    // Safely get localizations or use default value
    AppLocalizations? localizations;
    try {
      localizations = AppLocalizations.of(context);
    } catch (e) {
      localizations = null; // Fallback if localization is not available
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(localizations?.myAccount ?? 'My Account'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() => IconButton(
                icon: _profileController.isLoading ||
                        _profileController.isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.orange),
                        ),
                      )
                    : Icon(_isEditing ? Icons.save : Icons.edit),
                onPressed: _profileController.isLoading ||
                        _profileController.isUpdating
                    ? null
                    : _toggleEditing,
              )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.orange.withValues(alpha: 0.2),
                      child: const CircleAvatar(
                        radius: 56,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Details Section
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      localizations?.personalInformation ??
                          "Personal Information",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    _buildTextField(
                      label: localizations?.name ?? "Name",
                      controller: _nameController,
                      icon: Icons.person,
                      enabled: _isEditing,
                      isDark: isDark,
                      cardColor: cardColor,
                    ),

                    const SizedBox(height: 16),

                    // Email (disabled - cannot be edited)
                    _buildTextField(
                      label: localizations?.email ?? "Email",
                      controller: _emailController,
                      icon: Icons.email,
                      enabled: false, // Email field is always disabled
                      isDark: isDark,
                      cardColor: cardColor,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // Phone
                    _buildTextField(
                      label: localizations?.phone ?? "Phone",
                      controller: _phoneController,
                      icon: Icons.phone,
                      enabled: _isEditing,
                      isDark: isDark,
                      cardColor: cardColor,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Security Section
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      localizations?.security ?? "Security",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Change Password Option
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightorange.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.orange,
                        ),
                      ),
                      title: Text(
                        localizations?.changePassword ?? "Change Password",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        // Navigate to change password screen
                        Get.toNamed(AppRoutes.changePassword);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    required Color cardColor,
    bool enabled = true,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final disabledColor = isDark ? Colors.grey[700] : Colors.grey[200];
    final borderColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    // Use Arabic numeral formatter for numeric keyboards in Arabic locale
    List<TextInputFormatter>? formatters;
    if (keyboardType == TextInputType.phone ||
        keyboardType == TextInputType.number) {
      formatters = [
        ArabicAwareDigitsOnlyFormatter(), // Allow both English and Arabic digits
        ArabicNumeralInputFormatter(isArabic), // Convert to Arabic for display
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? (isDark ? Colors.grey[800] : Colors.grey[100])
                : disabledColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor!,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: formatters,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.orange,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

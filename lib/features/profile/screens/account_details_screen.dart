import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/features/profile/controllers/profile_controller.dart';

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
  late TextEditingController _addressController;
  late TextEditingController _dobController;

  // Track if fields are being edited
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _dobController = TextEditingController();

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
      _phoneController.text = profile.phone;
      _addressController.text = profile.address ?? '';
      _dobController.text = profile.dateOfBirth ?? '1990-01-01';
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
          _addressController.text = profile.address ?? '';
          _dobController.text = profile.dateOfBirth ?? '1990-01-01';
        } else {
          // Still null after refresh, use defaults
          _setDefaultValues();
        }
      } else if (authService.authStatus == AuthStatus.guest) {
        // Guest mode - show guest values
        _nameController.text = 'Guest User';
        _emailController.text = 'guest@example.com';
        _phoneController.text = '';
        _addressController.text = '';
        _dobController.text = '1990-01-01';
      } else {
        // Unauthenticated - show empty fields
        _nameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
        _addressController.text = '';
        _dobController.text = '';
      }
    } catch (e) {
      _setDefaultValues();
    }
  }

  void _setDefaultValues() {
    _nameController.text = 'User';
    _emailController.text = 'user@example.com';
    _phoneController.text = '';
    _addressController.text = '';
    _dobController.text = '1990-01-01';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
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

    print('🔍 ACCOUNT DETAILS SCREEN: Preparing save data');
    print('   Name Controller: "${_nameController.text}"');
    print('   Email Controller: "${_emailController.text}"');
    print('   Phone Controller: "${_phoneController.text}"');
    print('   Address Controller: "${_addressController.text}"');
    print('   DOB Controller: "${_dobController.text}"');
    print('   Parsed firstName: "$firstName"');
    print('   Parsed lastName: "$lastName"');

    try {
      final success = await _profileController.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        dateOfBirth: _dobController.text.trim().isNotEmpty
            ? _dobController.text.trim()
            : null,
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

                    // Email
                    _buildTextField(
                      label: localizations?.email ?? "Email",
                      controller: _emailController,
                      icon: Icons.email,
                      enabled: _isEditing,
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

                    const SizedBox(height: 16),

                    // Date of Birth
                    _buildTextField(
                      label: localizations?.dateOfBirth ?? "Date of Birth",
                      controller: _dobController,
                      icon: Icons.calendar_today,
                      enabled: _isEditing,
                      isDark: isDark,
                      cardColor: cardColor,
                      onTap: _isEditing ? () => _selectDate(context) : null,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Address
                    _buildTextField(
                      label: localizations?.address ?? "Address",
                      controller: _addressController,
                      icon: Icons.location_on,
                      enabled: _isEditing,
                      isDark: isDark,
                      cardColor: cardColor,
                      maxLines: 2,
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
                      "Security",
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
                        "Change Password",
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
                      },
                    ),

                    const Divider(),

                    // Two-Factor Authentication Option
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightorange.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.security,
                          color: AppColors.orange,
                        ),
                      ),
                      title: Text(
                        "Two-Factor Authentication",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // Enable/disable two-factor authentication
                        },
                        activeThumbColor: AppColors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Management Section
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
                      "Account Management",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deactivate Account Option
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.pause_circle_outline,
                          color: Colors.orange,
                        ),
                      ),
                      title: const Text(
                        "Deactivate Account",
                        style: TextStyle(
                          color: Colors.orange,
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
                        // Show deactivate account confirmation dialog
                      },
                    ),

                    const Divider(),

                    // Delete Account Option
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                      title: const Text(
                        "Delete Account",
                        style: TextStyle(
                          color: Colors.red,
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
                        // Show delete account confirmation dialog
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

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate = DateTime.parse("1990-01-01");
    } catch (e) {
      // Fallback to default date if parsing fails
      initialDate = DateTime(1990, 1, 1);
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child ?? Container(), // Safely handle null child
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }
}

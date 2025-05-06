import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_fonts.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 56.0, left: 24.0, right: 24.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              HeaderText(
                title: 'Create Your Account',
                subtitle:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              ),
              SizedBox(height: 32.0),
              // Add your sign-up form here
              SignUpForm(),

              SizedBox(height: 16.0),

              // Terms and Privacy Policy
              TermsAndPrivacyText(),

              SizedBox(height: 24.0),

              // Sign In Link
              LoginText(
                  text: 'Already have an account?', loginText: ' Sign In'),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>(); // Add a form key for validation
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to text fields
    _nameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check form validity
  void _checkFormValidity() {
    setState(() {
      _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          _passwordController.text.isNotEmpty &&
          _passwordController.text.length >= 6;
    });
  }

  // Validate form fields
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 4) {
      return 'Name is too short';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Simple phone validation - improve based on your requirements
    if (value.length < 10) {
      return 'Phone number is too short';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email validation
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Handle sign up
  Future<void> _handleSignUp() async {
    // First validate the form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace this with your actual API call
      // For example:
      // final response = await AuthService.signUp(
      //   name: _nameController.text,
      //   phone: _phoneController.text,
      //   email: _emailController.text,
      //   password: _passwordController.text
      // );

      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });

      // Navigate to verification screen
      Get.toNamed(AppRoutes.verifyEmail, arguments: _emailController.text);
    } catch (e) {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });

      // Show error message
      Get.snackbar(
        'Sign Up Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.user, color: AppColors.orange),
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                hintText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  // No border in normal state
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  // Keep consistent with no border
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: focusedFieldStyle(),
                focusedBorder: focusedFieldStyle(),
                filled: true,
                fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                // Smaller error text with less padding
                errorStyle: const TextStyle(height: 0.8),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateName,
              onChanged: (value) => _checkFormValidity(),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 16.0),

            // Phone Number Field (label removed)
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('+1',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDark ? Colors.white : Colors.black,
                                  )),
                          const Icon(Icons.arrow_drop_down,
                              size: 16, color: AppColors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
                hintText: 'Phone Number',
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: focusedFieldStyle(),
                focusedBorder: focusedFieldStyle(),
                filled: true,
                fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                errorStyle: const TextStyle(height: 0.8),
              ),
              validator: _validatePhone,
              onChanged: (value) => _checkFormValidity(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 16.0),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.sms, color: AppColors.orange),
                hintText: 'Email',
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: focusedFieldStyle(),
                focusedBorder: focusedFieldStyle(),
                filled: true,
                fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                errorStyle: const TextStyle(height: 0.8),
              ),
              validator: _validateEmail,
              onChanged: (value) => _checkFormValidity(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 16.0),
        
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.lock, color: AppColors.orange),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                hintText: 'Password',
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: focusedFieldStyle(),
                focusedBorder: focusedFieldStyle(),
                filled: true,
                fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                errorStyle: const TextStyle(height: 0.8),
              ),
              validator: _validatePassword,
              onChanged: (value) => _checkFormValidity(), // Simplified
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 32.0),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  disabledBackgroundColor: AppColors.orange.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelSmall,
          children: [
            TextSpan(
                text: 'By registering you agree to ',
                style: Theme.of(context).textTheme.labelLarge),
            TextSpan(
              text: 'Terms & Conditions',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.orange,
                    fontWeight: AppFonts.semiBold,
                  ),
            ),
            TextSpan(
                text: ' and ', style: Theme.of(context).textTheme.labelLarge),
            TextSpan(
              text: 'Privacy Policy',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.orange,
                    fontWeight: AppFonts.semiBold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginText extends StatelessWidget {
  final String text;
  final String loginText;
  const LoginText({
    required this.text,
    required this.loginText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
        GestureDetector(
          onTap: () {
            // Navigate to Login Screen
            Get.toNamed(AppRoutes.login);
          },
          child: Text(
            loginText,
            style: const TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

// Header Text
class HeaderText extends StatelessWidget {
  final String title, subtitle;
  const HeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10.0),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

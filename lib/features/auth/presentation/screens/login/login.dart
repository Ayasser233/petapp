import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/styles/input_styles.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/validation_utils.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 56.0, left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                HeaderText(
                  title: AppLocalizations.of(context).welcomeBack,
                  subtitle: AppLocalizations.of(context).loginToAccount,
                ),
                const SizedBox(height: 32.0),
                // Add your login form here
                const LoginForm(),
                // divider
                DividerForm(dividerText: AppLocalizations.of(context).orContinueWith),
                const SizedBox(height: 16.0),
                // footer
                // Google & Apple Sign In Buttons - Vertical
                const SocialBtns(),

                SignUpText(
                  text: AppLocalizations.of(context).dontHaveAccount, 
                  signUpText: ' ${AppLocalizations.of(context).signUp}'
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  final String text;
  final String signUpText;
  const SignUpText({
    required this.text,
    required this.signUpText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          GestureDetector(
            onTap: () {
              // Navigate to Sign Up Screen
              Get.toNamed(AppRoutes.signUp);
            },
            child: Text(
              signUpText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SocialBtns extends StatelessWidget {
  const SocialBtns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Handle Google Sign-in using the AuthCubit
              // context.read<AuthCubit>().signInWithGoogle();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/google.png',
                    width: 20, height: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).signInWithGoogle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Handle Apple Sign-in using the AuthCubit
              // context.read<AuthCubit>().signInWithApple();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apple,
                    color: THelperFunctions.isDarkMode(context)
                        ? Colors.white
                        : Colors.black),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).signInWithApple,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DividerForm extends StatelessWidget {
  const DividerForm({
    super.key,
    required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(
          color: dark ? AppColors.lightblack : Colors.grey,
          thickness: 0.5,
          indent: 60,
          endIndent: 5,
        )),
        Text(dividerText, style: Theme.of(context).textTheme.bodySmall),
        Flexible(
            child: Divider(
          color: dark ? AppColors.lightblack : Colors.grey,
          thickness: 0.5,
          indent: 5,
          endIndent: 60,
        )),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail(); // Load saved email when screen opens
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load remembered email from SharedPreferences
  Future<void> _loadRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('remembered_email');
      final isRemembered = prefs.getBool('remember_me') ?? false;
      
      if (savedEmail != null && isRemembered) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
      }
    } catch (e) {
      // Handle error by throwing exception
      throw Exception('Error loading remembered email: $e');
    }
  }

  // Save user email to SharedPreferences
  Future<void> _saveUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_rememberMe) {
        // Save the email and remember me preference
        await prefs.setString('remembered_email', _emailController.text.trim());
        await prefs.setBool('remember_me', true);
      } else {
        // Clear saved email if remember me is unchecked
        await prefs.remove('remembered_email');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      // Handle error by throwing exception
      throw Exception('Error saving user email: $e');
    }
  }

  // Handle sign in logic
  void _handleSignIn() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });
    
    // Save email preference before login attempt
    _saveUserEmail();
    
    context.read<AuthCubit>().login(
      _emailController.text.trim(), 
      _passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoginSuccess) {
          // Use TokenService directly
          final tokenService = Get.find<TokenService>();
          await tokenService.saveToken(state.user);
          print('Token saved successfully: ${state.user}');
          // Navigate to home
          Get.offAllNamed(AppRoutes.home);
        } else if (state is AuthFailure) {
          // Show red error message below password field
          setState(() {
            _errorMessage = AppLocalizations.of(context).wrongCredentials;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user, color: AppColors.orange),
                  suffixIcon: _emailController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _emailController.clear();
                            // Uncheck remember me if email is cleared
                            _rememberMe = false;
                          });
                        },
                      )
                    : null,
                  hintText: AppLocalizations.of(context).email,
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: focusedFieldStyle(),
                  focusedBorder: focusedFieldStyle(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  errorStyle: const TextStyle(height: 0.8),
                ),
                validator: ValidationUtils.validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16.0),
              
              // Password field
              TextFormField(
                controller: _passwordController,
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
                  hintText: AppLocalizations.of(context).password,
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.lightblack : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: focusedFieldStyle(),
                  focusedBorder: focusedFieldStyle(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  errorStyle: const TextStyle(height: 0.8),
                ),
                validator: ValidationUtils.validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: _obscurePassword,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              // Error message below password
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 8),
              
              // Remember me & forgot password row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // remember me checkbox
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.orange;
                                }
                                return Colors.transparent;
                              },
                            ),
                          ),
                        ),
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                            // Save/clear email immediately when checkbox changes
                            _saveUserEmail();
                          },
                          side: BorderSide(
                            color: isDark ? Colors.grey : Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).rememberMe,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  // forgot password button
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.orange,
                    ),
                    child: Text(
                      AppLocalizations.of(context).forgotPassword,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              
              // Sign In button with loading state from BlocBuilder
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final bool isLoading = state is AuthLoading;
                    
                    return ElevatedButton(
                      onPressed: isLoading ? null : _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: AppColors.orange.withOpacity(0.5),
                      ),
                      child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context).signIn,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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

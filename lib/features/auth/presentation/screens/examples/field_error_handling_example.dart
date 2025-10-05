// Example: How to handle the new server error response format in your auth screens

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petapp/core/utils/field_error_helper.dart';
import 'package:petapp/core/utils/validation_utils.dart';

class ExampleLoginForm extends StatefulWidget {
  const ExampleLoginForm({super.key});

  @override
  State<ExampleLoginForm> createState() => _ExampleLoginFormState();
}

class _ExampleLoginFormState extends State<ExampleLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _generalErrorMessage;
  Map<String, String>? _fieldErrors;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          // Handle successful login
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthFailure) {
          setState(() {
            _generalErrorMessage = state.message;
            _fieldErrors = state.fieldErrors;
          });
          
          // Optionally show field errors in a dialog
          if (state.fieldErrors != null && state.fieldErrors!.isNotEmpty) {
            FieldErrorHelper.showFieldErrorsDialog(
              context, 
              state.fieldErrors,
              title: 'Please fix the following errors:',
            );
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display general error message if no field errors
            if (_generalErrorMessage != null && (_fieldErrors == null || _fieldErrors!.isEmpty))
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _generalErrorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Display field errors summary (optional)
            FieldErrorHelper.buildFieldErrorsList(_fieldErrors),
            
            if (_fieldErrors != null && _fieldErrors!.isNotEmpty) 
              const SizedBox(height: 16),
            
            // Email Field with field-specific error handling
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email_outlined),
                // Show field-specific error styling
                errorBorder: FieldErrorHelper.hasFieldError(_fieldErrors, 'email')
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                      )
                    : null,
                focusedErrorBorder: FieldErrorHelper.hasFieldError(_fieldErrors, 'email')
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
                      )
                    : null,
              ),
              // Use the helper to integrate field errors with existing validators
              validator: FieldErrorHelper.createValidator(
                _fieldErrors,
                'email',
                existingValidator: ValidationUtils.validateEmail,
              ),
              onChanged: (value) {
                // Clear field error when user starts typing
                if (_fieldErrors != null && _fieldErrors!.containsKey('email')) {
                  setState(() {
                    _fieldErrors!.remove('email');
                    if (_fieldErrors!.isEmpty) {
                      _generalErrorMessage = null;
                    }
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Password Field with field-specific error handling
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outlined),
                // Show field-specific error styling
                errorBorder: FieldErrorHelper.hasFieldError(_fieldErrors, 'password')
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                      )
                    : null,
                focusedErrorBorder: FieldErrorHelper.hasFieldError(_fieldErrors, 'password')
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
                      )
                    : null,
              ),
              validator: FieldErrorHelper.createValidator(
                _fieldErrors,
                'password',
                existingValidator: ValidationUtils.validatePassword,
              ),
              onChanged: (value) {
                // Clear field error when user starts typing
                if (_fieldErrors != null && _fieldErrors!.containsKey('password')) {
                  setState(() {
                    _fieldErrors!.remove('password');
                    if (_fieldErrors!.isEmpty) {
                      _generalErrorMessage = null;
                    }
                  });
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Login Button
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    // Clear previous errors
    setState(() {
      _generalErrorMessage = null;
      _fieldErrors = null;
    });

    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      // Trigger login
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Alternative: Simple approach using just the field error display widget
class SimpleLoginFormWithFieldErrors extends StatefulWidget {
  const SimpleLoginFormWithFieldErrors({super.key});

  @override
  State<SimpleLoginFormWithFieldErrors> createState() => _SimpleLoginFormWithFieldErrorsState();
}

class _SimpleLoginFormWithFieldErrorsState extends State<SimpleLoginFormWithFieldErrors> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        Map<String, String>? fieldErrors;
        
        if (state is AuthFailure) {
          fieldErrors = state.fieldErrors;
        }
        
        return Column(
          children: [
            // Display field errors at the top
            FieldErrorHelper.buildFieldErrorsList(fieldErrors),
            
            if (fieldErrors != null && fieldErrors.isNotEmpty) 
              const SizedBox(height: 16),
            
            // Regular form fields
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outlined),
              ),
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: state is AuthLoading ? null : () {
                context.read<AuthCubit>().login(
                  _emailController.text.trim(),
                  _passwordController.text,
                );
              },
              child: state is AuthLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        );
      },
    );
  }
}
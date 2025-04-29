import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Email',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/enter-verification-code'); // Navigate to verification screen
                },
                child: const Text('Send OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
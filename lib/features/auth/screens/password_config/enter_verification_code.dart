import 'package:flutter/material.dart';

class EnterVerificationCodeScreen extends StatelessWidget {
  const EnterVerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        title: const Text('Enter Verification Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter Verification Code',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'You can resend the code in 56 seconds',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                // TODO: Implement resend code logic
              },
              child: const Text(
                'Resend Code',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-new-password'); // Navigate to reset password screen
                },
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
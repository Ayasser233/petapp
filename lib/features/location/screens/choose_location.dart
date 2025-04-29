import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';

class ChooseLocationScreen extends StatelessWidget {
  const ChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Choose your Location'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your Location',
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
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.setLocation);
              },
              child: const Text('Set Location'),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Current Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(child: Text('Map Placeholder')),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the next screen
                  Get.toNamed(AppRoutes.signUp); // Replace with the next screen route
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
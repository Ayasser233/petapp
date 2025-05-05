import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';

class ClinicDetailScreen extends StatelessWidget {
  final Map<String, dynamic> clinic;
  
  const ClinicDetailScreen({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          clinic['category'] ?? 'Hospital',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  clinic['image'] ?? 'assets/images/pet_hospital.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              
              // Clinic Name and Favorite Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      clinic['name'] ?? 'BluePearl Pet Hospital',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: AppColors.orange,
                    ),
                    onPressed: () {
                      // Handle favorite
                    },
                  ),
                ],
              ),
              
              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    clinic['location'] ?? 'Healdsburg, CA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '• ${clinic['distance'] ?? '11 minutes'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    '127',
                    'Reviews',
                  ),
                  _buildStatItem(
                    context,
                    '709',
                    'Patients',
                  ),
                  _buildStatItem(
                    context,
                    '15',
                    'Years exp.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                clinic['description'] ?? 'BluePearl Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Service Categories
              _buildServiceCategories(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // If the category is Hospital, navigate to hospital booking
              if (clinic['category'] == 'Hospital') {
                Get.toNamed(
                  AppRoutes.hospitalBooking,
                  arguments: {
                    'clinic': clinic,
                  },
                );
              } else {
                // For other categories, navigate to service selection
                Get.toNamed(
                  AppRoutes.serviceSelection,
                  arguments: {
                    'clinic': clinic,
                    'category': 'Grooming', // Default category
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Order Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCategories(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryButton(context, 'Grooming', true),
        _buildCategoryButton(context, 'Pet Hotels', false),
        _buildCategoryButton(context, 'Consultation', false),
      ],
    );
  }

  Widget _buildCategoryButton(BuildContext context, String title, bool isSelected) {
    return InkWell(
      onTap: () {
        // Handle category selection
        Get.toNamed(
          AppRoutes.serviceSelection,
          arguments: {
            'clinic': clinic,
            'category': title,
          },
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.orange : Colors.grey[300]!,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.orange : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
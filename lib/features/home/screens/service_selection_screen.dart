import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  
  const ServiceSelectionScreen({
    super.key,
    required this.arguments,
  });
  
  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  late String selectedCategory;
  final Map<String, bool> selectedServices = {};
  
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.arguments['category'] as String;
  }
  
  List<Map<String, dynamic>> getServicesByCategory() {
    switch (selectedCategory) {
      case 'Grooming':
        return [
          {
            'id': 'dental',
            'name': 'Dental Care',
            'image': 'assets/images/services/dental.png',
            'available': true,
          },
          {
            'id': 'fur',
            'name': 'Fur Trimming',
            'image': 'assets/images/services/fur.png',
            'available': true,
          },
          {
            'id': 'nail',
            'name': 'Nail Care',
            'image': 'assets/images/services/nail.png',
            'available': true,
          },
          {
            'id': 'ear',
            'name': 'Ear Cleaning',
            'image': 'assets/images/services/ear.png',
            'available': true,
          },
        ];
      case 'Pet Hotels':
        return [
          {
            'id': 'daycare',
            'name': 'Day Care',
            'image': 'assets/images/services/daycare.png',
            'available': true,
          },
          {
            'id': 'overnight',
            'name': 'Overnight Stay',
            'image': 'assets/images/services/overnight.png',
            'available': true,
          },
        ];
      case 'Consultation':
        return [
          {
            'id': 'vet',
            'name': 'Veterinary Consultation',
            'image': 'assets/images/services/vet.png',
            'available': true,
          },
          {
            'id': 'vaccine',
            'name': 'Vaccination',
            'image': 'assets/images/services/vaccine.png',
            'available': true,
          },
        ];
      default:
        return [];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final clinic = widget.arguments['clinic'] as Map<String, dynamic>;
    final services = getServicesByCategory();
    
    int selectedCount = selectedServices.values.where((isSelected) => isSelected).length;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tabs
          _buildCategoryTabs(context),
          
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Grooming services involve various grooming procedures to maintain the cleanliness and physical health of pets, especially dogs and cats.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          
          // Services title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Services Provided',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Services list
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final isSelected = selectedServices[service['id']] ?? false;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          service['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.pets),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'],
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Available',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: service['available'] ? () {
                          setState(() {
                            selectedServices[service['id']] = !(selectedServices[service['id']] ?? false);
                          });
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? AppColors.orange : Colors.white,
                          foregroundColor: isSelected ? Colors.white : AppColors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: AppColors.orange,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(isSelected ? 'Selected' : 'Add'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Package',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      selectedCategory,
                      style: const TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedCount} ${selectedCount == 1 ? 'Service' : 'Services'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: selectedCount > 0 ? () {
                  // Navigate to checkout or confirmation screen
                  Get.toNamed(
                    AppRoutes.checkout,
                    arguments: {
                      'clinic': clinic,
                      'selectedServices': selectedServices,
                      'category': selectedCategory,
                    },
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            _buildCategoryTab(context, 'Grooming'),
            const SizedBox(width: 16),
            _buildCategoryTab(context, 'Pet Hotels'),
            const SizedBox(width: 16),
            _buildCategoryTab(context, 'Consultation'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context, String category) {
    final isSelected = selectedCategory == category;
    
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Column(
        children: [
          Text(
            category,
            style: TextStyle(
              color: isSelected ? AppColors.orange : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 24,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
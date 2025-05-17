import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class ClinicDetailScreen extends StatelessWidget {
  final Map<String, dynamic> clinic;
  
  const ClinicDetailScreen({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active
    final isDark = THelperFunctions.isDarkMode(context);
    
    // Define theme colors
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final backgroundColor = isDark ? Colors.black : Colors.white;
    // final cardColor = isDark ? Colors.grey[850] : Colors.white;
    // final borderColor = isDark ? Colors.grey[700] : Colors.grey[300];

    // Get clinic services
    final List<String> services = [
      'General wellness exam',
      'Vaccinations',
      'Microchipping',
      'Nutritional counseling',
      'Laboratory services',
      'Surgery',
      'Dental care',
      'Emergency care',
    ];
    
    // Consultation price
    final consultationPrice = '\$75.00';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Clinic Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
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
                        color: textColor,
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
                    style: TextStyle(
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '• ${clinic['distance'] ?? '11 minutes'}',
                    style: TextStyle(
                      color: subTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Stats Row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      clinic['reviews']?.toString() ?? '127',
                      'Reviews',
                      textColor,
                      subTextColor,
                    ),
                    _buildStatDivider(isDark),
                    _buildStatItem(
                      context,
                      clinic['patients']?.toString() ?? '709',
                      'Patients',
                      textColor,
                      subTextColor,
                    ),
                    _buildStatDivider(isDark),
                    _buildStatItem(
                      context,
                      clinic['yearsExperience']?.toString() ?? '15',
                      'Years exp.',
                      textColor,
                      subTextColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                clinic['description'] ?? 'BluePearl Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
                style: TextStyle(
                  color: subTextColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              // Services Section
              Text(
                'Services',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              
              // Services Bullets
              ...services.map((service) => _buildServiceBullet(
                service, 
                textColor, 
                subTextColor, 
                isDark
              )),
              
              const SizedBox(height: 24),
              
              // Consultation Price Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consultation Fee',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Initial examination fee',
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      consultationPrice,
                      style: const TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Working Hours
              Text(
                'Working Hours',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildWorkingHours(textColor, subTextColor, isDark),
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
              // Navigate to consultation booking
              Get.toNamed(
                AppRoutes.hospitalBooking,
                arguments: {
                  'clinic': clinic,
                  'service': 'Consultation',
                  'price': consultationPrice,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              elevation: isDark ? 4 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Consultation',
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

  Widget _buildStatItem(BuildContext context, String value, String label, Color textColor, Color? subTextColor) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: subTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      height: 30,
      width: 1,
      color: isDark ? Colors.grey[800] : Colors.grey[300],
    );
  }

  Widget _buildServiceBullet(String service, Color textColor, Color? subTextColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours(Color textColor, Color? subTextColor, bool isDark) {
    final workHours = {
      'Monday - Friday': '9:00 AM - 7:00 PM',
      'Saturday': '10:00 AM - 5:00 PM',
      'Sunday': 'Closed',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: workHours.entries.map((entry) {
          final bool isClosed = entry.value == 'Closed';
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: entry.key == 'Sunday' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  entry.value,
                  style: TextStyle(
                    color: isClosed ? Colors.red[300] : subTextColor,
                    fontWeight: entry.key == 'Sunday' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/utils/helper_functions.dart'; // Added for isDarkMode check
import 'package:petapp/core/widgets/custom_app_bar.dart';
import 'package:petapp/features/clinic/models/clinic_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data for nearby clinics
  final List<ClinicModel> nearbyClinics = [
    ClinicModel(
      id: '1',
      name: 'Banfield Pet Hospital',
      category: 'Hospital',
      location: 'Los Angeles, CA',
      distance: '15 minutes',
      image: 'assets/images/pet_hospital.jpg',
      description:
          'Banfield Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
      rating: 4.8,
      reviews: 324,
      patients: 709,
      yearsExperience: 15,
    ),
    ClinicModel(
      id: '2',
      name: 'VCA Animal Hospital',
      category: 'Hospital',
      location: 'Brooklyn, NY',
      distance: '20 minutes',
      image: 'assets/images/pet_hospital2.jpg',
      description:
          'VCA Animal Hospital provides a full range of general medical and surgical services as well as specialized treatments for companion animals.',
      rating: 4.6,
      reviews: 287,
      patients: 583,
      yearsExperience: 12,
    ),
    ClinicModel(
      id: '3',
      name: 'BluePearl Pet Hospital',
      category: 'Hospital',
      location: 'Healdsburg, CA',
      distance: '11 minutes',
      image: 'assets/images/pet_hospital3.jpg',
      description:
          'BluePearl Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
      rating: 4.7,
      reviews: 127,
      patients: 709,
      yearsExperience: 15,
    ),
  ];

  void _navigateToClinicDetail(ClinicModel clinic) {
    Get.toNamed(
      AppRoutes.clinicDetail,
      arguments: clinic.toMap(),
    );
  }

  void _navigateToServicesByCategory(String category) {
    final clinicsInCategory = nearbyClinics
        .where((clinic) =>
            clinic.category.toLowerCase().contains(category.toLowerCase()))
        .toList();

    if (clinicsInCategory.isNotEmpty) {
      Get.toNamed(
        AppRoutes.clinicDetail,
        arguments: clinicsInCategory.first.toMap(),
      );
    } else {
      Get.toNamed(
        AppRoutes.clinicDetail,
        arguments: nearbyClinics.first.toMap(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return BaseScreen(
      navBarIndex: 0,
      appBar: CustomAppBar(
        showLogo: true, // Show the logo in the AppBar
        isDark: isDark,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Services Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildServiceItem(context, 'Clinic Visit',
                              Icons.medical_services_outlined, isDark,
                              onTap: () => Get.toNamed(AppRoutes.clinicExplorer)),
                          _buildServiceItem(
                              context, '3D Animal View', Icons.threed_rotation, isDark,
                              onTap: () => Get.toNamed(AppRoutes.pet3DModelSelector)),
                          _buildServiceItem(
                              context, 'Virtual Vet', Icons.videocam_outlined, isDark,
                              onTap: () =>
                                  _navigateToServicesByCategory('Consultation')),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Search bar - now acts as a button
                      GestureDetector(
                        onTap: () {
                          // Navigate to clinics search screen when tapped
                          Get.toNamed(AppRoutes.clinicExplorer, arguments: {'openSearch': true});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Search clinics, services...',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // Redeem & Save section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Redeem & Save',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle See All tap for rewards
                            },
                            child: const Text(
                              'View History',
                              style: TextStyle(color: AppColors.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rewards & Points card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.orange, Color(0xFFF5A623)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.orange.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Points section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.stars_rounded,
                                            color: AppColors.orange, size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '3,540',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Text(
                                            'Points Available',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to redeem points screen
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.orange,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text(
                                      'Redeem Now',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 1,
                              color: Colors.white.withOpacity(0.3),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            // Vouchers section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                      Icons.confirmation_number_outlined,
                                      color: AppColors.orange,
                                      size: 24),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '4',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const Text(
                                  'Vouchers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // Near You section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Near You',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle See All tap
                              Get.toNamed(AppRoutes.clinicExplorer);
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(color: AppColors.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Near You cards with improved design
                      SizedBox(
                        height: 220, // Slightly taller for better visuals
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: nearbyClinics.length,
                            itemBuilder: (context, index) {
                              final clinic = nearbyClinics[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == nearbyClinics.length - 1 ? 0 : 16.0,
                                ),
                                child: _buildNearbyCard(
                                  context,
                                  clinic: clinic,
                                  isDark: isDark,
                                  onTap: () => _navigateToClinicDetail(clinic),
                                ),
                              );
                            }),
                      ),
                      // Add some bottom padding
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, 
    String title, 
    IconData icon,
    bool isDark,
    {VoidCallback? onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark 
                ? AppColors.orange.withOpacity(0.15) 
                : AppColors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                if (!isDark) BoxShadow(
                  color: AppColors.orange.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.orange,
              size: 28, // Slightly larger
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(
    BuildContext context, {
    required ClinicModel clinic,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Slightly wider for better content display
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppColors.lightblack : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark 
                ? Colors.black.withOpacity(0.2) 
                : Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Clinic image with rounded corners
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    clinic.image,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Distance indicator
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          clinic.distance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic name
                  Text(
                    clinic.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          clinic.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        clinic.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${clinic.reviews})',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

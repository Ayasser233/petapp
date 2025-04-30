import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/home/models/clinic_model.dart';

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
      description: 'Banfield Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
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
      description: 'VCA Animal Hospital provides a full range of general medical and surgical services as well as specialized treatments for companion animals.',
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
      description: 'BluePearl Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
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
    // You could navigate to a category-specific screen
    // or just use the first clinic with this category
    final clinicsInCategory = nearbyClinics.where(
      (clinic) => clinic.category.toLowerCase().contains(category.toLowerCase())
    ).toList();
    
    if (clinicsInCategory.isNotEmpty) {
      Get.toNamed(
        AppRoutes.clinicDetail,
        arguments: clinicsInCategory.first.toMap(),
      );
    } else {
      // If no clinics match the category, use the first one
      Get.toNamed(
        AppRoutes.clinicDetail,
        arguments: nearbyClinics.first.toMap(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top greeting and notification section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hi, Aaron ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('👋'),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // Handle notification tap
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Welcome text
              Text(
                'Welcome to our\nhappy pet\'s family',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Categories section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle See All tap
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(color: AppColors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Categories row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryItem(
                    context, 
                    'Grooming', 
                    Icons.content_cut, 
                    onTap: () => _navigateToServicesByCategory('Grooming')
                  ),
                  _buildCategoryItem(
                    context, 
                    'Pet Hotel', 
                    Icons.home,
                    onTap: () => _navigateToServicesByCategory('Pet Hotel')
                  ),
                  _buildCategoryItem(
                    context, 
                    'Consultation', 
                    Icons.chat_bubble_outline,
                    onTap: () => _navigateToServicesByCategory('Consultation')
                  ),
                  _buildCategoryItem(
                    context, 
                    'Other', 
                    Icons.more_horiz,
                    onTap: () => _navigateToServicesByCategory('Hospital')
                  ),
                ],
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
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle See All tap
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(color: AppColors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Near You cards
              Expanded(
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
                        onTap: () => _navigateToClinicDetail(clinic),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, 
    String title, 
    IconData icon,
    {VoidCallback? onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.orange,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(
    BuildContext context, {
    required ClinicModel clinic,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    clinic.image,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image_not_supported)),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${clinic.rating} (${clinic.reviews})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 40,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Handle favorite tap
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          clinic.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '• ${clinic.distance}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
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
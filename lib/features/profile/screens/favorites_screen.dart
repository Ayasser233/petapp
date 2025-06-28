import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Sample favorited clinics data - in a real app, this would come from a controller or state manager
  final List<Map<String, dynamic>> _favoriteClinics = [
    {
      'name': 'Pet Care Center',
      'rating': 4.8,
      'reviews': 125,
      'image': 'assets/images/pet_hospital.jpg',
      'distance': '1.2 km',
      'address': '123 Pet Street, New York',
      'services': ['Vaccination', 'Surgery', 'Grooming'],
      'isOpen': true,
    },
    {
      'name': 'Animal Health Clinic',
      'rating': 4.5,
      'reviews': 98,
      'image': 'assets/images/pet_hospital2.jpg',
      'distance': '2.5 km',
      'address': '456 Animal Avenue, New York',
      'services': ['Checkup', 'Emergency', 'Pet Boarding'],
      'isOpen': true,
    },
    {
      'name': 'Furry Friends Veterinary',
      'rating': 4.7,
      'reviews': 112,
      'image': 'assets/images/pet_hospital3.jpg',
      'distance': '3.8 km',
      'address': '789 Furry Lane, New York',
      'services': ['Dental Care', 'X-Ray', 'Pet Care'],
      'isOpen': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(localizations.favorites),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _favoriteClinics.isEmpty
            ? _buildEmptyState(isDark, textColor, localizations)
            : _buildClinicsList(isDark, cardColor, textColor, subTextColor, localizations),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textColor, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.orange.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noFavoritesYet,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              localizations.noFavoritesMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Go back to previous screen
              // In a real app, you might want to navigate to a screen where users can find clinics
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              localizations.exploreMoreClinics,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicsList(bool isDark, Color cardColor, Color textColor, 
      Color subTextColor, AppLocalizations localizations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteClinics.length,
      itemBuilder: (context, index) {
        final clinic = _favoriteClinics[index];
        return _buildClinicCard(
          clinic: clinic,
          isDark: isDark,
          cardColor: cardColor,
          textColor: textColor,
          subTextColor: subTextColor,
          localizations: localizations,
          onTap: () {
            // Navigate to clinic detail
          },
          onRemove: () {
            // Logic to remove from favorites
            setState(() {
              _favoriteClinics.remove(clinic);
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${clinic['name']} ${localizations.removedFromFavorites}'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    setState(() {
                      _favoriteClinics.add(clinic);
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClinicCard({
    required Map<String, dynamic> clinic,
    required bool isDark,
    required Color cardColor, 
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required AppLocalizations localizations,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Image with favorite button and open/closed status
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      clinic['image'],
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppColors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: clinic['isOpen']
                            ? Colors.green
                            : Colors.red.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        clinic['isOpen'] ? localizations.openNow : localizations.closed,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Clinic details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            clinic['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              clinic['rating'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              ' (${clinic['reviews']})',
                              style: TextStyle(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Address and distance
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            clinic['address'],
                            style: TextStyle(
                              fontSize: 14,
                              color: subTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          clinic['distance'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Services
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List<Widget>.generate(
                        clinic['services'].length,
                        (index) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.lightorange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            clinic['services'][index],
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Book appointment button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          localizations.bookAppointment,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

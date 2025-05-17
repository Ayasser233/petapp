import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/clinic/models/clinic_model.dart';

class ClinicExplorerScreen extends StatefulWidget {
  const ClinicExplorerScreen({super.key});

  @override
  State<ClinicExplorerScreen> createState() => _ClinicExplorerScreenState();
}

class _ClinicExplorerScreenState extends State<ClinicExplorerScreen> {
  // Search and filter options
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'All Category';
  String _selectedRegion = 'All Regions';
  String _selectedService = 'All Services';
  String _sortOption = 'Default';
  
  // Sample data for regions
  final List<String> _regions = [
    'All Regions',
    'Los Angeles, CA',
    'Brooklyn, NY',
    'Healdsburg, CA',
    'San Francisco, CA',
    'Chicago, IL',
    'Miami, FL',
  ];
  
  // Sample data for services
  final List<String> _services = [
    'All Services',
    'Vaccination',
    'Surgery',
    'Grooming',
    'Dental Care',
    'Pet Hotel',
    'Emergency',
    'Consultation',
  ];
  
  // Category tabs
  final List<String> _categories = [
    'All Category',
    'Popular',
    'Recommended',
    'Latest',
  ];
  
  // Sample data for clinics (in a real app, this would come from an API)
  final List<ClinicModel> _allClinics = [
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
      services: ['Vaccination', 'Surgery', 'Dental Care', 'Emergency'],
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
      services: ['Vaccination', 'Surgery', 'Consultation', 'Emergency'],
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
      services: ['Vaccination', 'Surgery', 'Dental Care', 'Emergency'],
    ),
    ClinicModel(
      id: '4',
      name: 'Pet Paradise',
      category: 'Grooming',
      location: 'San Francisco, CA',
      distance: '25 minutes',
      image: 'assets/images/pet_hospital.jpg',
      description:
          'Pet Paradise offers premium grooming services for all types of pets. Our experienced groomers provide personalized care for your furry friends.',
      rating: 4.9,
      reviews: 156,
      patients: 450,
      yearsExperience: 8,
      services: ['Grooming', 'Pet Hotel'],
    ),
    ClinicModel(
      id: '5',
      name: 'Happy Paws Clinic',
      category: 'Clinic',
      location: 'Chicago, IL',
      distance: '30 minutes',
      image: 'assets/images/pet_hospital2.jpg',
      description:
          'Happy Paws Clinic provides comprehensive veterinary care for pets of all sizes. Our team of experienced veterinarians is dedicated to keeping your pets healthy and happy.',
      rating: 4.5,
      reviews: 210,
      patients: 620,
      yearsExperience: 10,
      services: ['Vaccination', 'Consultation', 'Dental Care'],
    ),
    ClinicModel(
      id: '6',
      name: 'Furry Friends Vet',
      category: 'Hospital',
      location: 'Miami, FL',
      distance: '18 minutes',
      image: 'assets/images/pet_hospital3.jpg',
      description:
          'Furry Friends Vet is a full-service animal hospital that offers both emergency treatment and routine medical care for pets in the Miami area.',
      rating: 4.7,
      reviews: 178,
      patients: 540,
      yearsExperience: 12,
      services: ['Vaccination', 'Surgery', 'Emergency', 'Consultation'],
    ),
  ];
  
  // Filtered clinics
  List<ClinicModel> _filteredClinics = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize filtered clinics with all clinics
    _filteredClinics = List.from(_allClinics);
    
    // Check if we should open search immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['openSearch'] == true) {
        // Focus the search field automatically
        _focusSearch();
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  // Apply filters
  void _applyFilters() {
    setState(() {
      _filteredClinics = _allClinics.where((clinic) {
        // Filter by search text
        if (_searchController.text.isNotEmpty &&
            !clinic.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
          return false;
        }
        
        // Filter by category
        if (_selectedCategory == 'Popular' && clinic.rating < 4.7) {
          return false;
        } else if (_selectedCategory == 'Recommended' && clinic.reviews < 200) {
          return false;
        } else if (_selectedCategory == 'Latest') {
          // In a real app, you would filter by date added
          // For now, just show the first 3 clinics
          return _allClinics.indexOf(clinic) < 3;
        }
        
        // Filter by region (if specific region is selected)
        if (_selectedRegion != 'All Regions' && clinic.location != _selectedRegion) {
          return false;
        }
        
        // Filter by service(s)
        if (_selectedService != 'All Services') {
          // Split the selected services string into a list
          final selectedServices = _selectedService.split(',');
          
          // Check if the clinic has at least one of the selected services
          bool hasSelectedService = false;
          for (final service in selectedServices) {
            if (clinic.services?.contains(service) ?? false) {
              hasSelectedService = true;
              break;
            }
          }
          
          if (!hasSelectedService) {
            return false;
          }
        }
        
        return true;
      }).toList();
      
      // Sort by distance if "Nearby" is selected
      if (_sortOption == 'Nearby') {
        _filteredClinics.sort((a, b) {
          // Extract minutes from distance string and convert to int
          final aMinutes = int.tryParse(a.distance.split(' ')[0]) ?? 0;
          final bMinutes = int.tryParse(b.distance.split(' ')[0]) ?? 0;
          return aMinutes.compareTo(bMinutes);
        });
      } 
      // Default sorting (by rating)
      else if (_sortOption == 'Default') {
        _filteredClinics.sort((a, b) => b.rating.compareTo(a.rating));
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if dark mode is active
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-based colors
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final searchBgColor = isDark ? AppColors.lightblack : Colors.grey[100];
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[200];
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: searchBgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(Icons.search, color: subTextColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Hospital',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: subTextColor),
                        ),
                        onChanged: (value) {
                          _applyFilters();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune, color: subTextColor),
                      onPressed: () {
                        _showFilterModal();
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Category tabs
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                          _applyFilters();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.orange : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? AppColors.orange : textColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Search results header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Result',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '${_filteredClinics.length} found',
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Clinic list
              Expanded(
                child: _filteredClinics.isEmpty
                    ? Center(
                        child: Text(
                          'No clinics found matching your filters',
                          style: TextStyle(color: subTextColor),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _filteredClinics.length,
                        itemBuilder: (context, index) {
                          final clinic = _filteredClinics[index];
                          return _buildClinicCard(clinic, isDark, cardColor, textColor, subTextColor, chipBgColor);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildClinicCard(
    ClinicModel clinic,
    bool isDark,
    Color? cardColor,
    Color textColor,
    Color? subTextColor,
    Color? chipBgColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      shadowColor: isDark ? Colors.black : Colors.grey.withOpacity(0.3),
      elevation: isDark ? 8 : 4,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.clinicDetail,
            arguments: clinic.toMap(),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    clinic.image,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
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
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      clinic.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic name
                  Text(
                    clinic.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location and distance
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        clinic.location,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${clinic.distance}',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Services
                  if (clinic.services != null && clinic.services!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: clinic.services!.map((service) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: chipBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            service,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Book now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.clinicDetail,
                          arguments: clinic.toMap(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: isDark ? 8 : 2,
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
  
  // Filter modal
  void _showFilterModal() {
    // Create a temporary list to hold selected services
    List<String> tempSelectedServices = _selectedService == 'All Services' 
        ? ['All Services'] 
        : _selectedService.split(',');
    
    // Create temporary variables for location selection
    String tempLocationOption = _sortOption == 'Nearby' 
        ? 'Nearby' 
        : (_selectedRegion != 'All Regions' ? 'Region' : 'All Clinics');
    String tempRegion = _selectedRegion;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Get theme colors
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : Colors.black;
        final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
        final borderColor = isDark ? Colors.grey[700] : Colors.grey[300];
        
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Location filter
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location options
                  Row(
                    children: [
                      _buildFilterChip(
                        'All Clinics',
                        tempLocationOption == 'All Clinics',
                        () {
                          setState(() {
                            tempLocationOption = 'All Clinics';
                            tempRegion = 'All Regions';
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Nearby', 
                        tempLocationOption == 'Nearby',
                        () {
                          setState(() {
                            tempLocationOption = 'Nearby';
                            tempRegion = 'All Regions';
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Region',
                        tempLocationOption == 'Region',
                        () {
                          setState(() {
                            tempLocationOption = 'Region';
                            // If no region was previously selected, select the first one
                            if (tempRegion == 'All Regions' && _regions.length > 1) {
                              tempRegion = _regions[1]; // First non-All region
                            }
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                    ],
                  ),
                  
                  // Region dropdown (only show when Region is selected)
                  if (tempLocationOption == 'Region')
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor!),
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? AppColors.lightblack : Colors.grey[50],
                        ),
                        child: DropdownButton<String>(
                          value: tempRegion,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                          style: TextStyle(color: textColor),
                          hint: Text('Select Region', style: TextStyle(color: subTextColor)),
                          items: _regions.where((region) => region != 'All Regions').map((String region) {
                            return DropdownMenuItem<String>(
                              value: region,
                              child: Text(region),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              tempRegion = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Services filter
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Service chips - multi-select
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMultiSelectChip(
                        'All',
                        tempSelectedServices.contains('All Services'),
                        () {
                          setState(() {
                            // If All is selected, clear other selections
                            tempSelectedServices = ['All Services'];
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                      ...['Grooming', 'Pet Hotel', 'Consultation', 'Vaccination', 'Surgery'].map((service) {
                        return _buildMultiSelectChip(
                          service,
                          tempSelectedServices.contains(service),
                          () {
                            setState(() {
                              // If a specific service is selected, remove 'All Services'
                              if (tempSelectedServices.contains('All Services')) {
                                tempSelectedServices.remove('All Services');
                              }
                              
                              // Toggle selection
                              if (tempSelectedServices.contains(service)) {
                                tempSelectedServices.remove(service);
                                // If no services selected, default to 'All Services'
                                if (tempSelectedServices.isEmpty) {
                                  tempSelectedServices = ['All Services'];
                                }
                              } else {
                                tempSelectedServices.add(service);
                              }
                            });
                          },
                          isDark,
                          borderColor,
                        );
                      }),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Buttons
                  Row(
                    children: [
                      // Reset button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              tempLocationOption = 'All Clinics';
                              tempRegion = 'All Regions';
                              tempSelectedServices = ['All Services'];
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: borderColor!),
                            foregroundColor: textColor,
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Apply button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Update the selected service string
                            if (tempSelectedServices.contains('All Services')) {
                              _selectedService = 'All Services';
                            } else {
                              _selectedService = tempSelectedServices.join(',');
                            }
                            
                            // Update location settings
                            if (tempLocationOption == 'All Clinics') {
                              _selectedRegion = 'All Regions';
                              _sortOption = 'Default';
                            } else if (tempLocationOption == 'Nearby') {
                              _selectedRegion = 'All Regions';
                              _sortOption = 'Nearby';
                            } else if (tempLocationOption == 'Region') {
                              _selectedRegion = tempRegion;
                              _sortOption = 'Default';
                            }
                            
                            Navigator.pop(context);
                            _applyFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: isDark ? 8 : 2,
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // Updated filter chips with dark mode support
  Widget _buildMultiSelectChip(
    String label, 
    bool isSelected, 
    VoidCallback onTap,
    bool isDark,
    Color? borderColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.orange : borderColor!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? AppColors.orange 
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label, 
    bool isSelected, 
    VoidCallback onTap,
    bool isDark,
    Color? borderColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.orange : borderColor!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? AppColors.orange 
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  void _focusSearch() {
    _searchFocusNode.requestFocus();
  }
}
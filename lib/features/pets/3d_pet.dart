import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';

class Pet3DRepresentationScreen extends StatefulWidget {
  const Pet3DRepresentationScreen({super.key});

  @override
  State<Pet3DRepresentationScreen> createState() => _Pet3DRepresentationScreenState();
}

class _Pet3DRepresentationScreenState extends State<Pet3DRepresentationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPetIndex = 0;
  double _rotationAngle = 0;
  double _zoomLevel = 1.0;
  
  // Sample pet data
  final List<Map<String, dynamic>> _pets = [
    {
      'name': 'Max',
      'breed': 'Golden Retriever',
      'age': '3 years',
      'image': 'assets/images/pets/dog1.png',
      'model3d': 'assets/models/dog_model.glb', // This would be your 3D model path
    },
    {
      'name': 'Luna',
      'breed': 'Persian Cat',
      'age': '2 years',
      'image': 'assets/images/pets/cat1.png',
      'model3d': 'assets/models/cat_model.glb',
    },
    {
      'name': 'Rocky',
      'breed': 'Bulldog',
      'age': '4 years',
      'image': 'assets/images/pets/dog2.png',
      'model3d': 'assets/models/bulldog_model.glb',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('3D Pet View'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Pet selector at the top
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPetIndex = index;
                      _rotationAngle = 0;
                      _zoomLevel = 1.0;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedPetIndex == index 
                            ? AppColors.orange 
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(_pets[index]['image']),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 3D View area
          Expanded(
            child: GestureDetector(
              // Remove the onPanUpdate handler - we'll include rotation in onScaleUpdate instead
              onScaleUpdate: (details) {
                setState(() {
                  // Handle rotation from the details.rotation if available, otherwise use horizontal movement
                  if (details.rotation != 0.0) {
                    _rotationAngle += details.rotation;
                  } else if (details.pointerCount == 1) {
                    // If only one finger is used, treat as rotation
                    _rotationAngle += details.focalPointDelta.dx * 0.01;
                  }
                  
                  // Handle scaling
                  _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 2.0);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // This would be replaced with your actual 3D model renderer
                    // For now, we'll use a placeholder
                    Transform.scale(
                      scale: _zoomLevel,
                      child: Transform.rotate(
                        angle: _rotationAngle,
                        child: Image.asset(
                          _pets[_selectedPetIndex]['image'],
                          height: 250,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.pets, size: 100, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    
                    // Instructions overlay
                    Positioned(
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.swipe, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Swipe to rotate • Pinch to zoom',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Pet details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet name and details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _pets[_selectedPetIndex]['name'],
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_pets[_selectedPetIndex]['breed']} • ${_pets[_selectedPetIndex]['age']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle share functionality
                        _shareModel();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tab bar for different sections
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.orange,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.orange,
                  tabs: const [
                    Tab(text: 'Health'),
                    Tab(text: 'Measurements'),
                    Tab(text: 'Activities'),
                  ],
                ),
                
                // Tab bar view
                SizedBox(
                  height: 120,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Health tab
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            _buildInfoRow('Weight', '12.5 kg', Icons.monitor_weight_outlined),
                            const SizedBox(height: 12),
                            _buildInfoRow('Last Checkup', '2 weeks ago', Icons.calendar_today),
                            const SizedBox(height: 12),
                            _buildInfoRow('Health Score', '92%', Icons.favorite_outline),
                          ],
                        ),
                      ),
                      
                      // Measurements tab
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            _buildInfoRow('Height', '56 cm', Icons.height),
                            const SizedBox(height: 12),
                            _buildInfoRow('Length', '82 cm', Icons.straighten),
                            const SizedBox(height: 12),
                            _buildInfoRow('Neck Size', '32 cm', Icons.pets),
                          ],
                        ),
                      ),
                      
                      // Activities tab
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            _buildInfoRow('Daily Steps', '3,420', Icons.directions_walk),
                            const SizedBox(height: 12),
                            _buildInfoRow('Play Time', '45 min/day', Icons.sports_basketball),
                            const SizedBox(height: 12),
                            _buildInfoRow('Sleep', '9.5 hrs/day', Icons.nightlight_round),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Bottom action buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to health tracking
                  Get.toNamed('/pet-health-tracking', arguments: _pets[_selectedPetIndex]);
                },
                icon: const Icon(Icons.monitor_heart_outlined),
                label: const Text('Health Tracking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Schedule veterinary appointment
                  Get.toNamed('/schedule-appointment', arguments: _pets[_selectedPetIndex]);
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Book Checkup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build info rows
  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.orange),
        const SizedBox(width: 8),
        Text(
          '$title:',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Show help dialog with instructions
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to Use 3D View'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(
                leading: Icon(Icons.swipe, color: AppColors.orange),
                title: Text('Swipe horizontally to rotate the model'),
              ),
              ListTile(
                leading: Icon(Icons.pinch, color: AppColors.orange),
                title: Text('Pinch to zoom in and out'),
              ),
              ListTile(
                leading: Icon(Icons.pets, color: AppColors.orange),
                title: Text('Tap on pet avatars to switch pets'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Got it!', style: TextStyle(color: AppColors.orange)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  // Share 3D model functionality
  void _shareModel() {
    Get.snackbar(
      'Share',
      'Sharing ${_pets[_selectedPetIndex]['name']}\'s 3D model',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.orange.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 2),
    );
  }
}
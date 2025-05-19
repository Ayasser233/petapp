import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/widgets/pet_3d_viewer.dart';

class Pet3DViewerScreen extends StatefulWidget {
  final String petType;
  final String petName;
  final String? modelPath;
  
  const Pet3DViewerScreen({
    super.key,
    required this.petType,
    required this.petName,
    this.modelPath,
  });

  @override
  State<Pet3DViewerScreen> createState() => _Pet3DViewerScreenState();
}

class _Pet3DViewerScreenState extends State<Pet3DViewerScreen> with SingleTickerProviderStateMixin {
  final List<String> _selectedSymptoms = [];
  bool _isSymptomsMenuOpen = false;
  late AnimationController _animController;
  late Animation<double> _menuAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Set up menu animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _menuAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  
  void _toggleSymptomsMenu() {
    setState(() {
      _isSymptomsMenuOpen = !_isSymptomsMenuOpen;
      if (_isSymptomsMenuOpen) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.petName,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Symptoms counter badge button
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.medical_services_outlined, color: textColor),
                onPressed: _toggleSymptomsMenu,
              ),
              if (_selectedSymptoms.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_selectedSymptoms.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: textColor),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content - No ScrollView, fixed positioning
            Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: Pet3DViewer(
                petType: widget.petType,
                modelPath: widget.modelPath,
                allowRotation: false,
                allowZoom: false,
                viewerHeight: MediaQuery.of(context).size.height * 0.8,
                backgroundColor: isDark ? Colors.black : Colors.grey[100],
                onSymptomSelected: _handleSymptomSelected,
              ),
            ),
            
            // Side control buttons
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(_isSymptomsMenuOpen ? Icons.menu_open : Icons.menu, color: Colors.blue),
                      onPressed: _toggleSymptomsMenu,
                    ),
                  ),
                ],
              ),
            ),
            
            // Symptoms side menu with animation
            AnimatedBuilder(
              animation: _menuAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  bottom: 0,
                  right: _isSymptomsMenuOpen ? 0 : -320 + (320 * _menuAnimation.value),
                  width: 320,
                  child: child!,
                );
              },
              child: Material(
                elevation: 16,
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Symptoms header
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Body Parts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              color: textColor,
                              onPressed: _toggleSymptomsMenu,
                            ),
                          ],
                        ),
                      ),
                      
                      const Divider(),
                      
                      // Body parts menu - similar to reference image
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildBodyPartItem('Head', Icons.face, isDark, textColor),
                            _buildBodyPartItem('Chest', Icons.favorite, isDark, textColor),
                            _buildBodyPartItem('Abdomen', Icons.restaurant, isDark, textColor),
                            _buildBodyPartItem('Legs', Icons.directions_walk, isDark, textColor),
                            _buildBodyPartItem('Tail', Icons.pets, isDark, textColor),
                          ],
                        ),
                      ),
                      
                      const Divider(),
                      
                      // Selected symptoms section
                      if (_selectedSymptoms.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: AppColors.orange),
                              const SizedBox(width: 8),
                              Text(
                                'Selected Symptoms (${_selectedSymptoms.length})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedSymptoms.clear();
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(color: AppColors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _selectedSymptoms.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.medical_services, size: 16, color: AppColors.orange),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedSymptoms[index],
                                          style: TextStyle(color: textColor),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _selectedSymptoms.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                      ],
                      
                      // Bottom action button
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _selectedSymptoms.isEmpty ? null : () {
                            _toggleSymptomsMenu();
                            Get.toNamed(
                              AppRoutes.clinicExplorer,
                              arguments: {'symptoms': _selectedSymptoms},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            disabledBackgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Find a Vet',
                                style: TextStyle(
                                  color: _selectedSymptoms.isEmpty 
                                      ? (isDark ? Colors.grey[500] : Colors.grey[600])
                                      : Colors.white,
                                  fontSize: 16,
                                ),
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
            
            // Bottom status bar showing symptoms count
            if (_selectedSymptoms.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: AppColors.orange,
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedSymptoms.length} symptom${_selectedSymptoms.length > 1 ? 's' : ''} selected',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.clinicExplorer,
                            arguments: {'symptoms': _selectedSymptoms},
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Find Vet',
                          style: TextStyle(color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSymptomSelected(String symptom) {
    setState(() {
      if (!_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.add(symptom);
      }
      
      // Open the symptoms menu when a new symptom is selected
      if (!_isSymptomsMenuOpen) {
        _toggleSymptomsMenu();
      }
    });
  }
  
  void _showHelpDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        title: Text(
          'How to Use',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              '1. Rotate:',
              'Touch and drag to rotate the model',
              isDark,
            ),
            _buildHelpItem(
              '2. Zoom:',
              'Pinch to zoom in and out',
              isDark,
            ),
            _buildHelpItem(
              '3. Select:',
              'Tap on a body part to select it',
              isDark,
            ),
            _buildHelpItem(
              '4. Symptoms:',
              'Choose symptoms for the selected body part',
              isDark,
            ),
            _buildHelpItem(
              '5. View Selected:',
              'Tap the symptoms icon in the top bar to see your selections',
              isDark,
            ),
            _buildHelpItem(
              '6. Find Vet:',
              'After selecting symptoms, tap "Find Vet"',
              isDark,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpItem(String title, String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build body part items
  Widget _buildBodyPartItem(String name, IconData icon, bool isDark, Color textColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.orange,
          size: 24,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.orange,
      ),
      onTap: () {
        // Show symptom selection dialog for this body part
        _showSymptomSelectionDialog(name.toLowerCase());
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  // Add this new method to show symptom selection dialog
  void _showSymptomSelectionDialog(String bodyPart) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    
    // Map of available symptoms by body part
    final Map<String, List<String>> bodyPartSymptoms = {
      'head': ['Ear infection', 'Eye irritation', 'Nasal discharge', 'Dental issues'],
      'chest': ['Coughing', 'Breathing difficulty', 'Chest pain', 'Heart issues'],
      'abdomen': ['Vomiting', 'Diarrhea', 'Bloating', 'Appetite loss'],
      'legs': ['Limping', 'Joint pain', 'Swelling', 'Mobility issues'],
      'tail': ['Irritation', 'Injury', 'Wagging issues', 'Pain when touched'],
    };
    
    final symptoms = bodyPartSymptoms[bodyPart] ?? [];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getBodyPartIcon(bodyPart),
                color: AppColors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${bodyPart[0].toUpperCase() + bodyPart.substring(1)} Symptoms',
              style: TextStyle(color: textColor),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              final symptom = symptoms[index];
              return ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.orange,
                ),
                title: Text(
                  symptom,
                  style: TextStyle(color: textColor),
                ),
                onTap: () {
                  _handleSymptomSelected('$bodyPart: $symptom');
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get body part icons
  IconData _getBodyPartIcon(String bodyPart) {
    switch (bodyPart) {
      case 'head':
        return Icons.face;
      case 'chest':
        return Icons.favorite;
      case 'abdomen':
        return Icons.restaurant;
      case 'legs':
        return Icons.directions_walk;
      case 'tail':
        return Icons.pets;
      default:
        return Icons.circle;
    }
  }
}
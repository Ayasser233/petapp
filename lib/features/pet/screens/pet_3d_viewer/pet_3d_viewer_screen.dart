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

class _Pet3DViewerScreenState extends State<Pet3DViewerScreen> {
  final List<String> _selectedSymptoms = [];
  
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
          IconButton(
            icon: Icon(Icons.help_outline, color: textColor),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 3D Viewer takes most space
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Pet3DViewer(
                  petType: widget.petType,
                  modelPath: widget.modelPath,
                  allowRotation: true,
                  allowZoom: true,
                  viewerHeight: MediaQuery.of(context).size.height * 0.65,
                  backgroundColor: isDark ? Colors.black : Colors.grey[100],
                  onSymptomSelected: _handleSymptomSelected,
                ),
              ),
              
              // Selected symptoms list
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected Symptoms',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        if (_selectedSymptoms.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedSymptoms.clear();
                              });
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: AppColors.orange),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _selectedSymptoms.isEmpty
                        ? Center(
                            child: Text(
                              'No symptoms selected.\nTap on the model to select symptoms.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark ? Colors.grey[500] : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Column(
                            children: List.generate(
                              _selectedSymptoms.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[850]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.pets,
                                        size: 16,
                                        color: AppColors.orange,
                                      ),
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
                                        onPressed: () {
                                          setState(() {
                                            _selectedSymptoms.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
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
      floatingActionButton: _selectedSymptoms.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                // Navigate to consultation booking with selected symptoms
                Get.toNamed(
                  AppRoutes.clinicExplorer,
                  arguments: {'symptoms': _selectedSymptoms},
                );
              },
              backgroundColor: AppColors.orange,
              label: const Text('Find Vet'),
              icon: const Icon(Icons.search),
            ),
    );
  }

  void _handleSymptomSelected(String symptom) {
    setState(() {
      if (!_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.add(symptom);
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
              '5. Find Vet:',
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
}
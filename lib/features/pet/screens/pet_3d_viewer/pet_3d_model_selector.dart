import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';

class Pet3DModelSelector extends StatelessWidget {
  const Pet3DModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Select Pet Type',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a pet model to view anatomy',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 32),
            
            // Pet type options
            Row(
              children: [
                // Dog option
                Expanded(
                  child: _buildModelCard(
                    context,
                    'Dog',
                    'assets/images/dog_model_thumbnail.png',
                    () => Get.toNamed(
                      AppRoutes.pet3DViewer,
                      arguments: {'petType': 'Dog', 'petName': 'Dog Model'},
                    ),
                    cardColor,
                    textColor,
                    isDark,
                  ),
                ),
                const SizedBox(width: 16),
                // Cat option
                Expanded(
                  child: _buildModelCard(
                    context,
                    'Cat',
                    'assets/images/cat_model_thumbnail.png',
                    () => Get.toNamed(
                      AppRoutes.pet3DViewer,
                      arguments: {'petType': 'Cat', 'petName': 'Cat Model'},
                    ),
                    cardColor,
                    textColor,
                    isDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use the 3D model to identify symptoms and explore pet anatomy. Tap on different body parts to learn more.',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
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
  
  Widget _buildModelCard(
    BuildContext context, 
    String petType, 
    String imagePath, 
    VoidCallback onTap,
    Color? cardColor,
    Color textColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: isDark ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                petType,
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'View $petType Anatomy',
                style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Open Model',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
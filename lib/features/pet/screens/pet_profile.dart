import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'dart:io';

class PetProfileScreen extends StatelessWidget {
  final PetModel pet;
  
  const PetProfileScreen({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if dark theme is active
    final isDark = THelperFunctions.isDarkMode(context);
    
    // Get pet age
    final age = _calculateAge(pet.birthdate);
    
    // Use app theme color instead of pet type-based colors
    const Color themeColor = AppColors.orange;
    
    // Define theme-dependent colors
    final Color backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.grey[800]!;
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final Color cardBorderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final Color notesBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    final Color emptyStateBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App bar with pet image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: themeColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  _showDeleteConfirmation(context, isDark);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Pet image
                  pet.image.startsWith('assets/')
                      ? Image.asset(
                          pet.image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(pet.image),
                          fit: BoxFit.cover,
                        ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Pet name at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                pet.type == 'Other' ? pet.specificType! : pet.type,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                age,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
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
          ),
          
          // Pet details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet info cards
                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        'Birthday',
                        _formatDate(pet.birthdate),
                        Icons.cake,
                        themeColor,
                        isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'Type',
                        pet.type == 'Other' ? pet.specificType! : pet.type,
                        pet.type == 'Dog' ? Icons.pets : Icons.emoji_nature,
                        themeColor,
                        isDark,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notes section
                  if (pet.notes != null && pet.notes!.isNotEmpty) ...[
                    _buildSectionHeader('Notes', Icons.note_alt, themeColor, textColor),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: notesBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Text(
                        pet.notes!,
                        style: TextStyle(
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Clinic visits section
                  _buildSectionHeader('Clinic Visits', Icons.medical_services, themeColor, textColor),
                  const SizedBox(height: 8),
                  
                  if (pet.clinicVisits == null || pet.clinicVisits!.isEmpty)
                    _buildEmptyVisitsCard(emptyStateBgColor, subTextColor, cardBorderColor)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pet.clinicVisits!.length,
                      itemBuilder: (context, index) {
                        return _buildVisitCard(
                          pet.clinicVisits![index], 
                          themeColor, 
                          cardColor, 
                          textColor, 
                          subTextColor,
                          isDark,
                        );
                      },
                    ),
                    
                  const SizedBox(height: 24),
                  
                  // Add visit button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement add visit functionality
                      },
                      icon: const Icon(Icons.add, color: themeColor),
                      label: const Text(
                        'Add Clinic Visit',
                        style: TextStyle(color: themeColor),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: themeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, IconData icon, Color color, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoCard(
    BuildContext context, 
    String title, 
    String value, 
    IconData icon, 
    Color color,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.grey[800];
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyVisitsCard(Color backgroundColor, Color textColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 48,
            color: textColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No clinic visits yet',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your pet\'s first clinic visit',
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVisitCard(
    ClinicVisit visit, 
    Color themeColor, 
    Color cardColor, 
    Color textColor, 
    Color subTextColor,
    bool isDark,
  ) {
    // Tag background color
    final tagBgColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isDark ? 2 : 1,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(isDark ? 0.2 : 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_hospital,
                        color: themeColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      visit.clinicName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDate(visit.date),
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildVisitDetail('Reason', visit.reason, textColor, subTextColor),
            if (visit.diagnosis != null)
              _buildVisitDetail('Diagnosis', visit.diagnosis!, textColor, subTextColor),
            if (visit.treatment != null)
              _buildVisitDetail('Treatment', visit.treatment!, textColor, subTextColor),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVisitDetail(String label, String value, Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateAge(String birthdate) {
    final birth = DateTime.parse(birthdate);
    final now = DateTime.now();
    
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    
    if (now.day < birth.day) {
      months--;
    }
    
    if (months < 0) {
      years--;
      months += 12;
    }
    
    if (years > 0) {
      return years == 1 ? '1 year old' : '$years years old';
    } else {
      return months == 1 ? '1 month old' : '$months months old';
    }
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark) {
    final dialogBgColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Pet',
          style: TextStyle(color: textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[isDark ? 300 : 400],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to delete ${pet.name}?',
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: subTextColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Get.back(result: 'delete'); // Return to previous screen with delete result
            },
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
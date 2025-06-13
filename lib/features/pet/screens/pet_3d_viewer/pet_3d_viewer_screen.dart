import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/widgets/pet_3d_viewer.dart';
import 'package:petapp/features/pet/data/pet_symptom_data.dart';

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

class _Pet3DViewerScreenState extends State<Pet3DViewerScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedSymptom;
  bool _isSymptomsMenuOpen = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();

    // Set up menu animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

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
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.petName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor,
              ),
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
              if (_selectedSymptom != null)
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
                      '1',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
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
      body: Column(
        children: [
          // Use the Pet3DViewer in a Column, not inside a Stack with Expanded
          Pet3DViewer(
            petType: widget.petType,
            modelPath: widget.modelPath,
            viewerHeight: MediaQuery.of(context).size.height * 0.4,
            backgroundColor: backgroundColor,
            onSymptomSelected: (symptom) {
              setState(() {
                _selectedSymptom = symptom;
              });
            },
          ),

          // Your existing body part selection UI can go in an Expanded widget here
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildBodyPartItem('Head', isDark, textColor),
                _buildBodyPartItem('Chest', isDark, textColor),
                _buildBodyPartItem('Abdomen', isDark, textColor),
                _buildBodyPartItem('Legs', isDark, textColor),
                _buildBodyPartItem('Tail', isDark, textColor),
                _buildBodyPartItem('Skin & Coat', isDark, textColor),
                _buildBodyPartItem('Pelvis', isDark, textColor),
                _buildBodyPartItem('Buttocks', isDark, textColor),
              ],
            ),
          ),

          // Selected symptom display if needed
          if (_selectedSymptom != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Text('Selected: $_selectedSymptom'),
            ),
        ],
      ),
    );
  }

  void _handleSymptomSelected(String symptom) {
    setState(() {
      // Simply replace the current symptom instead of adding to a list
      _selectedSymptom = symptom;

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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
            child: Text(
              'Got it',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.orange,
                  ),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build body part items
  // 1. First, update the _buildBodyPartItem method to remove the leading icon container
  Widget _buildBodyPartItem(String name, bool isDark, Color textColor) {
    return ListTile(
      // Remove the leading container with icon
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // Reusable method to show symptom selection dialog
  void _showSymptomSelectionDialog(String bodyPart) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;

    // Get symptom data from the separate file
    final bodyPartSymptoms = PetSymptomData.getSymptomMaps();

    // Convert body part name to mapping key
    String mappedBodyPart = bodyPart.toLowerCase();
    if (mappedBodyPart == 'skin & coat') {
      mappedBodyPart = 'skin';
    } else if (mappedBodyPart == 'pelvis') {
      // Keep as 'pelvis' - this is our new combined category
    } else if (mappedBodyPart == 'buttocks') {
      // Keep as 'buttocks' - this is our new category
    }

    // Create a user-friendly display title
    String displayTitle = bodyPart;
    if (bodyPart.toLowerCase() != mappedBodyPart) {
      displayTitle = bodyPart; // Keep original for display
    }

    // Check if data exists for this body part
    if (!bodyPartSymptoms.containsKey(mappedBodyPart)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            'No Data Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
          content: Text(
            'No symptom data found for $displayTitle.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.orange,
                    ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // For body parts with only one category, show symptoms directly
    final categories = bodyPartSymptoms[mappedBodyPart]?.keys.toList() ?? [];
    if (categories.length == 1) {
      _showSymptomListDialog(mappedBodyPart, categories.first);
      return;
    }

    // For body parts with multiple categories, show category selection dialog
    // 2. Update the symptom selection dialog to remove the icon from the title row
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '$displayTitle Symptom Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...categories.map(
                (category) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  // Remove the leading container with icon
                  title: Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.orange,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSymptomListDialog(mappedBodyPart, category);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.orange,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Show specific symptom list for a category
  void _showSymptomListDialog(String bodyPart, String category) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;

    // Get symptom data from the separate file
    final bodyPartSymptoms = PetSymptomData.getSymptomMaps();

    // Check if data exists for this body part and category
    if (!bodyPartSymptoms.containsKey(bodyPart) ||
        bodyPartSymptoms[bodyPart] == null ||
        !bodyPartSymptoms[bodyPart]!.containsKey(category) ||
        bodyPartSymptoms[bodyPart]![category] == null ||
        bodyPartSymptoms[bodyPart]![category]!.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            'No Data Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
          content: Text(
            'No symptoms found for ${bodyPart == "skin" ? "Skin & Coat" : bodyPart} - $category.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.orange,
                    ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Get symptoms for the selected category
    final symptoms = bodyPartSymptoms[bodyPart]![category]!;

    // Display appropriate title based on body part
    String dialogTitle;
    if (bodyPart == 'skin') {
      dialogTitle = 'Skin & Coat Symptoms';
    } else {
      dialogTitle = '$category Symptoms';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          dialogTitle,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              final symptom = symptoms[index];
              return ListTile(
                // Replace the icon with simple bullet point text
                title: Text(
                  symptom['name'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                subtitle: Text(
                  '${symptom['description'].toString().split('.')[0]}...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSymptomDetailDialog(bodyPart, category, symptom);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.orange,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Show detailed information for a specific symptom
  void _showSymptomDetailDialog(
      String bodyPart, String category, Map<String, dynamic> symptom) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          symptom['name'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Description
                Text(
                  symptom['description'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 16),

                // Possible causes
                Text(
                  'Possible Causes:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  (symptom['causes'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppColors.orange)),
                        Expanded(
                          child: Text(
                            symptom['causes'][index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: textColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // What to do
                Text(
                  'What to Do:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  (symptom['actions'] as List).length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppColors.orange)),
                        Expanded(
                          child: Text(
                            symptom['actions'][index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: textColor,
                                ),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _handleSymptomSelected(
                  '$bodyPart: $category - ${symptom['name']}');
              // Show choice dialog after selecting symptom - this fixes the warning
              _showSymptomChoiceDialog(bodyPart, category, symptom);
            },
            child: Text(
              _selectedSymptom != null ? 'Replace Symptom' : 'Select Symptom',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }


  // New method to show choice between vet and examples
  void _showSymptomChoiceDialog(
      String bodyPart, String category, Map<String, dynamic> symptom) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'What would you like to do?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You have selected: ${symptom['name']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Go to Vet Option
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _goToVetFinder(symptom);
                },
                icon: const Icon(Icons.local_hospital, size: 24),
                label: Text(
                  'Find a Vet Nearby',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            
            // See Examples Option
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showSymptomExamples(bodyPart, category, symptom);
                },
                icon: const Icon(Icons.photo_library, size: 24),
                label: Text(
                  'See Examples & Pictures',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to navigate to vet finder
  void _goToVetFinder(Map<String, dynamic> symptom) {
    // You can pass the selected symptom to the vet finder screen
    Get.toNamed(
      AppRoutes.clinicExplorer, // Replace with your actual vet finder route
      arguments: {
        'symptom': symptom['name'],
        'petType': widget.petType,
        'petName': widget.petName,
        'urgency': _determineUrgency(symptom),
      },
    );
  }

  // Method to show symptom examples with pictures
  void _showSymptomExamples(
      String bodyPart, String category, Map<String, dynamic> symptom) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;

    // Sample images - replace with actual symptom images
    final List<Map<String, String>> exampleImages = _getSymptomImages(symptom['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '${symptom['name']} - Examples',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visual Examples:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                
                // Grid of example images
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: exampleImages.length,
                  itemBuilder: (context, index) {
                    final image = exampleImages[index];
                    return GestureDetector(
                      onTap: () => _showFullScreenImage(image['url']!, image['caption']!),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                child: Image.asset(
                                  image['url']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                image['caption']!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: textColor,
                                    ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Additional information
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important Note:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'These are example images for reference only. Every pet is different, and symptoms may vary in severity and appearance. If you\'re unsure or concerned, please consult with a veterinarian.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: textColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _goToVetFinder(symptom);
            },
            child: Text(
              'Find Vet',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show full screen image
  void _showFullScreenImage(String imageUrl, String caption) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: Text(
                caption,
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get symptom images based on symptom name
  List<Map<String, String>> _getSymptomImages(String symptomName) {
    // This is where you would map symptom names to their corresponding images
    // For now, returning sample data
    
    final Map<String, List<Map<String, String>>> symptomImageMap = {
      'Eye Discharge': [
        {'url': 'assets/images/symptoms/eye_discharge_1.jpg', 'caption': 'Mild eye discharge'},
        {'url': 'assets/images/symptoms/eye_discharge_2.jpg', 'caption': 'Severe eye discharge'},
        {'url': 'assets/images/symptoms/eye_discharge_3.jpg', 'caption': 'Infected eye'},
        {'url': 'assets/images/symptoms/eye_discharge_4.jpg', 'caption': 'Normal vs abnormal'},
      ],
      'Limping': [
        {'url': 'assets/images/symptoms/limping_1.jpg', 'caption': 'Favoring one leg'},
        {'url': 'assets/images/symptoms/limping_2.jpg', 'caption': 'Visible swelling'},
        {'url': 'assets/images/symptoms/limping_3.jpg', 'caption': 'Abnormal gait'},
      ],
      'Skin Irritation': [
        {'url': 'assets/images/symptoms/skin_irritation_1.jpg', 'caption': 'Red, inflamed skin'},
        {'url': 'assets/images/symptoms/skin_irritation_2.jpg', 'caption': 'Scratching behavior'},
        {'url': 'assets/images/symptoms/skin_irritation_3.jpg', 'caption': 'Hair loss patches'},
      ],
      // Add more symptom mappings as needed
    };
    
    // Return specific images for the symptom, or default images if not found
    return symptomImageMap[symptomName] ?? [
      {'url': 'assets/images/symptoms/default_1.jpg', 'caption': 'Example 1'},
      {'url': 'assets/images/symptoms/default_2.jpg', 'caption': 'Example 2'},
    ];
  }

  // Helper method to determine urgency level
  String _determineUrgency(Map<String, dynamic> symptom) {
    final actions = (symptom['actions'] as List<String>);
    
    // Check for emergency keywords in actions
    for (String action in actions) {
      if (action.toLowerCase().contains('emergency') || 
          action.toLowerCase().contains('urgent') ||
          action.toLowerCase().contains('asap') ||
          action.toLowerCase().contains('immediately')) {
        return 'emergency';
      }
    }
    
    // Check for soon keywords
    for (String action in actions) {
      if (action.toLowerCase().contains('soon') || 
          action.toLowerCase().contains('needed')) {
        return 'soon';
      }
    }
    
    return 'routine';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/widgets/pet_3d_viewer.dart';
import 'package:petapp/features/pet/data/pet_symptom_data.dart';
import 'package:petapp/core/widgets/cached_asset_image.dart';

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
    final localizations = AppLocalizations.of(context);

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
                _buildBodyPartItem(localizations.head, isDark, textColor),
                _buildBodyPartItem(localizations.legs, isDark, textColor),
                _buildBodyPartItem(
                    localizations.skinAndCoat, isDark, textColor),
                _buildBodyPartItem(localizations.pelvis, isDark, textColor),
                _buildBodyPartItem(localizations.buttocks, isDark, textColor),
              ],
            ),
          ),

          // Selected symptom display if needed
          if (_selectedSymptom != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                border: Border(
                  top: BorderSide(color: AppColors.orange.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${localizations.selected}: $_selectedSymptom',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedSymptom = null),
                    child: Text(
                      localizations.clear,
                      style: const TextStyle(color: AppColors.orange),
                    ),
                  ),
                ],
              ),
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
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        title: Text(
          localizations.howToUse,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              '${localizations.step} 1: ${localizations.rotate}',
              localizations.rotateInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 2: ${localizations.zoom}',
              localizations.zoomInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 3: ${localizations.selectText}',
              localizations.selectInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 4: ${localizations.symptoms}',
              localizations.symptomsInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 5: ${localizations.viewSelected}',
              localizations.viewSelectedInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 6: ${localizations.findVet}',
              localizations.findVetInstructions,
              isDark,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.gotIt,
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

  Widget _buildBodyPartItem(String name, bool isDark, Color textColor) {
    return ListTile(
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

  void _showSymptomSelectionDialog(String bodyPart) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final localizations = AppLocalizations.of(context);

    // Get symptom data from the separate file
    final bodyPartSymptoms = PetSymptomData.getSymptomMaps();

    // Convert body part name to mapping key
    String mappedBodyPart = bodyPart.toLowerCase();
    if (mappedBodyPart == localizations.skinAndCoat.toLowerCase()) {
      mappedBodyPart = 'skin';
    } else if (mappedBodyPart == localizations.pelvis.toLowerCase()) {
      mappedBodyPart = 'pelvis';
    } else if (mappedBodyPart == localizations.buttocks.toLowerCase()) {
      mappedBodyPart = 'buttocks';
    } else if (mappedBodyPart == localizations.head.toLowerCase()) {
      mappedBodyPart = 'head';
    } else if (mappedBodyPart == localizations.legs.toLowerCase()) {
      mappedBodyPart = 'legs';
    }

    // Create a user-friendly display title
    String displayTitle = bodyPart;

    // Check if data exists for this body part
    if (!bodyPartSymptoms.containsKey(mappedBodyPart)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: bgColor,
          title: Text(
            localizations.noDataAvailable,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
          content: Text(
            '${localizations.noSymptomDataFound} $displayTitle.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.ok,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '$displayTitle ${localizations.symptomCategories}',
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
                  title: Text(
                    PetSymptomData.getLocalizedCategoryName(context, category),
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
              localizations.cancel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.orange,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSymptomListDialog(String bodyPart, String category) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final localizations = AppLocalizations.of(context);

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
            localizations.noDataAvailable,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                ),
          ),
          content: Text(
            '${localizations.noSymptomsFound} ${bodyPart == "skin" ? localizations.skinAndCoat : bodyPart} - ${PetSymptomData.getLocalizedCategoryName(context, category)}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.ok,
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
      dialogTitle = localizations.skinAndCoat;
    } else {
      dialogTitle =
          '${PetSymptomData.getLocalizedCategoryName(context, category)} ${localizations.symptoms}';
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
              final petSymptom = PetSymptom(
                name: symptom['name'],
                description: symptom['description'],
                causes: List<String>.from(symptom['causes']),
                actions: List<String>.from(symptom['actions']),
                imagePath: symptom['imagePath'],
                emergencyLevel: symptom['emergencyLevel'],
              );

              return ListTile(
                title: Text(
                  petSymptom.getLocalizedName(context),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                subtitle: Text(
                  '${petSymptom.getLocalizedDescription(context).split('.')[0]}...',
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
              localizations.cancel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.orange,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSymptomDetailDialog(
      String bodyPart, String category, Map<String, dynamic> symptom) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final localizations = AppLocalizations.of(context);

    final petSymptom = PetSymptom(
      name: symptom['name'],
      description: symptom['description'],
      causes: List<String>.from(symptom['causes']),
      actions: List<String>.from(symptom['actions']),
      imagePath: symptom['imagePath'],
      emergencyLevel: symptom['emergencyLevel'],
    );

    showDialog(
      context: context,
      useSafeArea: false, // Allow full screen
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            title: Text(
              petSymptom.getLocalizedName(context),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Optional: Add bookmark or share action
              IconButton(
                icon: Icon(Icons.bookmark_border, color: textColor),
                onPressed: () {
                  // Add bookmark functionality here
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Symptom category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${PetSymptomData.getLocalizedCategoryName(context, category)} • ${bodyPart.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.description,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        petSymptom.getLocalizedDescription(context),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: textColor,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Possible causes section
                Text(
                  localizations.possibleCauses,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: petSymptom
                        .getLocalizedCauses(context)
                        .asMap()
                        .entries
                        .map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 8, right: 12),
                              decoration: const BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: textColor,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // What to do section
                Text(
                  localizations.whatToDo,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: petSymptom
                        .getLocalizedActions(context)
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final action = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(top: 2, right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                action,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: textColor,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // Warning/Note section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.importantNote,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations.disclaimerText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: textColor,
                                    height: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom action buttons
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Select Symptom button
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
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _handleSymptomSelected(
                          '$bodyPart: $category - ${petSymptom.getLocalizedName(context)}');
                      _showSymptomChoiceDialog(bodyPart, category, symptom);
                    },
                    icon: const Icon(Icons.check_circle, size: 24),
                    label: Text(
                      _selectedSymptom != null
                          ? localizations.replaceSelectedSymptom
                          : localizations.selectThisSymptom,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Emergency button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _goToVetFinder(symptom);
                    },
                    icon: const Icon(Icons.local_hospital, size: 24),
                    label: Text(
                      localizations.findEmergencyVet,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSymptomChoiceDialog(
      String bodyPart, String category, Map<String, dynamic> symptom) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final localizations = AppLocalizations.of(context);

    final petSymptom = PetSymptom(
      name: symptom['name'],
      description: symptom['description'],
      causes: List<String>.from(symptom['causes']),
      actions: List<String>.from(symptom['actions']),
      imagePath: symptom['imagePath'],
      emergencyLevel: symptom['emergencyLevel'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          localizations.whatWouldYouLikeToDo,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${localizations.youHaveSelected}: ${petSymptom.getLocalizedName(context)}',
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
                  localizations.findVetNearby,
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
                  localizations.seeExamplesAndPictures,
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
              localizations.cancel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to navigate to vet finder (UPDATED - removed urgency)
  void _goToVetFinder(Map<String, dynamic> symptom) {
    Get.toNamed(
      AppRoutes.vetExplorer,
      arguments: {
        'symptom': symptom['name'],
        'petType': widget.petType,
        'petName': widget.petName,
      },
    );
  }

  void _showSymptomExamples(
      String bodyPart, String category, Map<String, dynamic> symptom) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final localizations = AppLocalizations.of(context);

    // Sample images - replace with actual symptom images
    final List<Map<String, String>> exampleImages =
        _getSymptomImages(symptom['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '${symptom['name']} - ${localizations.examples}',
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
                  '${localizations.visualExamples}:',
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
                      onTap: () => _showFullScreenImage(image['url']!),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isDark ? Colors.grey[600]! : Colors.grey[300]!,
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                child: CachedAssetImage(
                                  assetPath: image['url']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorWidget: Container(
                                    color: Colors.grey[300],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Image not found',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
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
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Additional information
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${localizations.importantNote}:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizations.exampleImagesDisclaimer,
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
              localizations.back,
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
              localizations.findVet,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                child: CachedAssetImage(
                  assetPath: imageUrl,
                  fit: BoxFit.contain,
                  errorWidget: Center(
                    child: Text(
                      AppLocalizations.of(context).imageNotAvailable,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getSymptomImages(String symptomName) {
    // Complete symptom image mapping based on your pet symptom data

    final Map<String, List<Map<String, String>>> symptomImageMap = {
      // Eye Problems (already included)
      'Eye Redness': [
        {'url': 'assets/images/symptoms/eye_redness_1.jpg'},
      ],
      'Eye Discharge (Goopy Stuff)': [
        {'url': 'assets/images/symptoms/watery_eyes_1.jpg'},
      ],
      'Cloudy Eye (Looks Foggy or Bluish)': [
        {'url': 'assets/images/symptoms/cloudy_eye_1.jpg'},
        {'url': 'assets/images/symptoms/cloudy_eye_2.jpg'},
      ],
      'Watery Eyes (Excessive Tearing)': [
        {'url': 'assets/images/symptoms/watery_eyes_1.jpg'}
      ],
      'Third Eyelid Showing': [
        {'url': 'assets/images/symptoms/third_eyelid_showing_1.jpg'},
        {'url': 'assets/images/symptoms/third_eyelid_showing_2.jpg'},
      ],
      'Squinting or Keeping Eye Closed': [
        {'url': 'assets/images/symptoms/squinting_eye_closed_1.jpg'},
        {'url': 'assets/images/symptoms/squinting_eye_closed_2.jpg'},
      ],
      'Swelling Around the Eye': [
        {'url': 'assets/images/symptoms/swelling_around_eye_1.jpg'},
      ],
      'Worms in the Eye': [
        {'url': 'assets/images/symptoms/worms_in_eye_1.jpg'},
        {'url': 'assets/images/symptoms/worms_in_eye_2.jpg'},
      ],

      // Ear Problems (already included)
      'Itchy Ears (Scratching or Head Shaking)': [],
      'Black Stuff in the Ear (Dark Wax or Debris)': [
        {'url': 'assets/images/symptoms/black_stuff_in_ear_1.jpg'},
        {'url': 'assets/images/symptoms/black_stuff_in_ear_2.jpg'},
      ],
      'Red or Swollen Ear': [
        {'url': 'assets/images/symptoms/red_swollen_ear_1.jpg'},
        {'url': 'assets/images/symptoms/red_swollen_ear_2.jpg'},
        {'url': 'assets/images/symptoms/red_swollen_ear_3.jpg'},
      ],
      'Bad Smell from the Ear': [],
      'Ear Discharge (Pus or Liquid Coming Out)': [],
      'Tilting Head to One Side': [
        {'url': 'assets/images/symptoms/tilting_head_1.jpg'},
        {'url': 'assets/images/symptoms/tilting_head_2.jpg'},
      ],
      'Loss of Hearing or Not Responding to Sounds': [],

      'Bad Breath (Smelly Mouth)': [],
      'Excessive Drooling': [],
      'Red, Swollen Gums': [
        {'url': 'assets/images/symptoms/red_swollen_gums_1.jpg'},
        {'url': 'assets/images/symptoms/red_swollen_gums_2.jpg'},
      ],
      'Loose or Missing Teeth': [],
      'Trouble Eating or Dropping Food': [],
      'Bleeding from the Mouth': [
        {'url': 'assets/images/symptoms/bleeding_from_mouth_1.jpg'},
        {'url': 'assets/images/symptoms/bleeding_from_mouth_2.jpg'},
      ],
      'White or Pale Gums': [],
      'Locked Jaw (Mouth Won\'t Open or Close)': [],
      'Oral Ulcers (Sores in the Mouth)': [
        {'url': 'assets/images/symptoms/oral_ulcers_1.jpg'},
      ],
      'Yellow or Brown Teeth (Tartar Buildup)': [
        {'url': 'assets/images/symptoms/yellow_brown_teeth_1.jpg'},
        {'url': 'assets/images/symptoms/yellow_brown_teeth_2.jpg'},
      ],

      'Tongue or Lip Swelling': [
        {'url': 'assets/images/symptoms/tongue_lip_swelling_1.jpg'},
      ],

      // Skin & Coat Problems
      'Hair Loss': [
        {'url': 'assets/images/symptoms/bald_patches_1.jpg'},
      ],
      'Bald Spots (Patches of Missing Hair)': [
        {'url': 'assets/images/symptoms/bald_patches_1.jpg'},
        {'url': 'assets/images/symptoms/bald_patches_2.jpg'},
      ],
      'Itchy Skin (Scratching a Lot)': [
        {'url': 'assets/images/symptoms/inflamed_skin_1.jpg'},
      ],
      'Constant Licking in One Spot': [
      ],
      'Red or Inflamed Skin': [
        {'url': 'assets/images/symptoms/inflamed_skin_1.jpg'},
      ],
      'Dandruff (Flaky Skin)': [
        {'url': 'assets/images/symptoms/dandruff_1.jpg'},
      ],
      'Scabs or Crusty Skin': [
        {'url': 'assets/images/symptoms/scabs_crusty_skin_1.jpg'},
      ],
      'Lumps or Bumps': [
        {'url': 'assets/images/symptoms/swelling_around_eye_1.jpg'},
        {'url': 'assets/images/symptoms/tongue_lip_swelling_1.jpg'},
      ],
      'Dull or Greasy Coat': [
        {'url': 'assets/images/symptoms/dull_greasy_coat_1.jpg'},
        {'url': 'assets/images/symptoms/dull_greasy_coat_2.jpg'},
        {'url': 'assets/images/symptoms/dull_greasy_coat_3.jpg'},
      ],
      'Skin Turning Darker (Hyperpigmentation)': [
        {'url': 'assets/images/symptoms/hyperpigmentation_1.jpg'},
      ],

      // Movement & Limbs Issues
      'Limping or Favoring One Leg': [
      ],
      'Stiffness or Trouble Standing Up': [
      ],
      'Sudden Weakness or Collapsing': [
      ],
      'Trembling or Shaking': [
      ],
      'Swollen or Painful Joints': [
      ],

      // Anus & Pooping Issues
      'Scooting or Dragging Butt on the Floor': [
        {'url': 'assets/images/symptoms/scooting_dragging_butt_1.jpg'},
        {'url': 'assets/images/symptoms/scooting_dragging_butt_2.jpg'},
      ],
      'Swelling or Redness Around the Anus': [
        {'url': 'assets/images/symptoms/swelling_redness_anus_1.jpg'},
      ],
      'Blood in Stool or Around the Anus': [
      ],
      'Straining to Poop or Constipation': [
      ],
      'Diarrhea': [
      ],

      // Male Genital Problems
      'Swollen Testicles': [
      ],
      'Discharge from the Penis': [
      ],
      'Red, Swollen, or Hanging Out Penis': [
      ],
      'Lumps or Bleeding from the Genitals': [
      ],

      // Female Genital Problems
      'Swollen Vulva': [
      ],
      'Discharge from the Vulva': [
      ],
      'Something Sticking Out from the Vulva': [
      ],

      // Urination Problems
      'Peeing Too Much (Frequent Urination)': [
      ],
      'Straining to Pee (Difficulty Urinating)': [
      ],
      'Bloody Urine (Red or Pink Pee)': [
      ],
      'Not Peeing at All (Emergency!)': [
      ],

    };

    // Return specific images for the symptom, or default images if not found
    return symptomImageMap[symptomName] ??
        [
          {'url': 'assets/images/symptoms/eye_redness_1.jpg'},
          {'url': 'assets/images/symptoms/inflamed_skin_1.jpg'},
        ];
  }
}

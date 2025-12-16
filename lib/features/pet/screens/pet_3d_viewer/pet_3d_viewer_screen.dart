import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
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
  late AnimationController _animController;
  bool _showGestureHint = true;
  bool _hasInteracted = false;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<MapEntry<String, PetSymptom>> _searchResults = [];

  @override
  void initState() {
    super.initState();

    // Set up menu animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Auto-hide gesture hint after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_hasInteracted) {
        setState(() {
          _showGestureHint = false;
        });
      }
    });

    // Listen to search changes
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isNotEmpty) {
        _performSearch();
      } else {
        _searchResults.clear();
      }
    });
  }

  void _performSearch() {
    _searchResults.clear();

    // Use the built-in search method
    final results = PetSymptomData.searchSymptoms(_searchQuery, context);

    // Map results with their categories and body parts
    for (var symptom in results) {
      // Find which category and body part this symptom belongs to
      String foundCategory = 'general';
      String foundBodyPart = 'general';

      PetSymptomData.symptoms.forEach((bodyPart, categories) {
        categories.forEach((category, symptomList) {
          if (symptomList.contains(symptom)) {
            foundCategory = category;
            foundBodyPart = bodyPart;
          }
        });
      });

      // Store as category|bodyPart for later use
      _searchResults.add(MapEntry('$foundCategory|$foundBodyPart', symptom));
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onUserInteracted() {
    if (!_hasInteracted) {
      setState(() {
        _hasInteracted = true;
        _showGestureHint = false;
      });
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: textColor),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 3D Viewer with gesture hint
          GestureDetector(
            onPanStart: (_) => _onUserInteracted(),
            onPanUpdate: (_) => _onUserInteracted(),
            child: Stack(
              children: [
                // The 3D Viewer
                Pet3DViewer(
                  petType: widget.petType,
                  modelPath: widget.modelPath,
                  viewerHeight: MediaQuery.of(context).size.height * 0.4,
                  backgroundColor: backgroundColor,
                  onSymptomSelected: (bodyPart) {
                    _onUserInteracted();
                    // When mesh is clicked, show symptom selection for that body part
                    _showSymptomSelectionDialog(bodyPart.toLowerCase());
                  },
                ),

                // Gesture hint overlay
                if (_showGestureHint)
                  Positioned.fill(
                    child: _buildGestureHint(isDark, localizations),
                  ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: localizations.searchSymptoms,
                hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search, color: textColor.withValues(alpha: 0.7)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: textColor.withValues(alpha: 0.7)),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          // Content - either search results or body part list
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults(isDark, textColor, localizations)
                : _buildBodyPartList(isDark, textColor, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDark, Color textColor, AppLocalizations localizations) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: textColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noSymptomsFound,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final entry = _searchResults[index];
        final parts = entry.key.split('|');
        final category = parts[0];
        final bodyPart = parts.length > 1 ? parts[1] : 'general';
        final symptom = entry.value;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isDark ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              symptom.getLocalizedName(context),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  PetSymptomData.getLocalizedCategoryName(context, category),
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  symptom.getLocalizedDescription(context),
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: textColor.withValues(alpha: 0.5),
              size: 16,
            ),
            onTap: () {
              _showSymptomDetailDialog(
                bodyPart,
                category,
                symptom.toMap(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBodyPartList(bool isDark, Color textColor, AppLocalizations localizations) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildBodyPartItem(localizations.head, isDark, textColor),
        _buildBodyPartItem(localizations.legs, isDark, textColor),
        _buildBodyPartItem(localizations.skinAndCoat, isDark, textColor),
        _buildBodyPartItem(localizations.pelvis, isDark, textColor),
        _buildBodyPartItem(localizations.buttocks, isDark, textColor),
        _buildBodyPartItem(localizations.neurologicalIssues, isDark, textColor),
        _buildBodyPartItem(localizations.behavioralIssues, isDark, textColor),
        _buildBodyPartItem(localizations.generalIssues, isDark, textColor),
        _buildBodyPartItem(localizations.breathingProblems, isDark, textColor),
      ],
    );
  }

  Widget _buildGestureHint(bool isDark, AppLocalizations localizations) {
    // ...existing code...
    return AnimatedOpacity(
      opacity: _showGestureHint ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated swipe icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: -30.0, end: 30.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(value, 0),
                      child: const Icon(
                        Icons.swipe_outlined,
                        size: 56,
                        color: AppColors.orange,
                      ),
                    );
                  },
                  onEnd: () {
                    if (mounted && _showGestureHint) {
                      setState(() {});
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  localizations.swipeToRotate,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Instructions list
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.swipe, color: AppColors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            localizations.tapBodyPartToExplore,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.zoom_in, color: AppColors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pinch to zoom or use buttons',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Got it button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onUserInteracted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      localizations.gotIt,
                      style: const TextStyle(
                        fontSize: 16,
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
              localizations.rotate90Instructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 2: ${localizations.selectText}',
              localizations.selectInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 3: ${localizations.symptoms}',
              localizations.symptomsInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 4: ${localizations.viewSelected}',
              localizations.viewSelectedInstructions,
              isDark,
            ),
            _buildHelpItem(
              '${localizations.step} 5: ${localizations.findVet}',
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
    } else if (mappedBodyPart ==
        localizations.neurologicalIssues.toLowerCase()) {
      mappedBodyPart = 'neurological';
    } else if (mappedBodyPart == localizations.behavioralIssues.toLowerCase()) {
      mappedBodyPart = 'behavioral';
    } else if (mappedBodyPart == localizations.generalIssues.toLowerCase()) {
      mappedBodyPart = 'general';
    } else if (mappedBodyPart ==
        localizations.breathingProblems.toLowerCase()) {
      mappedBodyPart = 'breathing';
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
                // See Examples & Pictures button
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
                      // Don't close symptom details - just show examples on top
                      _showSymptomExamples(bodyPart, category, symptom);
                    },
                    icon: const Icon(Icons.photo_library, size: 24),
                    label: Text(
                      localizations.seeExamplesAndPictures,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Find Emergency Vet button
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
    final List<String> exampleImages = _getSymptomImagePaths(symptom['name']);

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
                    final imagePath = exampleImages[index];
                    return GestureDetector(
                      onTap: () => _showFullScreenImage(imagePath),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isDark ? Colors.grey[600]! : Colors.grey[300]!,
                          ),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                            onError: (error, stackTrace) {},
                          ),
                        ),
                        child: imagePath.isEmpty
                            ? Container(
                                color: Colors.grey[300],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[600],
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
                              )
                            : null,
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

  void _showFullScreenImage(String imagePath) {
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
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).imageNotAvailable,
                        style: const TextStyle(color: Colors.white),
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

  List<String> _getSymptomImagePaths(String symptomName) {
    // Map of symptom names to their image paths
    final Map<String, List<String>> symptomImageMap = {
      'Eye Redness': ['assets/images/symptoms/eye_redness_1.jpg'],
      'Eye Discharge (Goopy Stuff)': [
        'assets/images/symptoms/watery_eyes_1.jpg'
      ],
      'Cloudy Eye (Looks Foggy or Bluish)': [
        'assets/images/symptoms/cloudy_eye_1.jpg',
        'assets/images/symptoms/cloudy_eye_2.jpg',
      ],
      'Watery Eyes (Excessive Tearing)': [
        'assets/images/symptoms/watery_eyes_1.jpg'
      ],
      'Third Eyelid Showing': [
        'assets/images/symptoms/third_eyelid_showing_1.jpg',
        'assets/images/symptoms/third_eyelid_showing_2.jpg',
      ],
      'Squinting or Keeping Eye Closed': [
        'assets/images/symptoms/squinting_eye_closed_1.jpg',
        'assets/images/symptoms/squinting_eye_closed_2.jpg',
      ],
      'Swelling Around the Eye': [
        'assets/images/symptoms/swelling_around_eye_1.jpg'
      ],
      'Worms in the Eye': [
        'assets/images/symptoms/worms_in_eye_1.jpg',
        'assets/images/symptoms/worms_in_eye_2.jpg',
      ],
      'Black Stuff in the Ear (Dark Wax or Debris)': [
        'assets/images/symptoms/black_stuff_in_ear_1.jpg',
        'assets/images/symptoms/black_stuff_in_ear_2.jpg',
      ],
      'Red or Swollen Ear': [
        'assets/images/symptoms/red_swollen_ear_1.jpg',
        'assets/images/symptoms/red_swollen_ear_2.jpg',
        'assets/images/symptoms/red_swollen_ear_3.jpg',
      ],
      'Tilting Head to One Side': [
        'assets/images/symptoms/tilting_head_1.jpg',
        'assets/images/symptoms/tilting_head_2.jpg',
      ],
      'Red, Swollen Gums': [
        'assets/images/symptoms/red_swollen_gums_1.jpg',
        'assets/images/symptoms/red_swollen_gums_2.jpg',
      ],
      'Bleeding from the Mouth': [
        'assets/images/symptoms/bleeding_from_mouth_1.jpg',
        'assets/images/symptoms/bleeding_from_mouth_2.jpg',
      ],
      'Oral Ulcers (Sores in the Mouth)': [
        'assets/images/symptoms/oral_ulcers_1.jpg'
      ],
      'Yellow or Brown Teeth (Tartar Buildup)': [
        'assets/images/symptoms/yellow_brown_teeth_1.jpg',
        'assets/images/symptoms/yellow_brown_teeth_2.jpg',
      ],
      'Tongue or Lip Swelling': [
        'assets/images/symptoms/tongue_lip_swelling_1.jpg'
      ],
      'Hair Loss': ['assets/images/symptoms/bald_patches_1.jpg'],
      'Bald Spots (Patches of Missing Hair)': [
        'assets/images/symptoms/bald_patches_1.jpg',
        'assets/images/symptoms/bald_patches_2.jpg',
      ],
      'Itchy Skin (Scratching a Lot)': [
        'assets/images/symptoms/inflamed_skin_1.jpg'
      ],
      'Red or Inflamed Skin': ['assets/images/symptoms/inflamed_skin_1.jpg'],
      'Dandruff (Flaky Skin)': ['assets/images/symptoms/dandruff_1.jpg'],
      'Scabs or Crusty Skin': [
        'assets/images/symptoms/scabs_crusty_skin_1.jpg'
      ],
      'Dull or Greasy Coat': [
        'assets/images/symptoms/dull_greasy_coat_1.jpg',
        'assets/images/symptoms/dull_greasy_coat_2.jpg',
        'assets/images/symptoms/dull_greasy_coat_3.jpg',
      ],
      'Skin Turning Darker (Hyperpigmentation)': [
        'assets/images/symptoms/hyperpigmentation_1.jpg'
      ],
      'Scooting or Dragging Butt on the Floor': [
        'assets/images/symptoms/scooting_dragging_butt_1.jpg',
        'assets/images/symptoms/scooting_dragging_butt_2.jpg',
      ],
      'Swelling or Redness Around the Anus': [
        'assets/images/symptoms/swelling_redness_anus_1.jpg'
      ],
    };

    // Return images for the symptom, or empty list if not found
    return symptomImageMap[symptomName] ?? [];
  }
}

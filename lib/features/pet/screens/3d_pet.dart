import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/pet/widgets/model_viewer.dart';

class Pet3DRepresentationScreen extends StatefulWidget {
  const Pet3DRepresentationScreen({super.key});

  @override
  State<Pet3DRepresentationScreen> createState() =>
      _Pet3DRepresentationScreenState();
}

class _Pet3DRepresentationScreenState extends State<Pet3DRepresentationScreen> {
  String _selectedPetType = 'dog'; // Default to dog
  String _selectedBodyPart = '';
  bool _showBackView = false; // Track if showing back view
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Body parts for common symptoms by region
  final Map<String, List<Map<String, dynamic>>> _bodyPartSymptoms = {
    'dog': [
      {
        'name': 'Head',
        'icon': Icons.face,
        'symptoms': [
          'Ear infections',
          'Eye discharge',
          'Dental issues',
          'Nasal discharge',
          'Sneezing'
        ],
        'frontPosition': {'top': 100.0, 'left': null, 'right': null},
        'backPosition': {'top': 100.0, 'left': null, 'right': null},
      },
      {
        'name': 'Neck & Chest',
        'icon': Icons.health_and_safety,
        'symptoms': [
          'Coughing',
          'Difficulty breathing',
          'Wheezing',
          'Collar irritation',
          'Swollen lymph nodes'
        ],
        'frontPosition': {'top': 160.0, 'left': null, 'right': null},
        'backPosition': {'top': 160.0, 'left': null, 'right': null},
      },
      {
        'name': 'Abdomen',
        'icon': Icons.restaurant,
        'symptoms': [
          'Vomiting',
          'Diarrhea',
          'Bloating',
          'Loss of appetite',
          'Excessive thirst'
        ],
        'frontPosition': {'top': 220.0, 'left': null, 'right': null},
        'backPosition': {'top': 220.0, 'left': null, 'right': null},
      },
      {
        'name': 'Limbs & Paws',
        'icon': Icons.pets,
        'symptoms': [
          'Limping',
          'Joint pain',
          'Swelling',
          'Nail issues',
          'Paw pad injuries'
        ],
        'frontPosition': {'top': 200.0, 'left': 80.0, 'right': null},
        'backPosition': {'top': 200.0, 'left': 80.0, 'right': null},
      },
      {
        'name': 'Skin & Coat',
        'icon': Icons.texture,
        'symptoms': ['Itching', 'Rashes', 'Hair loss', 'Dandruff', 'Parasites'],
        'frontPosition': {'top': 180.0, 'left': null, 'right': 80.0},
        'backPosition': {'top': 180.0, 'left': null, 'right': 80.0},
      },
      {
        'name': 'Tail & Back',
        'icon': Icons.line_style,
        'symptoms': [
          'Tail chasing',
          'Spine issues',
          'Anal gland problems',
          'Tail injuries',
          'Difficulty sitting'
        ],
        'frontPosition': {'top': 270.0, 'left': null, 'right': 60.0},
        'backPosition': {'top': 180.0, 'left': null, 'right': null},
      },
    ],
    'cat': [
      {
        'name': 'Head',
        'icon': Icons.face,
        'symptoms': [
          'Eye discharge',
          'Ear mites',
          'Dental disease',
          'Sneezing',
          'Facial swelling'
        ],
        'frontPosition': {'top': 80.0, 'left': null, 'right': null},
        'backPosition': {'top': 80.0, 'left': null, 'right': null},
      },
      {
        'name': 'Neck & Chest',
        'icon': Icons.health_and_safety,
        'symptoms': [
          'Difficulty breathing',
          'Wheezing',
          'Asthma',
          'Coughing',
          'Heart murmur'
        ],
        'frontPosition': {'top': 140.0, 'left': null, 'right': null},
        'backPosition': {'top': 140.0, 'left': null, 'right': null},
      },
      {
        'name': 'Abdomen',
        'icon': Icons.restaurant,
        'symptoms': [
          'Hairballs',
          'Vomiting',
          'Constipation',
          'Urinary issues',
          'Changes in appetite'
        ],
        'frontPosition': {'top': 200.0, 'left': null, 'right': null},
        'backPosition': {'top': 200.0, 'left': null, 'right': null},
      },
      {
        'name': 'Limbs & Paws',
        'icon': Icons.pets,
        'symptoms': [
          'Limping',
          'Excessive claw sharpening',
          'Joint stiffness',
          'Nail issues',
          'Paw swelling'
        ],
        'frontPosition': {'top': 180.0, 'left': 80.0, 'right': null},
        'backPosition': {'top': 180.0, 'left': 80.0, 'right': null},
      },
      {
        'name': 'Skin & Coat',
        'icon': Icons.texture,
        'symptoms': [
          'Excessive grooming',
          'Hair loss',
          'Skin lesions',
          'Matted fur',
          'Fleas/parasites'
        ],
        'frontPosition': {'top': 160.0, 'left': null, 'right': 80.0},
        'backPosition': {'top': 160.0, 'left': null, 'right': 80.0},
      },
      {
        'name': 'Tail & Back',
        'icon': Icons.line_style,
        'symptoms': [
          'Tail twitching',
          'Spine sensitivity',
          'Anal area issues',
          'Tail injuries',
          'Arched back'
        ],
        'frontPosition': {'top': 250.0, 'left': null, 'right': 60.0},
        'backPosition': {'top': 160.0, 'left': null, 'right': null},
      },
    ],
    'rabbit': [
      {
        'name': 'Head',
        'icon': Icons.face,
        'symptoms': [
          'Eye discharge',
          'Dental problems',
          'Sneezing',
          'Ear mites',
          'Head tilt'
        ],
        'frontPosition': {'top': 80.0, 'left': null, 'right': null},
        'backPosition': {'top': 80.0, 'left': null, 'right': null},
      },
      {
        'name': 'Body',
        'icon': Icons.pets,
        'symptoms': [
          'Fur loss',
          'Swellings',
          'Obesity',
          'Underweight',
          'Flystrike'
        ],
        'frontPosition': {'top': 180.0, 'left': null, 'right': null},
        'backPosition': {'top': 180.0, 'left': null, 'right': null},
      },
      {
        'name': 'Legs & Feet',
        'icon': Icons.directions_walk,
        'symptoms': [
          'Sore hocks',
          'Limping',
          'Overgrown nails',
          'Paralysis',
          'Joint stiffness'
        ],
        'frontPosition': {'top': 220.0, 'left': 60.0, 'right': null},
        'backPosition': {'top': 220.0, 'left': 60.0, 'right': null},
      },
      {
        'name': 'Digestive',
        'icon': Icons.restaurant,
        'symptoms': [
          'Diarrhea',
          'Decreased appetite',
          'Bloating',
          'Tooth grinding',
          'GI stasis'
        ],
        'frontPosition': {'top': 160.0, 'left': null, 'right': null},
        'backPosition': {'top': 160.0, 'left': null, 'right': null},
      },
    ],
  };

  // List of available pet types
  final List<String> _petTypes = ['dog', 'cat', 'rabbit'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'What are your pet\'s symptoms?',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings,
                color: isDark ? Colors.white : Colors.black87),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      // Side drawer for body parts menu
      endDrawer: Drawer(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              color: isDark ? Colors.black : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Body Areas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: isDark ? Colors.white : Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _bodyPartSymptoms[_selectedPetType]!.length,
                itemBuilder: (context, index) {
                  final bodyPart = _bodyPartSymptoms[_selectedPetType]![index];
                  final isSelected = _selectedBodyPart == bodyPart['name'];

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? Colors.grey[800]
                              : AppColors.orange.withOpacity(0.1))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.orange
                              : isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          bodyPart['icon'],
                          color: isSelected
                              ? Colors.white
                              : isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                          size: 24,
                        ),
                      ),
                      title: Text(
                        bodyPart['name'],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${bodyPart['symptoms'].length} common symptoms',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedBodyPart = bodyPart['name'];
                          Navigator.pop(context); // Close drawer
                        });
                        _showSymptomsDialog(context, bodyPart);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Main body with clean, minimalist design similar to reference image
      body: Column(
        children: [
          // Pet type selector only (no flip button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Pet type dropdown
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPetType,
                        icon: const Icon(Icons.pets, color: AppColors.orange),
                        isExpanded: true,
                        elevation: 1,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                        items: _petTypes.map((String type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.substring(0, 1).toUpperCase() +
                                  type.substring(1), // Capitalize first letter
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPetType = newValue;
                              _selectedBodyPart = '';
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),

                // You can add additional controls for the 3D model here if needed
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.view_in_ar, color: AppColors.orange),
                    tooltip: '3D View Controls',
                    onPressed: () {
                      _showHelpDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'e.g., Limping',
                  hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600]),
                  prefixIcon: Icon(Icons.search,
                      color: isDark ? Colors.grey[500] : Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),

          // 3D model with clean, minimalist style
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Model container - no need for gesture detector with 3D model viewer
                Container(
                  child: _buildPet3DModel(_selectedPetType, isDark),
                ),

                // View indicator
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[850]!.withOpacity(0.8)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showBackView
                              ? Icons.flip_to_back
                              : Icons.flip_to_front,
                          color: AppColors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _showBackView ? 'Back View' : 'Front View',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Rotate button (top right)
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: isDark ? Colors.grey[400] : AppColors.orange,
                    ),
                  ),
                ),

                // Menu button (right)
                Positioned(
                  top: 80,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.menu,
                        color: isDark ? Colors.grey[400] : AppColors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build minimalist 3D pet model
  Widget _buildPet3DModel(String petType, bool isDark) {
    return Pet3DModelViewer(
      petType: petType,
      isDark: isDark,
      onBodyPartSelected: (bodyPart) {
        final bodyPartData = _bodyPartSymptoms[petType]!.firstWhere(
          (part) => part['name'] == bodyPart,
          orElse: () => _bodyPartSymptoms[petType]!.first,
        );

        setState(() {
          _selectedBodyPart = bodyPart;
        });

        _showSymptomsDialog(context, bodyPartData);
      },
    );
  }

  // Show symptoms dialog when body part is selected
  void _showSymptomsDialog(
      BuildContext context, Map<String, dynamic> bodyPart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bodyPart['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: isDark ? Colors.white : Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Common symptoms in this area:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bodyPart['symptoms'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            bodyPart['symptoms'][index],
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.toNamed('/schedule-appointment');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Book Vet Appointment',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show help dialog with instructions
  void _showHelpDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            'How to Use',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.pets, color: AppColors.orange),
                title: Text(
                  'Select pet type from dropdown',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              ListTile(
                leading: Icon(Icons.flip_to_back, color: AppColors.orange),
                title: Text(
                  'Toggle front/back view',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              ListTile(
                leading: Icon(Icons.touch_app, color: AppColors.orange),
                title: Text(
                  'Tap on body areas to see symptoms',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              ListTile(
                leading: Icon(Icons.rotate_left, color: AppColors.orange),
                title: Text(
                  'Swipe to rotate the model',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              ListTile(
                leading: Icon(Icons.zoom_in, color: AppColors.orange),
                title: Text(
                  'Pinch to zoom in and out',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              ListTile(
                leading: Icon(Icons.menu, color: AppColors.orange),
                title: Text(
                  'Use menu for all body areas',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Got it',
                style: TextStyle(
                    color: AppColors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter to draw a simplified pet model if asset is not available
class PetModelPainter extends CustomPainter {
  final String petType;
  final bool isDark;
  final bool isBackView;

  PetModelPainter(
      {required this.petType, required this.isDark, this.isBackView = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.9) : Colors.grey[300]!
      ..style = PaintingStyle.fill;

    if (isBackView) {
      _paintBackView(canvas, size, paint);
    } else {
      _paintFrontView(canvas, size, paint);
    }
  }

  void _paintFrontView(Canvas canvas, Size size, Paint paint) {
    if (petType == 'dog') {
      // Simple dog silhouette
      // Body
      final bodyRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.3);
      canvas.drawOval(bodyRect, paint);

      // Head
      final headRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.15,
          size.width * 0.3, size.height * 0.2);
      canvas.drawOval(headRect, paint);

      // Legs
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.3, size.height * 0.6, size.width * 0.1,
              size.height * 0.25),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.6, size.height * 0.6, size.width * 0.1,
              size.height * 0.25),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.35, size.height * 0.5, size.width * 0.1,
              size.height * 0.3),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.55, size.height * 0.5, size.width * 0.1,
              size.height * 0.3),
          paint);

      // Tail
      final tailPath = Path()
        ..moveTo(size.width * 0.75, size.height * 0.4)
        ..lineTo(size.width * 0.85, size.height * 0.35)
        ..lineTo(size.width * 0.8, size.height * 0.45)
        ..close();
      canvas.drawPath(tailPath, paint);
    } else if (petType == 'cat') {
      // Simple cat silhouette
      // Body
      final bodyRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.25);
      canvas.drawOval(bodyRect, paint);

      // Head
      final headRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.15,
          size.width * 0.3, size.height * 0.2);
      canvas.drawOval(headRect, paint);

      // Ears
      final leftEarPath = Path()
        ..moveTo(size.width * 0.4, size.height * 0.15)
        ..lineTo(size.width * 0.35, size.height * 0.05)
        ..lineTo(size.width * 0.45, size.height * 0.1)
        ..close();
      canvas.drawPath(leftEarPath, paint);

      final rightEarPath = Path()
        ..moveTo(size.width * 0.6, size.height * 0.15)
        ..lineTo(size.width * 0.65, size.height * 0.05)
        ..lineTo(size.width * 0.55, size.height * 0.1)
        ..close();
      canvas.drawPath(rightEarPath, paint);

      // Legs
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.3, size.height * 0.55, size.width * 0.08,
              size.height * 0.2),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.62, size.height * 0.55,
              size.width * 0.08, size.height * 0.2),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.38, size.height * 0.5, size.width * 0.08,
              size.height * 0.25),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.54, size.height * 0.5, size.width * 0.08,
              size.height * 0.25),
          paint);

      // Tail
      final tailPath = Path()
        ..moveTo(size.width * 0.75, size.height * 0.4)
        ..quadraticBezierTo(size.width * 0.9, size.height * 0.3,
            size.width * 0.85, size.height * 0.5)
        ..lineTo(size.width * 0.75, size.height * 0.45)
        ..close();
      canvas.drawPath(tailPath, paint);
    } else {
      // Rabbit
      // Simple rabbit silhouette - front view
      // Body
      final bodyRect = Rect.fromLTWH(size.width * 0.3, size.height * 0.35,
          size.width * 0.4, size.height * 0.25);
      canvas.drawOval(bodyRect, paint);

      // Head
      final headRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.2,
          size.width * 0.3, size.height * 0.2);
      canvas.drawOval(headRect, paint);

      // Ears
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.4, size.height * 0.05, size.width * 0.06,
              size.height * 0.2),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.54, size.height * 0.05,
              size.width * 0.06, size.height * 0.2),
          paint);

      // Legs
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.35, size.height * 0.6, size.width * 0.1,
              size.height * 0.15),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.55, size.height * 0.6, size.width * 0.1,
              size.height * 0.15),
          paint);
    }
  }

  void _paintBackView(Canvas canvas, Size size, Paint paint) {
    if (petType == 'dog') {
      // Simple dog silhouette - back view
      // Body
      final bodyRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.3);
      canvas.drawOval(bodyRect, paint);

      // Head (slightly smaller from back)
      final headRect = Rect.fromLTWH(size.width * 0.37, size.height * 0.15,
          size.width * 0.26, size.height * 0.18);
      canvas.drawOval(headRect, paint);

      // Legs
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.3, size.height * 0.6, size.width * 0.1,
              size.height * 0.25),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.6, size.height * 0.6, size.width * 0.1,
              size.height * 0.25),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.35, size.height * 0.5, size.width * 0.1,
              size.height * 0.3),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.55, size.height * 0.5, size.width * 0.1,
              size.height * 0.3),
          paint);

      // Tail (more visible from back)
      final tailPath = Path()
        ..moveTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width * 0.5, size.height * 0.3)
        ..lineTo(size.width * 0.55, size.height * 0.5)
        ..close();
      canvas.drawPath(tailPath, paint);

      // Back line (spine)
      final spinePaint = Paint()
        ..color = isDark ? Colors.grey[600]! : Colors.grey[400]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.2),
        Offset(size.width * 0.5, size.height * 0.5),
        spinePaint,
      );
    } else if (petType == 'cat') {
      // Simple cat silhouette - back view
      // Body
      final bodyRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.25);
      canvas.drawOval(bodyRect, paint);

      // Head (slightly smaller from back)
      final headRect = Rect.fromLTWH(size.width * 0.37, size.height * 0.15,
          size.width * 0.26, size.height * 0.18);
      canvas.drawOval(headRect, paint);

      // Ears (more triangular from back)
      final leftEarPath = Path()
        ..moveTo(size.width * 0.42, size.height * 0.15)
        ..lineTo(size.width * 0.37, size.height * 0.05)
        ..lineTo(size.width * 0.47, size.height * 0.10)
        ..close();
      canvas.drawPath(leftEarPath, paint);

      final rightEarPath = Path()
        ..moveTo(size.width * 0.58, size.height * 0.15)
        ..lineTo(size.width * 0.63, size.height * 0.05)
        ..lineTo(size.width * 0.53, size.height * 0.10)
        ..close();
      canvas.drawPath(rightEarPath, paint);

      // Legs
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.3, size.height * 0.55, size.width * 0.08,
              size.height * 0.2),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.62, size.height * 0.55,
              size.width * 0.08, size.height * 0.2),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.38, size.height * 0.5, size.width * 0.08,
              size.height * 0.25),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.54, size.height * 0.5, size.width * 0.08,
              size.height * 0.25),
          paint);

      // Tail (more visible from back)
      final tailPath = Path()
        ..moveTo(size.width * 0.5, size.height * 0.45)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.2,
            size.width * 0.7, size.height * 0.3)
        ..lineTo(size.width * 0.65, size.height * 0.35)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.3,
            size.width * 0.5, size.height * 0.45)
        ..close();
      canvas.drawPath(tailPath, paint);

      // Back line (spine)
      final spinePaint = Paint()
        ..color = isDark ? Colors.grey[600]! : Colors.grey[400]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.2),
        Offset(size.width * 0.5, size.height * 0.45),
        spinePaint,
      );
    } else {
      // Rabbit
      // Simple rabbit silhouette - back view
      // Body
      final bodyRect = Rect.fromLTWH(size.width * 0.3, size.height * 0.35,
          size.width * 0.4, size.height * 0.25);
      canvas.drawOval(bodyRect, paint);

      // Head (smaller from back)
      final headRect = Rect.fromLTWH(size.width * 0.37, size.height * 0.2,
          size.width * 0.26, size.height * 0.18);
      canvas.drawOval(headRect, paint);

      // Ears (from back view)
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.42, size.height * 0.05,
              size.width * 0.06, size.height * 0.2),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.52, size.height * 0.05,
              size.width * 0.06, size.height * 0.2),
          paint);

      // Legs
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.35, size.height * 0.6, size.width * 0.1,
              size.height * 0.15),
          paint);
      canvas.drawRect(
          Rect.fromLTWH(size.width * 0.55, size.height * 0.6, size.width * 0.1,
              size.height * 0.15),
          paint);

      // Tail (small round)
      canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.55),
          size.width * 0.05, paint);

      // Back line
      final spinePaint = Paint()
        ..color = isDark ? Colors.grey[600]! : Colors.grey[400]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.23),
        Offset(size.width * 0.5, size.height * 0.5),
        spinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/constants/egypt_regions.dart';

class GovernorateCitySelectorScreen extends StatefulWidget {
  const GovernorateCitySelectorScreen({super.key});

  @override
  State<GovernorateCitySelectorScreen> createState() =>
      _GovernorateCitySelectorScreenState();
}

class _GovernorateCitySelectorScreenState
    extends State<GovernorateCitySelectorScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getFilteredGovernorates() {
    if (_searchQuery.isEmpty) {
      return EgyptRegions.getAllGovernorates();
    }

    final lowerQuery = _searchQuery.toLowerCase();
    return EgyptRegions.getAllGovernorates()
        .where((gov) => gov.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context).selectLocation,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchGovernorate,
                hintStyle: TextStyle(color: subTextColor),
                prefixIcon: Icon(Icons.search, color: subTextColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: subTextColor),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // Governorates list
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredGovernorates().length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final governorate = _getFilteredGovernorates()[index];
                return _buildGovernorateCard(
                  context,
                  governorate,
                  isDark,
                  textColor,
                  subTextColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernorateCard(
    BuildContext context,
    String governorate,
    bool isDark,
    Color textColor,
    Color? subTextColor,
  ) {
    final cities = EgyptRegions.getCitiesForGovernorate(governorate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey[900] : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to city selection screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CitySelectorScreen(
                governorate: governorate,
                cities: cities,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_city,
                  color: AppColors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Governorate name and city count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      governorate,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context).citiesCount(cities.length),
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: subTextColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CitySelectorScreen extends StatefulWidget {
  final String governorate;
  final List<String> cities;

  const CitySelectorScreen({
    super.key,
    required this.governorate,
    required this.cities,
  });

  @override
  State<CitySelectorScreen> createState() => _CitySelectorScreenState();
}

class _CitySelectorScreenState extends State<CitySelectorScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getFilteredCities() {
    if (_searchQuery.isEmpty) {
      return widget.cities;
    }

    final lowerQuery = _searchQuery.toLowerCase();
    return widget.cities
        .where((city) => city.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.governorate,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              AppLocalizations.of(context).selectCity,
              style: TextStyle(
                color: subTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Option to select entire governorate
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _buildGovernorateOption(
              context,
              isDark,
              textColor,
              subTextColor,
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: subTextColor?.withValues(alpha: 0.3),
              height: 1,
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchCity,
                hintStyle: TextStyle(color: subTextColor),
                prefixIcon: Icon(Icons.search, color: subTextColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: subTextColor),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // Cities list
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredCities().length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final city = _getFilteredCities()[index];
                return _buildCityTile(
                  context,
                  city,
                  isDark,
                  textColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernorateOption(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color? subTextColor,
  ) {
    return InkWell(
      onTap: () {
        // Return the governorate as the selection
        Get.back(); // Close city selector
        Get.back(result: widget.governorate); // Return to filter with result
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.orange,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_city,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .allCitiesIn(widget.governorate),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).selectEntireGovernorate,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.orange,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityTile(
    BuildContext context,
    String city,
    bool isDark,
    Color textColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? Colors.grey[900] : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          // Return the city as the selection
          Get.back(); // Close city selector
          Get.back(result: city); // Return to filter with result
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on,
            color: AppColors.orange,
            size: 20,
          ),
        ),
        title: Text(
          city,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
          size: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}


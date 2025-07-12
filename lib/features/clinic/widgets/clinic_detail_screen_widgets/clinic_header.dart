import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicHeader extends StatefulWidget {
  final Map<String, dynamic> clinic;

  const ClinicHeader({
    super.key,
    required this.clinic,
  });

  @override
  State<ClinicHeader> createState() => _ClinicHeaderState();
}

class _ClinicHeaderState extends State<ClinicHeader> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clinic Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            widget.clinic['image'] ?? 'assets/images/pet_hospital.jpg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.local_hospital,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Clinic Name and Favorite Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.clinic['name'] ?? 'BluePearl Pet Hospital',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.orange,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ],
        ),
        
        // Interactive Location
        GestureDetector(
          onTap: () => _openGoogleMaps(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.orange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.clinic['location'] ?? 'Healdsburg, CA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.orange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '• ${widget.clinic['distance'] ?? '11 ${AppLocalizations.of(context).minutes}'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: subTextColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new,
                  color: AppColors.orange,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Open Google Maps - Direct Implementation
  Future<void> _openGoogleMaps() async {
    // Get coordinates from clinic data
    final double? latitude = widget.clinic['latitude']?.toDouble();
    final double? longitude = widget.clinic['longitude']?.toDouble();
    final String clinicName = widget.clinic['name'] ?? 'Pet Clinic';
    final String encodedName = Uri.encodeComponent(clinicName);
    
    try {
      if (latitude != null && longitude != null) {
        debugPrint('Opening maps with coordinates: $latitude, $longitude');
        
        // Priority 1: Direct Google Maps app intent with label (Android)
        final googleUri = Uri.parse('geo:0,0?q=$latitude,$longitude($encodedName)');
        if (await canLaunchUrl(googleUri)) {
          final success = await launchUrl(googleUri);
          if (success) return;
        }
        
        // Priority 2: Direct navigation intent (Android)
        final navUri = Uri.parse('google.navigation:q=$latitude,$longitude&title=$encodedName');
        if (await canLaunchUrl(navUri)) {
          final success = await launchUrl(navUri);
          if (success) return;
        }
        
        // Priority 3: Google Maps URL (will open in app if available, otherwise browser)
        final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
        final success = await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        if (success) return;
        
        // Priority 4: Open in browser as last resort
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.inAppWebView
        );
      } else {
        // Fallback to location name if coordinates aren't available
        final String location = widget.clinic['location'] ?? '';
        if (location.isNotEmpty) {
          final encodedLocation = Uri.encodeComponent(location);
          final locationUri = Uri.parse('geo:0,0?q=$encodedLocation');
          
          if (await canLaunchUrl(locationUri)) {
            final success = await launchUrl(locationUri);
            if (success) return;
          }
          
          // Fallback to web URL
          final mapUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedLocation');
          await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Error opening maps: $e');
      // Open directly in browser without showing error dialog
      _openInBrowser(latitude, longitude);
    }
  }
  
  /// Open location directly in browser as a fallback
  Future<void> _openInBrowser(double? latitude, double? longitude) async {
    try {
      if (latitude != null && longitude != null) {
        final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.inAppWebView,
        );
      } else {
        final location = widget.clinic['location'] ?? '';
        if (location.isNotEmpty) {
          final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}';
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.inAppWebView,
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to open in browser: $e');
    }
  }


}
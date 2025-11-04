import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/widgets/vet_card.dart';
import '../../models/vet_model.dart';
import '../../screens/vet_explorer_screen.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Wrapper around reusable VetCard component for VetExplorer screen
/// This maintains backward compatibility while using the new reusable component
class VetExplorerCard extends StatelessWidget {
  final VetModel vet;
  final VetExplorerController controller;

  const VetExplorerCard({
    super.key,
    required this.vet,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final locationService = Get.find<LocationService>();

    // Calculate distance if location permission is granted
    String? distance;
    if (locationService.isPermissionGranted) {
      distance = vet.distance != 'Calculating...' ? vet.distance : null;
    }

    return VetCard(
      id: vet.id,
      name: vet.name,
      category: vet.category,
      location: vet.location,
      distance: distance,
      primaryImage: vet.primaryImage,
      rating: vet.rating,
      totalReviews: vet.reviews,
      yearsExperience: vet.yearsExperience,
      services: vet.services,
      isOpen: vet.isCurrentlyOpen,
      openingStatus: vet.openingStatus,
      phone: vet.phone,
      onTap: () => controller.navigateToVetDetail(vet),
      onCallPressed:
          vet.phone != null ? () => _makePhoneCall(context, vet.phone!) : null,
      showDistance: locationService.isPermissionGranted,
      showActionButtons: true,
      compact: false,
    );
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone dialer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

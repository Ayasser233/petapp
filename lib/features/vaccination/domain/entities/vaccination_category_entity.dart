import 'package:equatable/equatable.dart';

/// Vaccination Category Entity
///
/// Represents a vaccine category with its eligible vaccines
/// Backend endpoint: GET /vaccination/eligible-categories?petId=X
class VaccinationCategoryEntity extends Equatable {
  final String category; // e.g., "VIRUS", "WORMS", "INSECTS", "RABIES"
  final int minAgeDays; // Minimum age in days to receive this vaccine
  final List<String> vaccines; // List of vaccine types under this category
  final bool isEligible; // Whether the pet is eligible for this category

  const VaccinationCategoryEntity({
    required this.category,
    required this.minAgeDays,
    required this.vaccines,
    required this.isEligible,
  });

  /// Get display name for the category
  String get displayName {
    switch (category.toUpperCase()) {
      case 'VIRUS':
        return 'Viral Vaccines';
      case 'WORMS':
        return 'Deworming';
      case 'INSECTS':
        return 'Insect Protection';
      case 'RABIES':
        return 'Rabies';
      default:
        return category;
    }
  }

  /// Get description for the category
  String get description {
    switch (category.toUpperCase()) {
      case 'VIRUS':
        return 'Protection against viral diseases (Distemper, Parvovirus, etc.)';
      case 'WORMS':
        return 'Intestinal parasite prevention and treatment';
      case 'INSECTS':
        return 'Protection against fleas, ticks, and mosquitoes';
      case 'RABIES':
        return 'Rabies prevention - required by law';
      default:
        return 'Vaccination category';
    }
  }

  @override
  List<Object?> get props => [
        category,
        minAgeDays,
        vaccines,
        isEligible,
      ];
}

/// Vaccination Utility Functions
///
/// Centralized logic for vaccination business rules
/// including dose requirements and completion status
///
/// **Vaccination Completion Rules:**
/// - **Rabies**: Complete after 1 dose
/// - **Insects**: Complete after 1 dose
/// - **Worms**: Complete after 2 doses
/// - **Virus (DOG_/CAT_)**: Complete after 3 doses

class VaccinationUtils {
  /// Get the required number of doses for a vaccine type
  ///
  /// Returns:
  /// - 1 for Rabies and Insects vaccines
  /// - 2 for Worms vaccines
  /// - 3 for Virus vaccines (default)
  static int getRequiredDoses(String vaccineType) {
    final type = vaccineType.toUpperCase();

    // Single dose vaccines
    if (type.contains('RABIES') || type.contains('INSECTS')) {
      return 1;
    }

    // Two dose vaccines
    if (type.contains('WORMS')) {
      return 2;
    }

    // Virus vaccines (DOG_, CAT_) require 3 doses
    return 3;
  }

  /// Check if a vaccination series is complete
  ///
  /// A series is complete when:
  /// - Rabies: 1 dose administered
  /// - Insects: 1 dose administered
  /// - Worms: 2 doses administered
  /// - Virus: 3 doses administered
  static bool isSeriesComplete(String vaccineType, int completedDoses) {
    final requiredDoses = getRequiredDoses(vaccineType);
    return completedDoses >= requiredDoses;
  }

  /// Get the vaccine category name
  static String getVaccineCategory(String vaccineType) {
    final type = vaccineType.toUpperCase();

    if (type.contains('RABIES')) {
      return 'Rabies';
    } else if (type.contains('INSECTS')) {
      return 'Insects';
    } else if (type.contains('WORMS')) {
      return 'Worms';
    } else {
      return 'Virus';
    }
  }

  /// Check if vaccine type is a virus vaccine
  static bool isVirusVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.startsWith('DOG_') || type.startsWith('CAT_');
  }

  /// Check if vaccine type is a worms vaccine
  static bool isWormsVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('WORMS');
  }

  /// Check if vaccine type is an insects vaccine
  static bool isInsectsVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('INSECTS');
  }

  /// Check if vaccine type is a rabies vaccine
  static bool isRabiesVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('RABIES');
  }

  /// Check if vaccine type requires dose tracking
  ///
  /// Rabies and Insects are single-dose vaccines without dose numbers
  /// Virus and Worms track doses (1st, 2nd, 3rd)
  static bool requiresDoseTracking(String vaccineType) {
    return isVirusVaccine(vaccineType) || isWormsVaccine(vaccineType);
  }

  /// Get completion percentage for a vaccination series
  static double getCompletionPercentage(
      String vaccineType, int completedDoses) {
    final requiredDoses = getRequiredDoses(vaccineType);
    if (requiredDoses == 0) return 0.0;
    return (completedDoses / requiredDoses).clamp(0.0, 1.0);
  }

  /// Get remaining doses needed for completion
  static int getRemainingDoses(String vaccineType, int completedDoses) {
    final requiredDoses = getRequiredDoses(vaccineType);
    final remaining = requiredDoses - completedDoses;
    return remaining > 0 ? remaining : 0;
  }

  /// Get a user-friendly status message
  static String getStatusMessage(String vaccineType, int completedDoses) {
    if (isSeriesComplete(vaccineType, completedDoses)) {
      return 'Complete';
    }

    final remaining = getRemainingDoses(vaccineType, completedDoses);
    if (remaining == 1) {
      return '$remaining dose remaining';
    }
    return '$remaining doses remaining';
  }

  /// Validate if a dose number is valid for the vaccine type
  static bool isValidDoseNumber(String vaccineType, int doseNumber) {
    final requiredDoses = getRequiredDoses(vaccineType);
    return doseNumber > 0 && doseNumber <= requiredDoses;
  }
}

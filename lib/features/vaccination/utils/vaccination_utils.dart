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

  /// Check if worming vaccine 2nd dose is within valid window
  ///
  /// Worming Protocol:
  /// - 2 doses required
  /// - 2nd dose must be given AFTER 14 days from 1st dose
  /// - Valid window: Day 14 to Day 20
  /// - Before Day 14: Too early, not valid
  /// - After Day 20: Too late, series must restart
  ///
  /// Returns:
  /// - null: Not a worming vaccine or dose 1
  /// - true: Within valid window (Day 14-20)
  /// - false: Outside valid window (before Day 14 or after Day 20)
  static bool? isWormsSecondDoseValid(
    String vaccineType,
    int doseNumber,
    DateTime? firstDoseDate,
  ) {
    // Only applies to worming vaccines
    if (!isWormsVaccine(vaccineType)) {
      return null;
    }

    // Only check 2nd dose
    if (doseNumber != 2) {
      return null;
    }

    // Need first dose date to validate
    if (firstDoseDate == null) {
      return null;
    }

    final now = DateTime.now();
    final daysSinceFirstDose = now.difference(firstDoseDate).inDays;

    // Valid window: Day 14 to Day 20 (inclusive)
    // Before Day 14: Too early
    // After Day 20: Too late
    return daysSinceFirstDose >= 14 && daysSinceFirstDose <= 20;
  }

  /// Check if it's too early for worming 2nd dose (before Day 14)
  static bool isWormsDoseTooEarly(
    String vaccineType,
    int doseNumber,
    DateTime? firstDoseDate,
  ) {
    if (!isWormsVaccine(vaccineType) || doseNumber != 2 || firstDoseDate == null) {
      return false;
    }

    final now = DateTime.now();
    final daysSinceFirstDose = now.difference(firstDoseDate).inDays;
    return daysSinceFirstDose < 14;
  }

  /// Get days remaining until worming 2nd dose window opens (Day 14)
  ///
  /// Returns:
  /// - Number of days until Day 14 if before Day 14
  /// - 0 if at or past Day 14
  /// - null if not applicable
  static int? getDaysUntilWormsWindowOpens(
    String vaccineType,
    int doseNumber,
    DateTime? firstDoseDate,
  ) {
    if (!isWormsVaccine(vaccineType) || doseNumber != 2 || firstDoseDate == null) {
      return null;
    }

    final now = DateTime.now();
    final daysSinceFirstDose = now.difference(firstDoseDate).inDays;

    if (daysSinceFirstDose >= 14) {
      return 0; // Window is already open
    }

    return 14 - daysSinceFirstDose;
  }

  /// Get days remaining in worming vaccine window (until Day 20)
  ///
  /// Returns number of days until the 20-day window expires
  /// Returns null if not applicable or if before Day 14
  static int? getWormsWindowDaysRemaining(
    String vaccineType,
    int doseNumber,
    DateTime? firstDoseDate,
  ) {
    if (!isWormsVaccine(vaccineType) || doseNumber != 2 || firstDoseDate == null) {
      return null;
    }

    final now = DateTime.now();
    final daysSinceFirstDose = now.difference(firstDoseDate).inDays;

    // If before Day 14, window hasn't opened yet
    if (daysSinceFirstDose < 14) {
      return null;
    }

    // Calculate days remaining from current day to Day 20
    final daysRemaining = 20 - daysSinceFirstDose;
    return daysRemaining > 0 ? daysRemaining : 0;
  }

  /// Check if worming vaccine window is expired (after Day 20)
  static bool isWormsWindowExpired(
    String vaccineType,
    int doseNumber,
    DateTime? firstDoseDate,
  ) {
    if (!isWormsVaccine(vaccineType) || doseNumber != 2 || firstDoseDate == null) {
      return false;
    }

    final now = DateTime.now();
    final daysSinceFirstDose = now.difference(firstDoseDate).inDays;
    return daysSinceFirstDose > 20;
  }

  /// Get the date when worming 2nd dose window opens (Day 14)
  static DateTime? getWormsWindowOpenDate(DateTime? firstDoseDate) {
    if (firstDoseDate == null) return null;
    return firstDoseDate.add(const Duration(days: 14));
  }

  /// Get latest valid date for worming 2nd dose (Day 20)
  static DateTime? getWormsWindowCloseDate(DateTime? firstDoseDate) {
    if (firstDoseDate == null) return null;
    return firstDoseDate.add(const Duration(days: 20));
  }

  /// Get worming vaccination status message
  ///
  /// Returns a descriptive message about the current worming vaccine status
  static String getWormsVaccineStatusMessage(
    int doseNumber,
    DateTime? firstDoseDate,
  ) {
    if (doseNumber == 1 || firstDoseDate == null) {
      return 'First dose completed. Second dose required after 14 days.';
    }

    final now = DateTime.now();
    final daysSinceFirstDose = now.difference(firstDoseDate).inDays;

    if (daysSinceFirstDose < 14) {
      final daysUntil = 14 - daysSinceFirstDose;
      return 'Too early. Wait $daysUntil more day${daysUntil == 1 ? '' : 's'} (until Day 14).';
    } else if (daysSinceFirstDose <= 20) {
      final daysRemaining = 20 - daysSinceFirstDose;
      return 'Valid window! $daysRemaining day${daysRemaining == 1 ? '' : 's'} remaining to complete.';
    } else {
      return 'Window expired. Must restart vaccination series.';
    }
  }

  /// Check if dose is missed (more than 35 days since last dose without next dose)
  /// Applies to VIRUS, INSECTS, and RABIES vaccines
  static bool isDoseMissedAfter35Days(
    String vaccineType,
    int nextDoseNumber,
    DateTime? lastDoseDate,
  ) {
    if (lastDoseDate == null) return false;

    // Only applies to VIRUS, INSECTS, and RABIES
    if (!isVirusVaccine(vaccineType) &&
        !isInsectsVaccine(vaccineType) &&
        !isRabiesVaccine(vaccineType)) {
      return false;
    }

    final now = DateTime.now();
    final daysSinceLastDose = now.difference(lastDoseDate).inDays;

    // Check if more than 35 days have passed
    return daysSinceLastDose > 35;
  }

  /// Get message for missed dose based on vaccine type and dose number
  /// Returns appropriate message based on which dose was missed
  static String getMissedDoseMessage(
    String vaccineType,
    int missedDoseNumber,
  ) {
    // For VIRUS vaccines (3 doses)
    if (isVirusVaccine(vaccineType)) {
      if (missedDoseNumber == 2) {
        return 'Unfortunately, since the second dose was missed, your pet is no longer protected. You\'ll need to restart the vaccination series.';
      } else if (missedDoseNumber == 3) {
        return 'Your pet is still protected because it received the first two doses, but please give the third as soon as possible for full protection.';
      }
    }

    // For INSECTS (1 dose) - no missed dose scenario
    if (isInsectsVaccine(vaccineType)) {
      return 'Please administer the dose as soon as possible to protect your pet.';
    }

    // For RABIES (1 dose) - no missed dose scenario
    if (isRabiesVaccine(vaccineType)) {
      return 'Please administer the rabies vaccine as soon as possible. This vaccine is critical for your pet\'s safety.';
    }

    return 'Please contact your veterinarian about the missed dose.';
  }

  /// Check if vaccination series needs to be restarted due to missed dose
  static bool needsSeriesRestart(
    String vaccineType,
    int missedDoseNumber,
  ) {
    // VIRUS vaccine: restart needed if 2nd dose is missed
    if (isVirusVaccine(vaccineType) && missedDoseNumber == 2) {
      return true;
    }

    // Other vaccines don't require restart
    return false;
  }

  /// Get days since last dose
  static int? getDaysSinceLastDose(DateTime? lastDoseDate) {
    if (lastDoseDate == null) return null;
    final now = DateTime.now();
    return now.difference(lastDoseDate).inDays;
  }

  /// Get deadline date (Day 35 from last dose)
  static DateTime? getDay35Deadline(DateTime? lastDoseDate) {
    if (lastDoseDate == null) return null;
    return lastDoseDate.add(const Duration(days: 35));
  }
}

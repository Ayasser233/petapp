import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/vaccination/utils/vaccination_utils.dart';

/// Widget to display missed dose warning after Day 35
/// for VIRUS, INSECTS, and RABIES vaccines
///
/// Shows different messages based on:
/// - VIRUS 2nd dose missed: Must restart series
/// - VIRUS 3rd dose missed: Still protected, but need 3rd dose
/// - INSECTS/RABIES: Administer as soon as possible
class MissedDoseWarning extends StatelessWidget {
  final String vaccineType;
  final int nextDoseNumber; // The dose number that was missed
  final DateTime? lastDoseDate;
  final VoidCallback? onScheduleDose;
  final VoidCallback? onRestartSeries;

  const MissedDoseWarning({
    super.key,
    required this.vaccineType,
    required this.nextDoseNumber,
    this.lastDoseDate,
    this.onScheduleDose,
    this.onRestartSeries,
  });

  @override
  Widget build(BuildContext context) {
    // Only show for VIRUS, INSECTS, and RABIES vaccines
    if (!VaccinationUtils.isVirusVaccine(vaccineType) &&
        !VaccinationUtils.isInsectsVaccine(vaccineType) &&
        !VaccinationUtils.isRabiesVaccine(vaccineType)) {
      return const SizedBox.shrink();
    }

    // Check if dose is actually missed (past Day 35)
    final isMissed = VaccinationUtils.isDoseMissedAfter35Days(
      vaccineType,
      nextDoseNumber,
      lastDoseDate,
    );

    if (!isMissed) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context);
    final needsRestart = VaccinationUtils.needsSeriesRestart(vaccineType, nextDoseNumber);
    final daysSince = VaccinationUtils.getDaysSinceLastDose(lastDoseDate);
    final lastDoseDateFormatted = lastDoseDate != null
        ? DateFormat('MMM dd, yyyy').format(lastDoseDate!)
        : '';

    // Get appropriate message based on vaccine type and dose number
    String message;
    if (VaccinationUtils.isVirusVaccine(vaccineType)) {
      if (nextDoseNumber == 2) {
        message = localizations.missed2ndDoseVirusMessage;
      } else if (nextDoseNumber == 3) {
        message = localizations.missed3rdDoseVirusMessage;
      } else {
        message = VaccinationUtils.getMissedDoseMessage(vaccineType, nextDoseNumber);
      }
    } else if (VaccinationUtils.isInsectsVaccine(vaccineType)) {
      message = localizations.missedInsectsMessage;
    } else if (VaccinationUtils.isRabiesVaccine(vaccineType)) {
      message = localizations.missedRabiesMessage;
    } else {
      message = VaccinationUtils.getMissedDoseMessage(vaccineType, nextDoseNumber);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Icon and Title
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.warningMissedDose,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Warning Message
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Timeline Information
          if (lastDoseDate != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineItem(
                    context,
                    localizations.lastDoseGiven,
                    lastDoseDateFormatted,
                    Colors.green,
                    Icons.check_circle,
                  ),
                  if (daysSince != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.daysSinceLastDose,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$daysSince ${localizations.locale.languageCode == 'ar' ? "يوم" : "day${daysSince == 1 ? '' : 's'}"}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action Buttons
          if (needsRestart && onRestartSeries != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRestartSeries,
                icon: const Icon(Icons.replay),
                label: Text(localizations.restartVaccinationSeries),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ] else if (!needsRestart && onScheduleDose != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onScheduleDose,
                icon: const Icon(Icons.calendar_today),
                label: Text(localizations.scheduleNextDose),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    String date,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}


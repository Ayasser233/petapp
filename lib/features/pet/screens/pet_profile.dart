import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/vaccination/presentation/cubit/vaccination_cubit.dart';
import 'package:petapp/features/vaccination/presentation/cubit/vaccination_state.dart';
import 'package:petapp/features/vaccination/presentation/screens/pet_vaccination_record_screen.dart';
import 'package:petapp/features/vaccination/presentation/screens/add_vaccination_screen.dart';
import 'package:petapp/features/medical_records/presentation/screens/medical_records_screen.dart';
import 'package:petapp/features/medical_records/presentation/cubit/medical_records_cubit.dart';
import 'package:petapp/features/medical_records/presentation/cubit/medical_records_state.dart';
import 'package:petapp/di/service_locator.dart';
import 'dart:io';

class PetProfileScreen extends StatefulWidget {
  final PetModel pet;

  const PetProfileScreen({
    super.key,
    required this.pet,
  });

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  late final PetController _petController;
  bool _isDeleting = false;
  late PetModel _currentPet;

  @override
  void initState() {
    super.initState();
    _petController = Get.find<PetController>();
    _currentPet = widget.pet;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = THelperFunctions.isDarkMode(context);
    final age = _calculateAge(_currentPet.dateOfBirth, localizations);
    const Color themeColor = AppColors.orange;

    final Color backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.grey[800]!;
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final Color cardBorderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final Color notesBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: themeColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final result = await Get.toNamed(AppRoutes.updatePet, arguments: _currentPet);
                  if (result == true) {
                    final updatedPet = _petController.pets.firstWhereOrNull((p) => p.id == _currentPet.id);
                    if (updatedPet != null && mounted) { setState(() => _currentPet = updatedPet); }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () => _showDeleteConfirmation(context, isDark),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildPetImage(),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)]))),
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_currentPet.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: Text(_currentPet.species, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: Text(age, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildInfoCard(context, localizations.birthday, _formatDate(_currentPet.dateOfBirth, localizations), Icons.cake, themeColor, isDark),
                      const SizedBox(width: 16),
                      _buildInfoCard(context, localizations.species, _currentPet.species.toUpperCase(), _currentPet.species.toLowerCase() == 'dog' ? Icons.pets : Icons.emoji_nature, themeColor, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_currentPet.gender != null)
                        Expanded(child: _buildInfoCard(context, localizations.gender, _currentPet.gender == 'MALE' ? localizations.male : localizations.female, _currentPet.gender == 'MALE' ? Icons.male : Icons.female, themeColor, isDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_currentPet.spayNeuterStatus != null)
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: cardBorderColor)),
                      child: Row(
                        children: [
                          const Icon(Icons.medical_services, color: themeColor, size: 24),
                          const SizedBox(width: 12),
                          Text(_currentPet.spayNeuterStatus! ? localizations.spayedNeutered : localizations.notSpayedNeutered, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (_currentPet.allergies != null && _currentPet.allergies!.isNotEmpty) ...[
                    _buildSectionHeader(localizations.allergies, Icons.warning_amber, themeColor, textColor),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _currentPet.allergies!.map((allergy) => Chip(
                        label: Text(allergy), backgroundColor: AppColors.orange.withValues(alpha: 0.2), labelStyle: TextStyle(color: textColor),
                        avatar: const Icon(Icons.warning_amber, size: 18, color: AppColors.orange),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_currentPet.notes != null && _currentPet.notes!.isNotEmpty) ...[
                    _buildSectionHeader(localizations.notes, Icons.note_alt, themeColor, textColor),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: notesBgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: cardBorderColor)),
                      child: Text(_currentPet.notes!, style: TextStyle(color: textColor, height: 1.5)),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionHeader(localizations.vaccinations, Icons.medical_services, themeColor, textColor),
                  const SizedBox(height: 8),
                  _buildVaccinationSummaryCard(context, cardColor, textColor, subTextColor, cardBorderColor, isDark, localizations),
                  const SizedBox(height: 24),
                  _buildSectionHeader(localizations.medicalRecords, Icons.history, themeColor, textColor),
                  const SizedBox(height: 8),
                  _buildMedicalRecordsSummaryCard(context, cardColor, textColor, subTextColor, cardBorderColor, localizations),
                  const SizedBox(height: 24),
                  _buildSectionHeader(localizations.medicalDetails, Icons.health_and_safety, themeColor, textColor),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: cardBorderColor)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentPet.weight != null) ...[_buildMedicalDetailRow(localizations.weight, '${_currentPet.weight} ${localizations.kg}', Icons.monitor_weight, textColor, subTextColor), const SizedBox(height: 12)],
                        if (_currentPet.gender != null) ...[_buildMedicalDetailRow(localizations.gender, _currentPet.gender == 'MALE' ? localizations.male : localizations.female, _currentPet.gender == 'MALE' ? Icons.male : Icons.female, textColor, subTextColor), const SizedBox(height: 12)],
                        if (_currentPet.spayNeuterStatus != null) ...[_buildMedicalDetailRow(localizations.spayedNeuteredQuestion, _currentPet.spayNeuterStatus! ? localizations.yes : localizations.no, Icons.medical_services, textColor, subTextColor), const SizedBox(height: 12)],
                        if (_currentPet.allergies != null && _currentPet.allergies!.isNotEmpty) ...[_buildMedicalDetailRow(localizations.allergies, _currentPet.allergies!.join(', '), Icons.warning_amber, textColor, subTextColor), const SizedBox(height: 12)],
                        if (_currentPet.medicalHistory?.lastVetVisit != null) ...[_buildMedicalDetailRow(localizations.lastVetVisit, _formatDate(_currentPet.medicalHistory!.lastVetVisit!, localizations), Icons.event, textColor, subTextColor)],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, Color textColor) {
    return Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor))]);
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, Color color, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.grey[800];
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withValues(alpha: isDark ? 0.15 : 0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: color, size: 16), const SizedBox(width: 4), Text(title, style: TextStyle(color: subTextColor, fontSize: 14))]),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
        ],
      ),
    );
  }

  String _formatDate(String dateString, AppLocalizations l10n) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    if (date.year == now.year) { return DateFormat('MMM dd', l10n.locale.languageCode).format(date); }
    else { return DateFormat('MMM dd, yyyy', l10n.locale.languageCode).format(date); }
  }

  String _calculateAge(String birthdate, AppLocalizations l10n) {
    final birth = DateTime.parse(birthdate);
    final now = DateTime.now();
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;
    if (days < 0) { months--; final previousMonth = DateTime(now.year, now.month, 0); days += previousMonth.day; }
    if (months < 0) { years--; months += 12; }
    if (years > 0) return '$years ${years == 1 ? l10n.years.substring(0, l10n.years.length - 1) : l10n.years}';
    if (months > 0) return '$months ${l10n.months}';
    return '$days ${l10n.days}';
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.confirmDelete, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[isDark ? 300 : 400], size: 48),
            const SizedBox(height: 16),
            Text(l10n.areYouSureDeletePet, textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 8),
            Text(l10n.thisActionCannotBeUndone, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel, style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]))),
          ElevatedButton.icon(
            onPressed: _isDeleting ? null : () async {
              Navigator.pop(context); setState(() => _isDeleting = true);
              try {
                final success = await _petController.deletePet(_currentPet.id);
                if (success) { Get.back(); Get.snackbar(l10n.success, '${_currentPet.name} ${l10n.delete}'); }
              } catch (e) { Get.snackbar(l10n.error, l10n.tryAgain); }
              finally { if (mounted) setState(() => _isDeleting = false); }
            },
            icon: _isDeleting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.delete_outline, size: 16),
            label: Text(_isDeleting ? l10n.deleting : l10n.delete),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationSummaryCard(BuildContext context, Color cardColor, Color textColor, Color subTextColor, Color borderColor, bool isDark, AppLocalizations l10n) {
    return BlocProvider(
      create: (context) => sl<VaccinationCubit>()..getMedicalSheet(_currentPet.id),
      child: BlocBuilder<VaccinationCubit, VaccinationState>(
        builder: (context, state) {
          if (state is VaccinationLoading) return Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)), child: const Center(child: CircularProgressIndicator(color: AppColors.orange)));
          if (state is MedicalSheetLoaded) {
            final ms = state.medicalSheet;
            final hasRecords = ms.vaccinationSeries.isNotEmpty || ms.annualBoosters.isNotEmpty;
            return Container(
              width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasRecords) ...[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildVaccinationStat(l10n.completedStatus, ms.completedDosesCount.toString(), Icons.check_circle, Colors.green, textColor), _buildVaccinationStat(l10n.upcoming, ms.totalUpcomingDoses.toString(), Icons.schedule, Colors.blue, textColor), _buildVaccinationStat(l10n.overdue, ms.totalAnnualBoosters.toString(), Icons.warning, Colors.red, textColor)]),
                    const SizedBox(height: 16), const Divider(), const SizedBox(height: 12),
                    Text(l10n.vaccines, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 8),
                    ...ms.vaccinationSeries.map((series) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(children: [Icon(series.isComplete ? Icons.check_circle : Icons.schedule, size: 16, color: series.isComplete ? Colors.green : AppColors.orange), const SizedBox(width: 8), Expanded(child: Text(_getVaccineCategory(series.vaccineType, l10n), style: TextStyle(fontSize: 13, color: textColor))), Text('${series.completedDoses}/${series.totalDoses}', style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w500))]),
                    )),
                  ] else ...[
                    Row(children: [const Icon(Icons.vaccines, color: AppColors.orange, size: 40), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.noVaccinationRecords, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)), const SizedBox(height: 4), Text(l10n.addYourPetsFirstVaccine, style: TextStyle(fontSize: 13, color: subTextColor))]))]),
                  ],
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: ElevatedButton.icon(onPressed: () async {
                      final cubit = context.read<VaccinationCubit>();
                      final result = await Get.to(() => BlocProvider.value(value: cubit, child: AddVaccinationScreen(petId: _currentPet.id, petName: _currentPet.name, petSpecies: _currentPet.species)));
                      if (result == true && context.mounted) cubit.getMedicalSheet(_currentPet.id);
                    }, icon: const Icon(Icons.add, size: 18), label: Text(l10n.addVaccine), style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
                    if (hasRecords) ...[const SizedBox(width: 12), Expanded(child: OutlinedButton.icon(onPressed: () => Get.to(() => BlocProvider(create: (context) => sl<VaccinationCubit>()..getMedicalSheet(_currentPet.id), child: PetVaccinationRecordScreen(pet: _currentPet))), icon: const Icon(Icons.medical_information, size: 18), label: Text(l10n.viewAll), style: OutlinedButton.styleFrom(foregroundColor: AppColors.orange, side: const BorderSide(color: AppColors.orange), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))))]
                  ]),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildVaccinationStat(String label, String value, IconData icon, Color iconColor, Color textColor) {
    return Column(children: [Icon(icon, color: iconColor, size: 28), const SizedBox(height: 4), Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: iconColor)), Text(label, style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.7)))]);
  }

  String _getVaccineCategory(String vaccineType, AppLocalizations l10n) {
    final type = vaccineType.toUpperCase();
    if (type.contains('MONOVALENT')) return l10n.monovalent;
    if (type.contains('BIVALENT')) return l10n.bivalent;
    if (type.contains('TRIVALENT')) return l10n.trivalent;
    if (type.contains('QUADRIVALENT')) return l10n.quadrivalent;
    if (type.contains('PENTAVALENT')) return l10n.pentavalent;
    if (type.contains('HEXAVALENT')) return l10n.hexavalent;
    if (type.contains('HEPTAVALENT')) return l10n.heptavalent;
    if (type.contains('OCTAVALENT')) return l10n.octavalent;
    if (type.contains('WORMS')) return l10n.deworming;
    if (type.contains('INSECTS')) return l10n.antiInsects;
    if (type.contains('RABIES')) return l10n.rabies;
    return l10n.vaccine;
  }

  Widget _buildMedicalRecordsSummaryCard(BuildContext context, Color cardColor, Color textColor, Color subTextColor, Color borderColor, AppLocalizations l10n) {
    return BlocProvider(
      create: (context) => sl<MedicalRecordsCubit>()..loadMedicalRecords(_currentPet.id, refresh: true),
      child: BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
        builder: (context, state) {
          return Container(
            width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is MedicalRecordsLoaded && state.records.isNotEmpty) ...[
                  Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.orange.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.history, color: AppColors.orange, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.latestRecord, style: TextStyle(fontSize: 12, color: subTextColor)), Text(state.records.first.eventType.name.capitalizeFirst!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))])),
                    Text(_formatDate(state.records.first.occurredAt.toIso8601String(), l10n), style: TextStyle(fontSize: 12, color: subTextColor)),
                  ]),
                  const SizedBox(height: 16),
                ] else ...[
                  Row(children: [Icon(Icons.history, color: AppColors.orange.withValues(alpha: 0.5), size: 32), const SizedBox(width: 12), Text(l10n.noMedicalRecordsYet, style: TextStyle(color: subTextColor))]),
                  const SizedBox(height: 16),
                ],
                SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Get.to(() => MedicalRecordsScreen(pet: _currentPet)), style: OutlinedButton.styleFrom(foregroundColor: AppColors.orange, side: const BorderSide(color: AppColors.orange), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(l10n.viewAllRecords))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicalDetailRow(String label, String value, IconData icon, Color textColor, Color subTextColor) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 20, color: subTextColor), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 14, color: subTextColor)), const SizedBox(height: 2), Text(value, style: TextStyle(fontSize: 16, color: textColor))]))]);
  }

  Widget _buildPetImage() {
    final String primaryImage = _currentPet.imageUrl ?? _currentPet.image;
    final isNetworkImage = primaryImage.startsWith('http://') || primaryImage.startsWith('https://') || primaryImage.startsWith('www.');
    final isLocalFile = !isNetworkImage && !primaryImage.startsWith('assets/');
    if (isNetworkImage) {
      return CachedNetworkImage(imageUrl: primaryImage, width: double.infinity, fit: BoxFit.cover, placeholder: (context, url) => Container(width: double.infinity, color: AppColors.orange.withValues(alpha: 0.1), child: const Center(child: CircularProgressIndicator(color: AppColors.orange, strokeWidth: 3))), errorWidget: (context, url, error) => _buildFallbackImage());
    } else if (isLocalFile) {
      return Image.file(File(primaryImage), width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildFallbackImage());
    }
    else {
      return Image.asset(primaryImage, width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage());
    }
  }

  Widget _buildFallbackImage() => Container(width: double.infinity, color: AppColors.orange.withValues(alpha: 0.2), child: Center(child: Icon(_currentPet.species.toLowerCase() == 'dog' ? Icons.pets : Icons.pets, size: 100, color: Colors.white.withValues(alpha: 0.5))));
}
